//
//  JGAllListViewController.m
//  eTalk
//
//  Created by sl on 15/4/7.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGAllListViewController.h"

@interface JGAllListViewController ()

@end

@implementation JGAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JGWeakSelf;
    [self.tableView addHeaderWithCallback:^{
        [JGManagerHelper updateForList];
        [weakSelf.tableView endRefreshing];
    }];
    [self updateTableViewDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)socketHaveMsg:(NSNotification *)sockmsg {
    [JGManagerHelper updateMsg:sockmsg callBack:^(JGSocketMsg *msg, NSError *error) {
        [JGManagerHelper contaceLoadAllFromDB:^(NSArray *array) {
            [self.tableView.datas removeAllObjects];
            [self.tableView.datas addObjectsFromArray:array];
            [self.tableView reloadData];
        }];
    }];
}
- (void)updateTableViewDatas {
    [self.tableView headerBeginRefreshing];
}
@end
