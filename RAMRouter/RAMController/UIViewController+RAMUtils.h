//
//  UIViewController+RAMUtils.h
//  RAMRouter
//
//  Created by 裘俊云 on 2018/11/15.
//

#import <UIKit/UIKit.h>

/*!
 *  将Controller从tree中删除，因为dismissviewcontroller接口一定是异步的。。。所以没办法，必须提供一个异步回调接口！
 *  如果不是present controller从tree中删除，那么这个回调就同步调用
 *
 *  @param 这个Controller是否从Controller tree中删除
 */
typedef void (^RemoveControllerFromTreeCallback)(BOOL);

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
 *  将self从Controller tree中删除
 *  因为dismiss view controller一定是异步，在dismiss没有complete之前同步在presente一个controller，会报错，所以通过RemoveControllerFromTreeCallback来返回结果。如果参数为YES，表示可以删除，否则无法删除。
 *
 *  @warning：有些清楚无法删除，譬如：self是tabbarcontroller的一个child，此时cb回调参数为NO
 
 *  如果没有从Controller tree中删除，那么不会对原来Controller tree有任何影响
 *
 *  @warning：考虑HTContainerViewController，有可能删除的是self被包裹的ContainerViewController
 *
 *
 *  @param cb 删除之后的回调
 */
- (void)ram_removeFromControllerTree:(RemoveControllerFromTreeCallback)cb;

/*!
 * 业务中经常碰到需要在某些场景中，在当前controller中触发了某种业务之后就不能回退到前一个页面了
 * 例如：某一个表单跨三个页面填写，最后一个页面提交，提交之后进入一个成功页面，这个时候就需要抽掉前面的三个页面
 *
 */
- (void)ram_removeByUrlPaths:(NSArray<NSString *> *)urlPaths callback:(RemoveControllerFromTreeCallback)cb;

/*!
 *  使用了RAMContainerViewController或者RAMControllerRouter的ViewController可以使用ram_back来实现后退页面的统一功能
 */
- (void)ram_back;
@end
