//
//  UINavigationBar+RAMUtil.m
//  Pods
//
//  Created by 裘俊云 on 2019/1/16.
//

#import "UINavigationBar+RAMUtil.h"
#import <RAMUtil/UIColor+RAMHEX.h>
#import <RAMUtil/UIImage+RAMColor.h>

@implementation UINavigationBar (RAMUtil)
- (void)ram_setDefaultBottomLine {
    [self setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xD9D9D9" alpha:1] pixSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
}

#pragma mark - bg color
- (UIView*)ram_getBackgroundView {
    return (UIView*)self.subviews.firstObject;
}

- (void)ram_setBackgroundColor:(UIColor*)color {
    //这里必须设置为透明的图，设置为nil也不起作用
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:color.alpha * 0.99] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    UIView *bgView = [self ram_getBackgroundView];
    bgView.backgroundColor = color;
}

#pragma mark - shadow view
- (void)ram_hideShadowImage:(BOOL)bHidden {
    UIView *bgView = [self ram_getBackgroundView];
    for (UIView *lineView in bgView.subviews) {
        if (CGRectGetHeight(lineView.frame) <= 1) {
            lineView.hidden = bHidden;
        }
    }
}

@end
