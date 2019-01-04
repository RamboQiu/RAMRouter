//
//  RAMRouterConfig.h
//  Pods-QJYRouter
//
//  Created by 裘俊云 on 2018/11/14.
//

#import <Foundation/Foundation.h>
#import "RAMRouterHeader.h"

@interface RAMRouterConfig : NSObject

- (instancetype)initWithUrlPath:(NSString*)url;
- (instancetype)initWithControllerClass:(Class)viewControllerClass;

@property (nonatomic, assign) RAMControllerLaunchMode launchMode;
@property (nonatomic, assign) RAMControllerInstanceShowMode singleInstanceShowMode;

@property (nonatomic, strong) Class viewControllerClass;

- (void)addUrlPath:(NSString*)url;

- (NSArray*)urlMatchers;

- (NSArray*)urls;
@end
