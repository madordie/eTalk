//
//  JFMyTestViewController.m
//  SkinRun
//
//  Created by sl on 15/3/18.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//


#import "JFListViewController.h"
#import "JGAllListViewController.h"
#import "JGRecentViewController.h"
#import "JGSearchViewController.h"

#import "JGBaseListViewController.h"

@interface JFListViewController () <UIActionSheetDelegate>
{
    UIView *_tabbarView;
    UIView *_selectView;
    NSArray *_buttons;
}
@end

@implementation JFListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"联系人";
    [self initTabbar];
    [self initNavigationBar];
}
- (void)socketHaveMsg:(NSNotification *)sockmsg {
    [JGManagerHelper updateForAutoLogoutMsg:sockmsg callBack:^(JGSocketMsg *msg, NSError *error) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(popVC) object:nil];
        [self popVC];
    }];
}
- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initNavigationBar {
    UIBarButtonItem *quit = [JFQuick barButtonItemWithTarget:self action:@selector(quitBarButton:) size:CGSizeMake(40, 20) title:@"退出"];
    UIBarButtonItem *search = [JFQuick barButtonItemWithTarget:self action:@selector(searchButton:) size:CGSizeMake(40, 20) title:@"搜索"];
    self.navigationItem.rightBarButtonItems = @[quit, search];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"eTalk" style:UIBarButtonItemStyleDone target:nil action:nil];
}
- (void)quitBarButton:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}
- (void)searchButton:(id)sender {
    JGSearchViewController *vc = [JGSearchViewController viewController];
    [vc setExIfAddContace:^(JGSearchViewController *vc, JGContace *contace) {
        [_viewController enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            JGBaseListViewController *vc = obj;
            [vc updateTableViewDatas];
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //退出
        NSLog(@"退出");
        [JGManagerHelper logout];
        
        [self performSelector:@selector(popVC) withObject:nil afterDelay:3];
    }
}
#pragma mark - 初始化tabbar
- (void)initTabbar {
    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JFQuickDeviceBounds.size.width, 40)];
    _tabbarView = tabbarView;
    NSArray *array = [self titles];
    NSMutableArray *VCS = [@[] mutableCopy];
    NSMutableArray *Buttons = [@[] mutableCopy];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        JGBaseListViewController *viewController = (id)[self subViewControllerClassIndex:(int)idx];
        
        [self addChildViewController:viewController];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[idx] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(idx*tabbarView.quickWidth/2+idx, 0, tabbarView.quickWidth/2-0.5, tabbarView.quickHeight-1)];
        [tabbarView addSubview:button];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTag:idx];
        [Buttons addObject:button];
        [VCS addObject:viewController];
    }];
    _buttons = Buttons;
    _viewController = VCS;
    [self.view addSubview:((UIViewController *)[VCS firstObject]).view];
    [_tabbarView removeFromSuperview];
    [self.view addSubview:_tabbarView];
    [_tabbarView setBackgroundColor:[UIColor colorWithWhite:0.873 alpha:1.000]];
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, _tabbarView.quickHeight-2,
                                                           _tabbarView.quickWidth/2, 2)];
    [_selectView setBackgroundColor:[UIColor colorWithRed:0.302 green:0.753 blue:0.996 alpha:1.000]];
    [_tabbarView addSubview:_selectView];
    [[Buttons firstObject] setTitleColor:[UIColor colorWithRed:0.302 green:0.753 blue:0.996 alpha:1.000] forState:UIControlStateNormal];

}

- (void)buttonClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor colorWithRed:0.302 green:0.753 blue:0.996 alpha:1.000] forState:UIControlStateNormal];
    [_buttons[!sender.tag] setTitleColor:[UIColor colorWithWhite:0.375 alpha:1.000] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.3
                     animations:^{
                         [JFQuick changeFrameForView:_selectView
                                                type:JGChangeFrameTypeX
                                            forFloat:_selectView.quickWidth*sender.tag];
                     }];
    UIView *willShowView =((JGBaseListViewController *)_viewController[sender.tag]).view;
    CGRect frame = willShowView.frame;
//    frame.origin.y =
    willShowView.frame = frame;
    [self.view addSubview:willShowView];
    [_tabbarView removeFromSuperview];
    [self.view addSubview:_tabbarView];
    self.index = (int)sender.tag;
    
    JGExBlock(self.tabbarChangeVCBlock, _viewController[(sender.tag+1)%2], _viewController[sender.tag]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark - set tools
- (NSArray *)titles {
    return @[@"最近联系人", @"联系人"];
}
- (id)subViewControllerClassIndex:(int)index {
    JGBaseListViewController *vc = nil;
    if (index) {
        vc = [JGAllListViewController viewController];
    } else {
        vc = [JGRecentViewController viewController];
    }
    [vc setTableViewDidSelectCallback:^{
        [self.viewController enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            JGBaseListViewController *vc = obj;
            if ([vc isKindOfClass:[JGRecentViewController class]]) {
                [vc updateTableViewDatas];
            }
        }];
    }];
    return vc;
}
@end
