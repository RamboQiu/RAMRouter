//
//  RAMNavigationBackPanGestureProtocol.h
//  RAMRouter
//
//  Created by 裘俊云 on 2019/1/17.
//

#import <Foundation/Foundation.h>

//每个在有手势后退的NavigationController的UIViewController可以选择实现，以达到定制键盘呼出，以及ScrollView右滑兼容性。
@protocol RAMNavigationBackPanGestureProtocol <NSObject>
@optional
/*!
 *  最顶部的ViewController可以控制是否打开后退手势
 *
 *  @param gesture 后退手势
 *
 *  @return YES：允许页面后退手势，否则禁止。
 */
- (BOOL)navigationControllerBackPanGestureRecognizerShouldBegin:(UIPanGestureRecognizer*)gesture;

/*!
 *  页面后退手势开始时候的回调。譬如在此处可以隐藏键盘。
 *
 *  @param gesture 页面后退手势
 */
- (void)navigationControllerBackPanGestureRecognizerBegin:(UIPanGestureRecognizer*)gesture;

/*!
 *  页面后退手势结束时候的回调。基类里面有用到注意调用super,现在使用的基类地方涉及到统计。
 *
 *  @param gesture 页面后退手势
 *  @param isCanceled 手势后退是否取消
 */
- (void)navigationControllerBackPanGestureHandlerReceiveEnded:(UIPanGestureRecognizer*)gestureRecognizer isCanceled:(BOOL)isCanceled;

/*!
 *  用户是否允许页面后退和ScrollView的手势共存的配置接口
 *
 *  @param navigationGesture 页面后退手势
 *  @param scrollViewGesture 滚动条滚动手势
 *
 *  @return 返回YES，表示允许在滑动滚动条的时候，页面后退。否则滑动滚动条，页面无法后退。
 */
- (BOOL)navigationControllerBackPanGestureRecognizer:(UIGestureRecognizer*)navigationGesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)scrollViewGesture;
@end
