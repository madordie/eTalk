//
//  JGListViewController.h
//  eTalk
//
//  Created by sl on 15/3/26.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFBaseTableView.h"

@interface JGBaseListViewController : JFBaseViewController
@property (nonatomic, strong) JFBaseTableView *tableView;
@property (nonatomic, copy) void(^tableViewDidSelectCallback)(void);
/**
 *  数据刷新
 */
- (void)updateTableViewDatas;
@end
