//
//  JFBaseViewController.m
//  SkinRun
//
//  Created by sl on 14-12-21.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFQuick.h"

@interface JFBaseViewController ()<UIGestureRecognizerDelegate>
{
}

@end

@implementation JFBaseViewController
+ (instancetype)viewController {
    return [[self alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setHidesBottomBarWhenPushed:YES];
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [JGManagerHelper haveMsgTo:self action:@selector(socketHaveMsg:)];
}
- (void)dealloc {
    [JGManagerHelper haveMsgclear:self];
}
- (void)socketHaveMsg:(NSNotification *)sockmsg {
};
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControllerTitle:(NSString *)viewControllerTitle {
    if (_viewControllerTitle != viewControllerTitle) {
        _viewControllerTitle = viewControllerTitle;
        self.title = viewControllerTitle;
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.375 alpha:1.000]];
        self.navigationItem.titleView = [JFQuick labelWithTitleText:viewControllerTitle];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

@end
