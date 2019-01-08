//
//  RAMRouter.m
//  Pods-QJYRouter
//
//  Created by 裘俊云 on 2018/11/13.
//

#import "RAMRouter.h"
#import "RAMRouterCollection.h"
#import "RAMRouterConfig.h"
#import "RAMRouterParam.h"
#import "RAMRouterR3PathMatcher.h"
#import "UIViewController+RAMUtils.h"
#import "RAMNavigationController.h"
#import <RAMUtil/RAMAdditionalLogger.h>
#import "RAMContainerViewController.h"

@interface RAMRouter()
@property (nonatomic, strong) NSMutableArray<Class> *routeControllerClasses;

@property (nonatomic, strong) NSMutableDictionary<NSString *, RAMRouterConfig *> *routeControllerInfos;

@property (nonatomic, strong) Class navigationDelegateClass;

@property (nonatomic, strong) RAMRouterR3PathMatcher *r3URLMatcher;
@end

@implementation RAMRouter
+ (instancetype)sharedRouter {
    static RAMRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[RAMRouter alloc] init];
    });
    
    return router;
}

- (instancetype)init {
    self = [super init];
    if (self){
        [self loadAllRouterInfos];
    }
    
    return self;
}

- (void)loadAllRouterInfos {
    _routeControllerInfos = [NSMutableDictionary new];
    
    NSArray *classes = RAMExportedMethodsByModuleID();
    if (classes)
        _routeControllerClasses = [NSMutableArray arrayWithArray:classes];
    else
        _routeControllerClasses = [NSMutableArray new];
    
    _r3URLMatcher = [RAMRouterR3PathMatcher new];
    
    for (Class cls in _routeControllerClasses) {
        NSAssert([cls conformsToProtocol:@protocol(RAMRouteTargetProtocol)], @"RAMRouterConfig class:%@ not conform to protocol:%@", cls, @protocol(RAMRouteTargetProtocol));
        
        RAMRouterConfig *config = (RAMRouterConfig*)[cls configureRouter];
        NSAssert([config isMemberOfClass:RAMRouterConfig.class], @"RAMRouterConfig type error");
        
        config.viewControllerClass = cls;
        [_routeControllerInfos setObject:config forKey:NSStringFromClass(cls)];
        
        [_r3URLMatcher addRAMControllerRouterConfig:config];
    }
    
    [_r3URLMatcher compile];
}

- (void)dumpRouter {
    [_r3URLMatcher dump];
}

- (BOOL)didRegistered:(RAMRouterParam *)param {
    NSAssert(param.url.length > 0, @"route url param error");
    
    RAMRouterConfig *foundRouterConfig;
    
    if (param.url){
        NSMutableDictionary *params = [NSMutableDictionary new];
        foundRouterConfig = [_r3URLMatcher matchURL:param.url matchedParams:params];
    }
    
    if (foundRouterConfig) {
        return YES;
    } else {
        return NO;
    }
}

- (UIViewController *)route:(RAMRouterParam *)param {
    NSAssert(param.url.length > 0 , @"route url param error");
    
    RAMRouterConfig *foundRouterConfig;
    NSDictionary *urlParams;
    if (param.url){
        NSMutableDictionary *params = [NSMutableDictionary new];
        foundRouterConfig = [_r3URLMatcher matchURL:param.url matchedParams:params];
        if (params.count > 0)
            urlParams = params;
    }
    RAMRouterParam *routeParam = [param copy];
    
    if (foundRouterConfig){
        routeParam.urlParams = urlParams;
        
        return [self routeViewController:foundRouterConfig withParam:routeParam];
    } else {
        RAMLOG_INFO(@"Cannot find route config to param:%@", param);
    }
    return nil;
}

- (UIViewController*)routeViewController:(RAMRouterConfig *)routeConfig
                               withParam:(RAMRouterParam *)param {
    
    UIViewController *vc = [routeConfig.viewControllerClass new];
    if (!vc){
        RAMLOG_INFO(@"Cannot find route config to param:%@", param);
        return nil;
    }
    
    RAMLOG_INFO(@"route:%@", param);
    
    RAMControllerLaunchMode launchMode = param.launchMode == RAMControllerLaunchModeDefault ? routeConfig.launchMode : param.launchMode;
    RAMControllerInstanceShowMode singleInstanceShowMode = param.singleInstanceShowMode == RAMControllerInstanceShowModeDefault ? routeConfig.singleInstanceShowMode : param.singleInstanceShowMode;
    
    param.launchMode = launchMode;
    param.singleInstanceShowMode = singleInstanceShowMode;
    
    [self launchController:vc withConfig:routeConfig param:param];
    
    if ([vc respondsToSelector:@selector(receiveRoute:)]){
        [(id<RAMRouteTargetProtocol>)vc receiveRoute:param];
    }
    
    //处理使用childVC包裹目标页的情况
    for (UIViewController * childController in vc.childViewControllers) {
        if ([childController isKindOfClass:[UINavigationController class]]) {
            UIViewController * innerController = [(UINavigationController*)childController viewControllers].firstObject;
            if ([innerController respondsToSelector:@selector(receiveRoute:)]){
                [(id<RAMRouteTargetProtocol>)innerController receiveRoute:param];
            }
        }
    }
    return vc;
}


- (void)launchController:(UIViewController *)viewController
              withConfig:(RAMRouterConfig *)config
                   param:(RAMRouterParam *)param {
    NSAssert(param.launchMode == RAMControllerLaunchModePush ||
             param.launchMode == RAMControllerLaunchModePresent ||
             param.launchMode == RAMControllerLaunchModePushNavigation ||
             param.launchMode == RAMControllerLaunchModePresentNavigation, @"Params Error");
    
    UIViewController *fromViewController = param.fromViewController;
    
    switch (param.launchMode) {
        case RAMControllerLaunchModePush:
        default: {
            RAMLOG_INFO(@"launch normal push");
            
            if (!fromViewController){
                UIViewController *topmostViewController = [UIViewController ram_topMostController];
                fromViewController = [topmostViewController ram_innerMostNavigationController];
                if (!fromViewController){
                    RAMLOG_INFO(@"cannot auto find from view controller");
                    return;
                }
            }
            
            if ([fromViewController isKindOfClass:UINavigationController.class]){
                [(UINavigationController*)fromViewController pushViewController:viewController animated:param.bAnimate];
            } else {
                [fromViewController.navigationController pushViewController:viewController animated:param.bAnimate];
            }
        } break;
            
        case RAMControllerLaunchModePresent: {
            RAMLOG_INFO(@"launch normal present");
            
            if (!fromViewController){
                fromViewController = [UIViewController ram_topMostController];
            }
            
            [fromViewController presentViewController:viewController animated:param.bAnimate completion:^{
            }];
        } break;
            
        case RAMControllerLaunchModePushNavigation: {
            RAMLOG_INFO(@"launch push navigation");
            
            [self pushNavigationWrappedController:viewController withConfig:config param:param];
        } break;
            
        case RAMControllerLaunchModePresentNavigation: {
            RAMLOG_INFO(@"launch present navigation");
            
            [self presentNavigationWrappedController:viewController withConfig:config param:param];
        } break;
    }
}

- (void)pushNavigationWrappedController:(UIViewController *)viewController
                             withConfig:(RAMRouterConfig *)config
                                  param:(RAMRouterParam *)param {
    UIViewController *fromViewController = param.fromViewController;
    if (!fromViewController){
        UIViewController *topmostViewController = [UIViewController ram_topMostController];
        fromViewController = [topmostViewController ram_innerMostNavigationControllerWithNavigationBarHidden:YES];
        if (!fromViewController){
            RAMLOG_INFO(@"cannot auto find from view controller");
            return;
        }
    }
    
    RAMContainerViewController *container = [[RAMContainerViewController alloc] initWithRootViewController:viewController navigationDelegateClass:_navigationDelegateClass];
    if ([fromViewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationController = (UINavigationController *)fromViewController;
        [navigationController pushViewController:container animated:param.bAnimate];
    } else {
        [fromViewController.navigationController pushViewController:container animated:param.bAnimate];
    }
}

- (void)presentNavigationWrappedController:(UIViewController *)viewController
                                withConfig:(RAMRouterConfig *)config
                                     param:(RAMRouterParam *)param {
    UIViewController *fromViewController = param.fromViewController;
    if (!fromViewController){
        fromViewController = [UIViewController ram_topMostController];
    }
    RAMContainerViewController *container = [[RAMContainerViewController alloc] initWithRootViewController:viewController navigationDelegateClass:_navigationDelegateClass];
    RAMNavigationController *rootNavigationController = [[RAMNavigationController alloc] initWithRootViewController:container];
    
    [rootNavigationController setNavigationBarHidden:YES animated:NO];
    [fromViewController presentViewController:rootNavigationController animated:param.bAnimate completion:^{
    }];
}
@end
