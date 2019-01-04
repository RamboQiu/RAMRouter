//
//  RAMRouterParam.h
//  Pods
//
//  Created by 裘俊云 on 2018/11/14.
//

#import <UIKit/UIKit.h>
#import "RAMRouterHeader.h"

@interface RAMRouterParam : NSObject
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *urlParams;
@property (nonatomic, strong) id params;
@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) RAMControllerLaunchMode launchMode;
@property (nonatomic, assign) RAMControllerInstanceShowMode singleInstanceShowMode;
@property (nonatomic, assign) BOOL bAnimate;

- (instancetype)initWithURL:(NSString*)url launchMode:(RAMControllerLaunchMode)launchMode;
@end
