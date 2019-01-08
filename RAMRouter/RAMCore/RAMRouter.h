//
//  RAMRouter.h
//  Pods-QJYRouter
//
//  Created by 裘俊云 on 2018/11/13.
//

#import <Foundation/Foundation.h>
#import "RAMRouterConfig.h"
#import "RAMRouterParam.h"
#import "RAMRouterHeader.h"

/// 每个注册进router的controller，都需要实现该接口
@protocol RAMRouteTargetProtocol <NSObject>

@required
/*！
 * 方法内部必须写 RAM_EXPORT() 宏，改方法的应用解释详细见
 * https://www.jianshu.com/p/9dbbdca2515e
 * 在应用加载的时候通过section读取到每个实现了此宏的类方法
 * 并以此解析出注册了router的类
 */
+ (RAMRouterConfig *)configureRouter;

@optional
/// 当注册页面被route的时候，回调此方法，用以通知route的参数
- (void)receiveRoute:(RAMRouterParam *)param;

@end

/// 高性能路由，路径匹配使用的 c9s/r3 https://github.com/c9s/r3
@interface RAMRouter : NSObject
/// 使用单例初始化
+ (instancetype)sharedRouter;

/*!
 * route页面跳转方法
 * 使用举例:
 * RAMRouterParam *param = [[RAMRouterParam alloc] init];
 * param.url = @"scheme://path";
 * param.launchMode = RAMControllerLaunchModePushNavigation;
 * param.params = @{@"paramKey":paramValue};
 * [[RAMRouter sharedRouter] route:param];
 */
- (UIViewController*)route:(RAMRouterParam*)param;

/// r3 dump 打印所有注册的Router url信息
- (void)dumpRouter;

/// url是否注册
- (BOOL)didRegistered:(RAMRouterParam*)param;
@end
