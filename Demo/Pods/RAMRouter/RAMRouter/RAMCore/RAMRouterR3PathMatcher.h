//
//  RAMRouterR3PathMatcher.h
//  Pods
//
//  Created by 裘俊云 on 2018/11/14.
//

#import <Foundation/Foundation.h>

@class RAMRouterConfig;

@interface RAMRouterR3PathMatcher : NSObject
- (instancetype)initWithControllerRouterConfigs:(NSArray<RAMRouterConfig*>*)configs;

- (void)addRAMControllerRouterConfig:(RAMRouterConfig*)config;

- (RAMRouterConfig*)matchURL:(NSString*)url  matchedParams:(NSMutableDictionary*)params;

- (void)compile;
- (void)dump;
@end
