//
//  RAMContainerViewController.h
//  Pods-QJYRouter
//
//  Created by 裘俊云 on 2019/1/3.
//

#import <UIKit/UIKit.h>
@class RAMContainerViewController;
@protocol RAMContainerViewControllerProtocol <NSObject>
@property (nonatomic, weak) RAMContainerViewController *containerController;
@end
/*!
 *  包裹了一个Navigation Controller的Container Controller。
 *  直接push navigationcontroller 会有报错“Pushing a navigation controller is not supported”
 */
@interface RAMContainerViewController : UIViewController
/*!
 *  包裹的NavigationController
 */
@property (nonatomic, strong) UINavigationController *rootNavigationController;


/*!
 *  RAMContainerViewController(self) --> RAMNavigationController --root view controller --> vc
 *
 *  @param vc 被包裹的view controller实例
 *
 *  @return 实例对象
 */
- (id)initWithRootViewController:(UIViewController*)vc;

/*!
 *  跟上个函数功能类似，只是包裹的NavigationController 的 delegate类型可以被配置
 *
 *  @param vc  被包裹的view controller实例
 *  @param cls 被包裹的Navigation Controller class 的 delegate 类型，
 *  当使用RAMNavigationTransitionAnimator时，提供自定义转场动画的配置。
 *
 *  @return 实例对象
 */
- (id)initWithRootViewController:(UIViewController *)vc navigationDelegateClass:(Class)cls;
@end
