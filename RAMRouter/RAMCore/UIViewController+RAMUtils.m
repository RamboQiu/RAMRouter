//
//  UIViewController+RAMUtils.m
//  RAMRouter
//
//  Created by 裘俊云 on 2018/11/15.
//

#import "UIViewController+RAMUtils.h"
#import "RAMContainerViewController.h"
#import "RAMRouterConfig.h"
#import "RAMRouter.h"

@implementation UIViewController (RAMUtils)

+ (UIViewController *)ram_applicationRootViewController {
    return [UIApplication sharedApplication].windows[0].rootViewController;
}

+ (UIViewController *)ram_topMostController {
    UIViewController *topController = [self ram_applicationRootViewController];
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (BOOL)ram_isControllerInPresentedControllerChain {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController) {
        if (self == topController)
            return YES;
        
        topController = topController.presentedViewController;
    }
    
    return NO;
}

- (UINavigationController *)ram_innerMostNavigationController {
    UINavigationController *foudController = [self isKindOfClass:UINavigationController.class] ? (UINavigationController*)self : nil;
    
    UIViewController *currentViewController = self;
    while (currentViewController) {
        UIViewController *childViewController = currentViewController.childViewControllers.lastObject;
        if ([childViewController isKindOfClass:UINavigationController.class]){
            foudController = (UINavigationController*)childViewController;
        }
        
        currentViewController = childViewController;
    }
    
    return foudController;
    
}
- (UIViewController *)ram_currentChildViewController {
    return self.childViewControllers.lastObject;
}

- (UINavigationController *)ram_innerMostNavigationControllerWithNavigationBarHidden:(BOOL)bHidden {
    UINavigationController *foudController = [self isKindOfClass:UINavigationController.class] ? (UINavigationController*)self : nil;
    
    UIViewController *currentViewController = self;
    while (currentViewController) {
        UIViewController *childViewController = [currentViewController ram_currentChildViewController];
        if ([childViewController isKindOfClass:UINavigationController.class] &&
            [(UINavigationController*)childViewController isNavigationBarHidden] == bHidden){
            foudController = (UINavigationController*)childViewController;
        }
        
        currentViewController = childViewController;
    }
    
    return foudController;
}

- (void)ram_removeFromPresentedControllerChain:(RemoveControllerFromTreeCallback)cb {
    UIViewController *presentingController = self.presentingViewController;
    UIViewController *presentedController = self.presentedViewController;
    if (presentingController == nil){
        [self dismissViewControllerAnimated:NO completion:^{
            cb(YES);
        }];
        return;
    }
    
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:NO completion:^{
            [presentingController dismissViewControllerAnimated:NO completion:^{
                if (presentedController)
                    [presentingController presentViewController:presentedController animated:NO completion:^{
                        cb(YES);
                    }];
            }];
        }];
    } else {
        [presentingController dismissViewControllerAnimated:NO completion:^{
            if (presentedController)
                [presentingController presentViewController:presentedController animated:NO completion:^{
                    cb(YES);
                }];
        }];
    }
}

- (void)ram_removeFromNavigationController {
    NSAssert([self.navigationController.viewControllers indexOfObject:self] != NSNotFound, @"controller is not in navigationcontroller");
    
    UINavigationController *navigationController = self.navigationController;
    NSMutableArray *vcs = [[navigationController viewControllers] mutableCopy];
    [vcs removeObject:self];
    [navigationController setViewControllers:vcs animated:NO];
}

/*
 ==========================================================
 关于问题：将一个ViewController显示出来，先从原来的tree中删除，然后放在当前显示的tree上！
 
 当ViewController由container包裹，
 1. 如果container的innerNavigationController的childViewController个数等于1，那么等价于删除ContainerViewController
 2. 如果container的innerNavigationController的childViewController个数大于1，无法处理，直接报错
 
 ---------------
 
 1. 当viewcontroller在另外一个navigation controller中：
 1. 如果navigation controller的child view controller个数大于1， 那么直接删除view controller
 2. 如果navigation controller的child view controller个数等于1
 当navigation controller在presented 链上，那么从链上删除这个vc
 否则报错
 
 2. 如果viewcontroller在presented 链上，那么直接从链上删除（如果是根，dismiss其他vc）
 
 3. 其他所有情况均无法删除
 */
- (void)ram_removeFromControllerTree:(RemoveControllerFromTreeCallback)cb {
    RAMContainerViewController *containerViewController;
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        containerViewController = [(id<RAMContainerViewControllerProtocol>)self containerController];
    }
    
    if (containerViewController) {
        if (containerViewController.rootNavigationController.viewControllers.count == 1){
            return [containerViewController ram_removeFromControllerTree:cb];
        } else {
            return cb(NO);
        }
    }
    
    if ([self ram_isControllerInPresentedControllerChain]){
        return [self ram_removeFromPresentedControllerChain:cb];
    }
    
    if ([self.parentViewController isKindOfClass:UINavigationController.class]){
        UINavigationController *parentNavigationController = (UINavigationController*)self.parentViewController;
        if (parentNavigationController.childViewControllers.count > 1){
            [self ram_removeFromNavigationController];
            return cb(YES);
        }
        else if (parentNavigationController.childViewControllers.count == 1 &&
                 [parentNavigationController ram_isControllerInPresentedControllerChain]){
            return [parentNavigationController ram_removeFromPresentedControllerChain:cb];
        }
        
        return cb(NO);
    }
    
    return cb(NO);
}

- (void)ram_removeByUrlPaths:(NSArray<NSString *> *)urlPaths callback:(RemoveControllerFromTreeCallback)cb {
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        UINavigationController *containerNavigationController = [(id<RAMContainerViewControllerProtocol>)self containerController].navigationController;
        NSArray *containerArr = containerNavigationController.viewControllers;
        NSMutableArray *removeList = [NSMutableArray array];
        for (NSInteger i = 0; i < containerArr.count; i ++) {
            id obj = [containerArr objectAtIndex:i];
            if (![obj isKindOfClass:[RAMContainerViewController class]]) {
                continue;
            }
            RAMContainerViewController *privousVC = (RAMContainerViewController *)obj;
            UIViewController *firstObject = privousVC.rootNavigationController.viewControllers.firstObject;
            if ([firstObject.class conformsToProtocol:@protocol(RAMRouteTargetProtocol)]) {
                RAMRouterConfig *config = (RAMRouterConfig*)[firstObject.class configureRouter];
                for (NSString *url in config.urls) {
                    if ([urlPaths containsObject:url]) {
                        [removeList addObject:privousVC];
                    }
                }
            }
        }
        UINavigationController *navigationController = self.navigationController;
        NSMutableArray *vcs = [[navigationController viewControllers] mutableCopy];
        [vcs removeObjectsInArray:removeList];
        [navigationController setViewControllers:vcs animated:NO];
    }
}

- (void)ram_back {
    if (self.navigationController.viewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        UINavigationController *containerNavigationController = [(id<RAMContainerViewControllerProtocol>)self containerController].navigationController;
        if (containerNavigationController.viewControllers.count > 1){
            [containerNavigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    if (self.presentingViewController){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
}
@end
