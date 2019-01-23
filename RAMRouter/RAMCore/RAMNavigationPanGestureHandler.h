//
//  RAMNavigationPanGestureHandler.h
//  Pods
//
//  Created by 裘俊云 on 2019/1/17.
//

#import <UIKit/UIKit.h>

@protocol RAMNavigationGestureHandlerDelegate <NSObject>

@optional
- (void)navigationController:(UINavigationController*)navigationController
           panGestureChanged:(UIPanGestureRecognizer*)gestureRecognizer;

- (void)navigationController:(UINavigationController*)navigationController
             panGestureBegin:(UIPanGestureRecognizer*)gestureRecognizer;

- (void)navigationController:(UINavigationController*)navigationController
             panGestureEnded:(UIPanGestureRecognizer*)gestureRecognizer
                  isCanceled:(BOOL)isCancel;
@end

/**
 *  自定义的navigation交互手势
 *  全屏返回手势；在scroll view上右划可以返回；
 */
@interface RAMNavigationPanGestureHandler : NSObject

@property (nonatomic, readonly) BOOL bPanning;

@property (nonatomic, assign) float maxAllowedSlideDistanceToLeftEdge;

@property (nonatomic, weak) UINavigationController *navigationViewController;

@property (nonatomic, weak) id <RAMNavigationGestureHandlerDelegate> gestureHandlerDelegate;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
                      gestureHandlerDelegate:(id<RAMNavigationGestureHandlerDelegate>)gestureHandlerDelegate;

- (void)panGestureHandlerReceive:(UIPanGestureRecognizer*)gestureRecognizer;

- (void)panGestureHandlerReceiveBegin:(UIPanGestureRecognizer*)gestureRecognizer;

- (void)panGestureHandlerReceiveChanged:(UIPanGestureRecognizer*)gestureRecognizer;

//for inherit
- (BOOL)isCancelTransitionWhenGestureEnded:(UIPanGestureRecognizer*)gestureRecognizer;

- (void)panGestureHandlerReceiveEnded:(UIPanGestureRecognizer*)gestureRecognizer isCanceled:(BOOL)isCanceled;

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer;

@end
