//
//  RAMRouterParam.m
//  Pods
//
//  Created by 裘俊云 on 2018/11/14.
//

#import "RAMRouterParam.h"

NSString *RAMControllerLaunchModeToString(RAMControllerLaunchMode mode) {
    switch (mode) {
            case RAMControllerLaunchModeDefault:
            return @"RAMControllerLaunchModeDefault";
            
            case RAMControllerLaunchModeNOAction:
            return @"RAMControllerLaunchModeNOAction";
            
            case RAMControllerLaunchModePush:
            return @"RAMControllerLaunchModePush";
            
            case RAMControllerLaunchModePresent:
            return @"RAMControllerLaunchModePresent";
            
            case RAMControllerLaunchModePushNavigation:
            return @"RAMControllerLaunchModePushNavigation";
            
            case RAMControllerLaunchModePresentNavigation:
            return @"RAMControllerLaunchModePresentNavigation";
            
        default:
            break;
    }
}

NSString *RAMControllerInstanceShowModeToString(RAMControllerInstanceShowMode mode) {
    switch (mode) {
            
            case RAMControllerInstanceShowModeDefault:
            return @"RAMControllerInstanceShowModeDefault";
            
            case RAMControllerInstanceShowModeNOAction:
            return @"RAMControllerInstanceShowModeNOAction";
            
            case RAMControllerInstanceShowModeMoveToTop:
            return @"RAMControllerInstanceShowModeMoveToTop";
            
            case RAMControllerInstanceShowModeClearToTop:
            return @"RAMControllerInstanceShowModeClearToTop";
            
        default:
            break;
    }
}


@implementation RAMRouterParam

- (instancetype)init {
    self = [super init];
    if (self){
        [self doInit];
    }
    
    return self;
}

- (instancetype)initWithURL:(NSString*)url launchMode:(RAMControllerLaunchMode)launchMode {
    self = [super init];
    if (self){
        [self doInit];
        _url = url;
        _launchMode = launchMode;
    }
    
    return self;
}

- (void)doInit {
    _launchMode = RAMControllerLaunchModeDefault;
    _singleInstanceShowMode = RAMControllerInstanceShowModeDefault;
    _bAnimate = YES;
}

- (id)copy {
    RAMRouterParam *param = [RAMRouterParam new];
    param.fromViewController = self.fromViewController;
    param.url = self.url;
    param.urlParams = self.urlParams;
    param.params = self.params;
    param.delegate = self.delegate;
    param.launchMode = self.launchMode;
    param.singleInstanceShowMode = self.singleInstanceShowMode;
    param.bAnimate = self.bAnimate;
    
    return param;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] initWithString:NSStringFromClass(self.class)];
    
    if (_url)
        [desc appendFormat:@" url:%@", _url];
    
    if (_params){
        [desc appendFormat:@" param:%@", _params];
    }
    
    if (_fromViewController){
        [desc appendFormat:@" from controller:%@", _fromViewController];
    }
    
    [desc appendFormat:@" launchMode:%@", RAMControllerLaunchModeToString(self.launchMode)];
    [desc appendFormat:@" singleInstanceShowMode:%@", RAMControllerInstanceShowModeToString(self.singleInstanceShowMode)];
    
    return desc;
}

@end
