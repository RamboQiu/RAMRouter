//
//  UIViewController+RAMUtils.m
//  RAMRouter
//
//  Created by 裘俊云 on 2018/11/15.
//

#import "UIViewController+RAMUtils.h"
#import "RAMContainerViewController.h"

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
