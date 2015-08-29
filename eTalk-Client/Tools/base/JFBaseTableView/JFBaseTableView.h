//
//  JFBaseTableView.h
//  SkinRun
//
//  Created by sl on 15/1/2.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFQuick.h"
#import <MJRefresh.h>

@class JFBaseTableViewCell;
@interface JFBaseTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

#pragma mark -  辅助属性
@property (nonatomic, strong) NSDictionary *requestBody;
@property (nonatomic, strong) UINavigationController *navigationController;

#pragma mark - 计算高度
/**
    默认自动重用标识符
 */
@property (nonatomic, strong) NSString *defaultReusedIdentifier;
@property (nonatomic, strong) JFBaseTableViewCell *plotHeightForCell;
/**
 *  根据数据源 刷新默认Cell的标识符合当前计算Cell  用于多类型
 *
 *  @param data 当前数据
 */
- (NSString *)updateDefalutCellReusedIdentifier:(id)data;
/**
 计算高度字典  reusedID:cell
 */
@property (nonatomic, strong, readonly) NSDictionary *plotHeightForCells;

#pragma mark - 数据源
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) BOOL willShowTopButton;   //default NO. Must set after addsubview
@property (nonatomic, assign) BOOL willAutoHideNavigation;  //default NO. if YES, -> navigationController
@property (nonatomic, assign) BOOL willAutoFooterRefresh;   //default NO.

#pragma mark - 初始化
+ (instancetype)viewForStyle:(UITableViewStyle)style frame:(CGRect)frame;
- (void)initSomething;

#pragma mark - 重写
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

#pragma mark - refresh
@property (nonatomic, assign) int currectPage;
- (void)addFooterWithCallback:(void (^)())callback;
- (void)addHeaderWithCallback:(void (^)())callback;
- (void)endRefreshing;
- (void)refreshData;
- (id)changePageForBody:(id)body;   //传入字典，页码替换字典中的 "page"

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^didSelectRowAtIndexPath)(JFBaseTableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) NSString*(^updateDefalutCellReusedIdentifierCallBack)(JFBaseTableView *tableView, id data);
@property (nonatomic, copy) void(^cellUpdateCallBack)(JFBaseTableView *tableView, JFBaseTableViewCell *cell, id data);
@end
