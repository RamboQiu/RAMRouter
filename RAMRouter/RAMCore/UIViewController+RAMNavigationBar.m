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
#import "UINavigationBar+RAMUtil.h"
#import <RAMUtil/UIView+Frame.h>

@interface UIViewController ()
@property (nonatomic, strong) UIView *rightmostView;
@property (nonatomic, strong) UIView *leftmostView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@end

@implementation UIViewController (RAMNavigationBar)
- (UIImage *)_ram_imageWithName:(NSString *)name {
    /// https://juejin.im/post/5a77fb8df265da4e99576702
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                            stringByAppendingPathComponent:@"/RAMRouter.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:name
                                inBundle:resource_bundle
           compatibleWithTraitCollection:nil];
    return image;
}

- (UIFont *)_ram_fontWithSize:(CGFloat)size {
    UIFont *lastFont;
    if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        lastFont =  [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    } else {
        lastFont = [UIFont systemFontOfSize:size];
    }
    return lastFont;
}

- (UIButton *)_ram_addNavigationBarBackButton {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37 + 15, 44)];
    
    CGFloat imgIconWidth = [self _ram_imageWithName:@"detail_ic_back2_nor"].size.width;
    // -9表示向左偏移9dp
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-9, 0, 37, 44)];
    [backBtn setImage:[self _ram_imageWithName:@"detail_ic_back2_nor"] forState:UIControlStateNormal];
    [backBtn setImage:[self _ram_imageWithName:@"detail_ic_back2_pressed"] forState:UIControlStateHighlighted];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, imgIconWidth - 37, 0, 0);
    
    [containerView addSubview:backBtn];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:containerView]];
    [backBtn addTarget:self action:@selector(ram_back) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftmostView = backBtn;
    [self addTapGestureIfNecessary];
    
    return backBtn;
}
#pragma mark ----------------------- Navibar -----------------------

- (void)ram_applyDefaultNavigationBarStyle {
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        if ([(id<RAMContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xF9F9F9" alpha:0.99] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"0x333333" alpha:1],NSForegroundColorAttributeName,[self _ram_fontWithSize:18],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar ram_setDefaultBottomLine];
}

- (UIButton *)ram_applyWhiteNavigationBarStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        if ([(id<RAMContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xF9F9F9" alpha:0.99] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"0x333333" alpha:1],NSForegroundColorAttributeName,[self _ram_fontWithSize:18],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar ram_setDefaultBottomLine];
    
    return [self _ram_addNavigationBarBackButton];
}

- (UIButton *)ram_applyClearNavigationBarStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        if ([(id<RAMContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar ram_setBackgroundColor:[UIColor clearColor]];
            [self.navigationController.navigationBar ram_hideShadowImage:YES];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"0x333333" alpha:1],NSForegroundColorAttributeName,[self _ram_fontWithSize:18],NSFontAttributeName,nil]];
    return [self _ram_addNavigationBarBackButton];
}

- (UIButton *)ram_applyClearBlackNavigationBarWhiteTitleStyle{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if ([self conformsToProtocol:@protocol(RAMContainerViewControllerProtocol)]){
        if ([(id<RAMContainerViewControllerProtocol>)self containerController]){
            [self.navigationController.navigationBar ram_setBackgroundColor:[UIColor colorWithHexString:@"0x000000" alpha:0.6]];
            [self.navigationController.navigationBar ram_hideShadowImage:YES];
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[self _ram_fontWithSize:18],NSFontAttributeName,nil]];
    return [self _ram_addNavigationBarBackButton];
}

#pragma mark ----------------------- Right item -----------------------

- (UIButton *)ram_addRightItemWithTitle:(NSString *)title showBadge:(BOOL)showBadge {
    UIButton *btn = [self ram_addRightItemWithTitle:title];
    if (showBadge) {
        [btn.titleLabel sizeToFit];
        CGFloat badgeWidth = 6;
        UIView *badge = [[UIView alloc] initWithFrame:CGRectMake(0, 0, badgeWidth, badgeWidth)];
        badge.y = (btn.height - btn.titleLabel.height) / 2;
        badge.x = btn.titleLabel.tail - badgeWidth / 2;
        badge.backgroundColor = [UIColor colorWithString:@"0xB4282D"];
        badge.layer.cornerRadius = badgeWidth / 2;
        [btn addSubview:badge];
    }
    
    return btn;
}

- (UIButton *)ram_addRightItemWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithString:@"0x333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [self _ram_fontWithSize:15];
    [btn sizeToFit];
    
    UIView *containerView = [[UIView alloc] initWithFrame:btn.frame];
    [containerView addSubview:btn];
    // 在默认padding的基础上，向右侧偏移2dp
    btn.x = btn.x + 2;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    return btn;
}

- (UIButton *)ram_addRightItemWithNormalImage:(UIImage *)normalImage hilightedImage:(UIImage *)hilightedImage fixedSpaceWidth:(CGFloat)spaceWidth {
    NSArray *btns = [self ram_addRightBarButtonItemCount:1];
    UIButton *btn = btns.firstObject;
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:hilightedImage forState:UIControlStateHighlighted];
    
    return btn;
}

- (NSArray <UIButton *> *)ram_addRightBarButtonItemCount:(NSInteger)count {
    // 宽度写死为50，显示两个按钮没问题，如果以后要支持更多按钮，则此处宽度加宽
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [self addTapGestureIfNecessary];
    
    NSMutableArray *rightBarButtons = [NSMutableArray array];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    // 从右往左添加按钮
    for (int i = 0; i < count; i++) {
        // 31是视觉icon切图的宽高
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.height = 44;
        button.width = 31;
        button.middleY = containerView.middleY;
        if (i == 0) {
            // 7为视觉要求的最后一个按钮到屏幕右侧的距离
            // SystemNavBarItemDefaultPadding用于平衡系统默认的16dp padding
            button.tail = containerView.tail - 7 + 16;
        } else {
            // 6为两个按钮之间的距离
            if (i-1<rightBarButtons.count) {
                button.tail = ((UIView *)rightBarButtons[i-1]).x - 6;
            }
        }
        [containerView addSubview:button];
        
        [rightBarButtons addObject:button];
    }
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.rightmostView = rightBarButtons.firstObject;
    
    return rightBarButtons;
}

- (NSArray <UIButton *> *)ram_addRightBarButtonItemForCartCount:(NSInteger)count {
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, count * 44, 44)];
    [self addTapGestureIfNecessary];
    NSMutableArray *rightBarButtons = [NSMutableArray array];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    // 从右往左添加按钮
    for (int i = 0; i < count; i++) {
        // 31是视觉icon切图的宽高
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.height = 44;
        button.width = 44;
        button.middleY = containerView.middleY;
        if (i == 0) {
            //去掉按钮的内边距7
            button.tail = containerView.tail + 7.0;
        } else {
            // 6为两个按钮之间的距离
            if (i-1<rightBarButtons.count) {
                button.tail = ((UIView *)rightBarButtons[i-1]).x;
            }
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


// 通过计算点击事件发生的位置是否在控件的区域内，如果在，则向控件发送点击事件，以此来修复iOS上最右/左按钮热区过小的问题
- (void)tapGestureHandler:(UITapGestureRecognizer *)gr {
    [self hitTestControl:(UIControl *)self.rightmostView withGestureRecognizer:gr];
    [self hitTestControl:(UIControl *)self.leftmostView withGestureRecognizer:gr];
}

- (void)hitTestControl:(UIControl *)control withGestureRecognizer:(UITapGestureRecognizer *)gr {
    // 代码里面设置 self.navigationItem.rightBarButtonItems 为nil移除按钮以后，control的superview会变为nil，
    // 此时不应该再响应事件，同理，按钮hidden被置为YES，userInteractionEnabled被置为NO以后也不能响应事件
    
    // 此处出现过bug，当H5设置了显示分享按钮以后，又设置隐藏分享按钮，会导致点击导航栏时，按钮响应了分享事件
    if (!control || ![control isKindOfClass:UIControl.class] || !control.superview || control.hidden || !control.userInteractionEnabled) {
        return;
    }
    
    CGPoint touchPoint = [gr locationInView:control];
    
    BOOL hitControl = CGRectContainsPoint(control.bounds, touchPoint);
    if (hitControl) {
        [control sendActionsForControlEvents:UIControlEventTouchUpInside];
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
