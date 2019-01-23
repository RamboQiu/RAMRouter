//
//  UIViewController+RAMNavigationBar.h
//  Pods
//
//  Created by 裘俊云 on 2019/1/16.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RAMNavigationBar)


- (void)ram_applyDefaultNavigationBarStyle;
- (UIButton *)ram_applyWhiteNavigationBarStyle;
- (UIButton *)ram_applyClearNavigationBarStyle;
- (UIButton *)ram_applyClearBlackNavigationBarWhiteTitleStyle;


/// 添加文本按钮，ex: 提交、保存、下一步、礼品卡的 交易记录
- (UIButton *)ram_addRightItemWithTitle:(NSString *)title;
/**
 添加文字按钮
 
 @param title 按钮文案
 @param showBadge 是否显示红点
 */
- (UIButton *)ram_addRightItemWithTitle:(NSString *)title showBadge:(BOOL)showBadge;
/// ex: webview的分享按钮、首页的搜索、优惠券的帮助
- (UIButton *)ram_addRightItemWithNormalImage:(NSString*)n hilightedImage:(NSString*)h fixedSpaceWidth:(CGFloat)s;
/// ex: 商品详情里的分享和首页
- (NSArray <UIButton *> *)ram_addRightBarButtonItemCount:(NSInteger)count;
/// ex:购物车里的领券和编辑
- (NSArray <UIButton *> *)ram_addRightBarButtonItemForCartCount:(NSInteger)count;

@end
