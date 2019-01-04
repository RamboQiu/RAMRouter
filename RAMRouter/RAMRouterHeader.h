//
//  RAMRouterHeader.h
//  Pods
//
//  Created by 裘俊云 on 2018/11/14.
//

#ifndef RAMRouterHeader_h
#define RAMRouterHeader_h

//如何加载vc
typedef NS_ENUM(NSInteger, RAMControllerLaunchMode){
    RAMControllerLaunchModeDefault,
    RAMControllerLaunchModeNOAction,
    RAMControllerLaunchModePush,
    RAMControllerLaunchModePresent,
    RAMControllerLaunchModePushNavigation,
    RAMControllerLaunchModePresentNavigation
};

//单实例vc如何显示
typedef NS_ENUM(NSInteger, RAMControllerInstanceShowMode){
    RAMControllerInstanceShowModeDefault,
    RAMControllerInstanceShowModeNOAction,
    RAMControllerInstanceShowModeMoveToTop,
    RAMControllerInstanceShowModeClearToTop
};

#define RAM_EXPORT() __attribute__((used, section("__DATA,RAMExport" \
))) static const char *__ram_export_entry__[] = { __func__}

#endif /* RAMRouterHeader_h */
