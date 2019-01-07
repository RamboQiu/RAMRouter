//
//  UIViewController+RAMUtils.m
//  RAMRouter
//
//  Created by 裘俊云 on 2018/11/15.
//

#import "UIViewController+RAMUtils.h"

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
@end
