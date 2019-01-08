//
//  RAMContainerViewController.m
//  Pods-QJYRouter
//
//  Created by 裘俊云 on 2019/1/3.
//

#import "RAMContainerViewController.h"
#import "RAMNavigationController.h"

@implementation RAMContainerViewController
- (id)initWithRootViewController:(UIViewController*)vc {
    return [self initWithRootViewController:vc navigationDelegateClass:nil];
}

- (id)initWithRootViewController:(UIViewController *)vc navigationDelegateClass:(Class)cls {
    if (self = [super init]){
        RAMNavigationController *naviVC = [[RAMNavigationController alloc] initWithRootViewController:vc];
        
        [self addChildViewController:naviVC];
        
        if ([vc conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
            [(id<RAMContainerViewControllerProtocol>)vc setContainerController:self];
        }
        
        _rootNavigationController = naviVC;
    }
    
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 修复通电话的时候，结束电话，UI错乱的问题
    // iOS 9.x/10.x上通话时该view的y坐标会被偏移20dp，导致UI错乱，此处将其强行置为0，修复该问题
    if (([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] == NSOrderedDescending) &&
        ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] == NSOrderedAscending)) {
        if ((int)[UIApplication sharedApplication].statusBarFrame.size.height == 40) {
            CGRect newFrame = self.view.frame;
            if ((int)newFrame.origin.y == 20) {
                newFrame.origin.y = 0;
                self.view.frame = newFrame;
            }
        }
    }
    self.rootNavigationController.view.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.rootNavigationController.view];
}
@end
