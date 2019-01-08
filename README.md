RAMRouter
---
RAMRouter ：使用URL来定位页面及页面导航。

特性
---
* 去中心化的URL配置方式
* 高性能的URL匹配算法，支持通配符和正则表达式
* 支持跨应用或web view和native请求的响应，http链接升级成native页面

用法
---
###页面配置
配置页面，注册URL到Router
```
+ (RAMRouterConfig *)configureRouter {
    RAM_EXPORT();
    RAMRouterConfig *config = [[RAMRouterConfig alloc] initWithUrlPath:[self urlPath]];
    return config;
}
+ (NSString*)urlPath {
    return @"router://viewcontroller1";
}
```

###接口使用
```
RAMRouterParam *param = [[RAMRouterParam alloc] init];
param.url = @"router://viewcontroller2";
param.launchMode = RAMControllerLaunchModePushNavigation;
param.params = @{@"paramKey":@"viewcontroller1"};
[[RAMRouter sharedRouter] route:param];
```

安装
---
###	CocoaPods

1. `pod 'RAMRouter' , :git=>'https://github.com/RamboQiu/RAMRouter.git'`
2. `pod install`或`pod update`
3. \#import "RAMRouter.h"
	
系统要求
---

该项目最低支持`iOS 8.0`和`Xcode 8.0`

许可证
---

RAMRouter，详情见LICENSE文件。