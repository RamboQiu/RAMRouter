//
//  UINavigationBar+RAMUtil.h
//  Pods
//
//  Created by 裘俊云 on 2019/1/16.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (RAMUtil)
/// 添加默认的分割线
- (void)ram_setDefaultBottomLine;

/*!
 *  设置navigationbar的背景色。当背景色有透明度的时候，需要将navigationbar的translucent设置为YES，否则为NO。
 *
 *  使用这个接口有个好处，可以设置背景色的渐变效果，也可以设置动画：
 *
 [UIView animateWithDuration:1 animations:^{
 [self.navigationController.navigationBar ht_setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.7]];
 } completion:^(BOOL finished) {
 }];
 *
 *  @param color 颜色值
 */
- (void)ram_setBackgroundColor:(UIColor*)color;

/*!
 *  隐藏和显示分割线
 *
 *  @param bHidden 隐藏和显示分割线
 */
- (void)ram_hideShadowImage:(BOOL)bHidden;
@end
