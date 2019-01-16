//
//  UIViewController+RAMNavigationBar.m
//  Pods
//
//  Created by 裘俊云 on 2019/1/16.
//

#import "UIViewController+RAMNavigationBar.h"
#import "RAMContainerViewController.h"
#import <RAMUtil/UIColor+RAMHEX.h>
#import <RAMUtil/UIImage+RAMColor.h>
#import "UIViewController+RAMUtils.h"
#import <objc/runtime.h>

@interface UIViewController ()
@property (nonatomic, strong) UIView *rightmostView;
@property (nonatomic, strong) UIView *leftmostView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@end

@implementation UIViewController (RAMNavigationBar)
- (UIButton *)_yx_addNavigationBarBackButton {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37 + 15, 44)];
    
    CGFloat imgIconWidth = [UIImage imageNamed:@"detail_ic_back2_nor"].size.width;
    // -9表示向左偏移9dp
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-9, 0, 37, 44)];
    [backBtn setImage:[UIImage imageNamed:@"detail_ic_back2_nor"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"detail_ic_back2_pressed"] forState:UIControlStateHighlighted];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, imgIconWidth - 37, 0, 0);
    
    [containerView addSubview:backBtn];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:containerView]];
    [backBtn addTarget:self action:@selector(ram_back) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftmostView = backBtn;
    [self addTapGestureIfNecessary];
    
    return backBtn;
}
#pragma mark ----------------------- Navibar -----------------------

- (void)yx_applyDefaultNavigationBarStyle {
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        if ([(id<RAMContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xF9F9F9" alpha:0.99] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"0x333333" alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xD9D9D9" alpha:1] pixSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
}

- (UIButton *)yx_applyWhiteNavigationBarStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        if ([(id<RAMContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xF9F9F9" alpha:0.99] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"0x333333" alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xD9D9D9" alpha:1] pixSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
    
    return [self _yx_addNavigationBarBackButton];
}

- (UIButton *)yx_applyClearNavigationBarStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        if ([(id<RAMContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar ht_setBackgroundColor:[UIColor clearColor]];
            [self.navigationController.navigationBar ht_hideShadowImage:YES];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YXResourceColor(YXColorGray4),NSForegroundColorAttributeName,YXResourceFont(YXLightFontSize18),NSFontAttributeName,nil]];
    return [self _yx_addNavigationBarBackButton];
}

- (UIButton *)yx_applyClearBlackNavigationBarWhiteTitleStyle{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if ([self conformsToProtocol:@protocol(HTContainerViewControllerProtocol)]){
        if ([(id<HTContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar ht_setBackgroundColor:YXResourceColor(YXColorBlackAlpha60)];
            [self.navigationController.navigationBar ht_hideShadowImage:YES];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YXResourceColor(YXColorWhite),NSForegroundColorAttributeName,YXResourceFont(YXLightFontSize18),NSFontAttributeName,nil]];
    return [self _yx_addNavigationBarBackButton];
}

#pragma mark ----------------------- Right item -----------------------

- (UIButton *)yx_addRightItemWithTitle:(NSString *)title showBadge:(BOOL)showBadge {
    UIButton *btn = [self yx_addRightItemWithTitle:title];
    if (showBadge) {
        [btn.titleLabel sizeToFit];
        CGFloat badgeWidth = 6;
        UIView *badge = [[UIView alloc] initWithFrame:CGRectMake(0, 0, badgeWidth, badgeWidth)];
        badge.y = (btn.height - btn.titleLabel.height) / 2;
        badge.x = btn.titleLabel.tail - badgeWidth / 2;
        badge.backgroundColor = YXResourceColor(YXColorRed);
        badge.layer.cornerRadius = badgeWidth / 2;
        [btn addSubview:badge];
    }
    
    return btn;
}

- (UIButton *)yx_addRightItemWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:YXResourceColor(YXColorGray4) forState:UIControlStateNormal];
    btn.titleLabel.font = YXResourceFont(YXLightFontSize15);
    [btn sizeToFit];
    
    UIView *containerView = [[UIView alloc] initWithFrame:btn.frame];
    [containerView addSubview:btn];
    // 在默认padding的基础上，向右侧偏移2dp
    btn.x = btn.x + 2;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    return btn;
}

- (UIButton *)yx_addRightItemWithNormalImage:(NSString *)normalImage hilightedImage:(NSString *)hilightedImage fixedSpaceWidth:(CGFloat)spaceWidth {
    NSArray *btns = [self yx_addRightBarButtonItemCount:1];
    UIButton *btn = btns.firstObject;
    [btn setImage:YXResourceImage(normalImage) forState:UIControlStateNormal];
    [btn setImage:YXResourceImage(hilightedImage) forState:UIControlStateHighlighted];
    
    return btn;
}

- (NSArray <UIButton *> *)yx_addRightBarButtonItemCount:(NSInteger)count {
    // 宽度写死为50，显示两个按钮没问题，如果以后要支持更多按钮，则此处宽度加宽
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, YXNavigationBarHeight)];
    [self addTapGestureIfNecessary];
    
    NSMutableArray *rightBarButtons = [NSMutableArray array];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    // 从右往左添加按钮
    for (int i = 0; i < count; i++) {
        // 31是视觉icon切图的宽高
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.height = YXNavigationBarHeight;
        button.width = 31;
        button.middleY = containerView.middleY;
        if (i == 0) {
            // 7为视觉要求的最后一个按钮到屏幕右侧的距离
            // SystemNavBarItemDefaultPadding用于平衡系统默认的16dp padding
            button.tail = containerView.tail - 7 + SystemNavBarItemDefaultPadding;
        } else {
            // 6为两个按钮之间的距离
            button.tail = ((UIView *)[rightBarButtons at:i-1]).x - 6;
        }
        [containerView addSubview:button];
        
        [rightBarButtons addObject:button];
    }
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.rightmostView = rightBarButtons.firstObject;
    
    return rightBarButtons;
}

- (NSArray <UIButton *> *)yx_addRightBarButtonItemForCartCount:(NSInteger)count {
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, count * 44, YXNavigationBarHeight)];
    [self addTapGestureIfNecessary];
    NSMutableArray *rightBarButtons = [NSMutableArray array];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    // 从右往左添加按钮
    for (int i = 0; i < count; i++) {
        // 31是视觉icon切图的宽高
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.height = YXNavigationBarHeight;
        button.width = 44;
        button.middleY = containerView.middleY;
        if (i == 0) {
            //去掉按钮的内边距7
            button.tail = containerView.tail + 7.0;
        } else {
            // 6为两个按钮之间的距离
            button.tail = ((UIView *)[rightBarButtons at:i-1]).x;
        }
        [containerView addSubview:button];
        [rightBarButtons addObject:button];
    }
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.rightmostView = rightBarButtons.firstObject;
    return rightBarButtons;
}

#pragma mark -
- (void)addTapGestureIfNecessary {
    if (!self.tapGR) {
        self.tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [self.navigationController.navigationBar addGestureRecognizer:self.tapGR];
    }
}


#pragma mark - Accessors

- (UITapGestureRecognizer *)tapGR {
    return objc_getAssociatedObject(self, @selector(tapGR));
}

- (void)setTapGR:(UITapGestureRecognizer *)tapGR {
    objc_setAssociatedObject(self, @selector(tapGR), tapGR, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)rightmostView {
    return objc_getAssociatedObject(self, @selector(rightmostView));
}

- (void)setRightmostView:(UIView *)rightmostView {
    objc_setAssociatedObject(self, @selector(rightmostView), rightmostView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)leftmostView {
    return objc_getAssociatedObject(self, @selector(leftmostView));
}

- (void)setLeftmostView:(UIView *)leftmostView {
    objc_setAssociatedObject(self, @selector(leftmostView), leftmostView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
