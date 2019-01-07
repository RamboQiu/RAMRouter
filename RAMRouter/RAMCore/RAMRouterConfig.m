//
//  RAMRouterConfig.m
//  Pods-QJYRouter
//
//  Created by 裘俊云 on 2018/11/14.
//

#import "RAMRouterConfig.h"

@interface RAMRouterConfig()
@property (nonatomic, strong) NSMutableArray *urlMatchers;

@property (nonatomic, strong) NSMutableArray<NSString *> *urls;
@end

@implementation RAMRouterConfig

- (instancetype)initWithUrlPath:(NSString *)url {
    self = [super init];
    if (self) {
        _urlMatchers = [NSMutableArray new];
        _urls = [NSMutableArray new];
        _launchMode = RAMControllerLaunchModePush;
        _singleInstanceShowMode = RAMControllerInstanceShowModeNOAction;
        
        if (url) {
            [self addUrlPath:url];
        }
    }
    
    return self;
}

- (instancetype)initWithControllerClass:(Class)viewControllerClass {
    self = [self initWithUrlPath:NSStringFromClass(viewControllerClass)];
    if (self){
        _viewControllerClass = viewControllerClass;
    }
    
    return self;
}

- (void)addUrlPath:(NSString*)url {
    [_urls addObject:url];
}

- (NSArray*)urls {
    return _urls;
}
@end
