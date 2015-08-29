//
//  JGListViewController.m
//  eTalk
//
//  Created by sl on 15/3/26.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGBaseListViewController.h"
#import "JFLeanChatHelper.h"
#import "JGSearchResultTableViewCell.h"

@interface JGBaseListViewController ()

@end

@implementation JGBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTableView {
    CGRect frame = self.view.bounds;
    frame.origin.y = 40;
    frame.size.height -= frame.origin.y;
    self.tableView = [JFBaseTableView viewForStyle:UITableViewStylePlain frame:frame];
    [self.tableView willShowTopButton];
    [JGSearchResultTableViewCell autoRegistNibForTableView:self.tableView];
    JGWeakSelf;
    [self.tableView setUpdateDefalutCellReusedIdentifierCallBack:^NSString *(JFBaseTableView *tableView, id data) {
        return [JGSearchResultTableViewCell returnDefaultReuseIdentifier];
    }];
    [self.tableView setCellUpdateCallBack:^(JFBaseTableView *tableView, JFBaseTableViewCell *cell, id data) {
        JGContace *contace = data;
        [cell.imageView setImageName:contace.headImage];
        cell.textLabel.text = contace.name;
        cell.detailTextLabel.text = [@"\t账号：" stringByAppendingString:contace.ID];
    }];
    [self.tableView setDidSelectRowAtIndexPath:^(JFBaseTableView *tableView, NSIndexPath *indexPath) {
        JGContace *contace = weakSelf.tableView.datas[indexPath.row];
        [weakSelf DBMoveFirst:contace];
        [JFLeanChatHelper helperGoChatRoom:weakSelf.navigationController toContace:contace];
        JGExBlock(weakSelf.tableViewDidSelectCallback);
    }];
    [self.view addSubview:self.tableView];
}
- (void)updateTableViewDatas {

}

- (void)DBMoveFirst:(JGContace *)firstContace {
    JGSocketManager *manager = [JGSocketManager shared];
    //获得所有的最近联系人
    NSString *sql = [JGContace sqlSelRecentAllContaceWithID:manager.contace.ID];
    NSMutableArray *recents = [NSMutableArray array];
    [manager.db dbGetWithSql:sql action:^(int col, int row, char ** datas) {
        int len = (row+1)*col;
        for (int i=col; i<len; i+=col) {
            NSString *ID = [NSString stringWithUTF8String:datas[i]];
            NSString *name = [NSString stringWithUTF8String:datas[i+1]];
            JGContace *contace = [[JGContace alloc] initWithName:name ID:ID];
            contace.unreadNum = *datas[i+2];
            contace.headImage = [NSString stringWithUTF8String:datas[i+3]];
            [recents addObject:contace];
        }
    }];
    
    //删除最近联系人数据库
    sql = [JGContace sqlDelAllRecentContace:manager.contace.ID];
    [manager.db dbExecWithSql:sql];
    
    //添加当前的这个联系人
    sql = [JGContace sqlAddRecentContace:firstContace WithID:manager.contace.ID andUnreadNum:firstContace.unreadNum];
    [manager.db dbExecWithSql:sql];
    
    //添加剩下的联系人
    
    for (JGContace *contace in recents) {
        
        if ([contace.ID isEqualToString:firstContace.ID]) {
            continue;
        }
        
        sql = [JGContace sqlAddRecentContace:contace WithID:manager.contace.ID andUnreadNum:contace.unreadNum];
        [manager.db dbExecWithSql:sql];
    }
}


@end
