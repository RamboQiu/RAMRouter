//
//  UIViewController+RAMUtils.h
//  RAMRouter
//
//  Created by 裘俊云 on 2018/11/15.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RAMUtils)
+ (UIViewController *)ram_applicationRootViewController;
/*!
 *  返回最顶上的Controller：presented 单链表尾部
 *
 *  @return presented 单链表尾部
 */
+ (UIViewController *)ram_topMostController;
/*!
 *  获取最active child 链上最末端的navigation controller。继承类不需要重写这个接口
 *
 *  @return navigation controller
 */
- (UINavigationController *)ram_innerMostNavigationController;
/*!
 *  返回当前active Child view controller。active相对这个当前controller而言。
 *
 *  @return child view controller中处于相对active的child controller
 */
- (UIViewController *)ram_currentChildViewController;

/*!
 *  获取最active child 链上最末端的navigation controller。继承类不需要重写这个接口
 *
 *  @param bHidden 这个navigation controller的bar是否是隐藏的
 *
 *  @return navigation controller
 */
- (UINavigationController *)ram_innerMostNavigationControllerWithNavigationBarHidden:(BOOL)bHidden;

/*!
 *  使用了RAMContainerViewController或者RAMControllerRouter的ViewController可以使用ram_back来实现后退页面的统一功能
 */
- (void)ram_back;
@end
