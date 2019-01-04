//
//  ViewController2.m
//  QJYRouter
//
//  Created by 裘俊云 on 2019/1/4.
//  Copyright © 2019 裘俊云. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()<
RAMContainerViewControllerProtocol,
RAMRouteTargetProtocol
>
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController2
@synthesize containerController;

#pragma mark - router
+ (RAMRouterConfig *)configureRouter {
    RAM_EXPORT();
    RAMRouterConfig *config = [[RAMRouterConfig alloc] initWithUrlPath:[self urlPath]];
    return config;
}

+ (NSString*)urlPath {
    return @"router://viewcontroller2";
}

- (void)receiveRoute:(RAMRouterParam *)param {
    NSLog(@"上个页面传过来的参数：%@",[param.params objectForKey:@"paramKey"]);
}
#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"viewcontroller2";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(50, 200, 200, 50);
    [_button setTitle:@"route2vc1" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAction:(id)sender {
    RAMRouterParam *param = [[RAMRouterParam alloc] init];
    param.url = @"router://viewcontroller1";
    param.launchMode = RAMControllerLaunchModePushNavigation;
    param.params = @{@"paramKey":@"viewcontroller2"};
    [[RAMRouter sharedRouter] route:param];
}

@end
