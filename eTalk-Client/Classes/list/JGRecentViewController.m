//
//  JGRecentViewController.m
//  eTalk
//
//  Created by sl on 15/4/7.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGRecentViewController.h"
#import "JFLeanDBManager.h"

@interface JGRecentViewController ()

@end

@implementation JGRecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateTableViewDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)socketHaveMsg:(NSNotification *)sockmsg {
    [JGManagerHelper updateContaceMsg:sockmsg callBack:^(JGSocketMsg *msg, id respondData, NSError *error){
        JFLeanChatMessage *message = respondData;
        [JFLeanDBManager autoInstallMessage:message];
    }];
}

- (void)updateTableViewDatas {
    [JGManagerHelper contaceLoadFromDB:^(NSArray *contaces) {
        [self.tableView.datas removeAllObjects];
        [self.tableView.datas addObjectsFromArray:contaces];
        [self.tableView reloadData];
    }];
}

@end
