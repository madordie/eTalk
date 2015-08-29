//
//  JFBaseTableView.m
//  SkinRun
//
//  Created by sl on 15/1/2.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFBaseTableView.h"
#import "JFQuick.h"
#import "JFBaseTableViewCell.h"
#import <UIScrollView+MJRefresh.h>

@interface JFBaseTableView ()
{
    void (^_footerCallback)();  //默认下拉一定程度刷新
    BOOL _isFootering;
    CGFloat _contentOffsetY;
    CGFloat _topButtonY;
    
    NSCache *_cacheForHeight;
}
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation JFBaseTableView
+ (instancetype)viewForStyle:(UITableViewStyle)style frame:(CGRect)frame {
    JFBaseTableView *view = [[self alloc] initWithFrame:frame style:style];
    view.defaultReusedIdentifier = @"cell";
    view.willShowTopButton = NO;
    view.willAutoHideNavigation = NO;
    view.willAutoFooterRefresh = NO;
    [view initSomething];
    view.delegate = view;
    view.dataSource = view;
    return view;
}
- (void)initSomething {

}
- (NSMutableArray *)datas {
    if (_datas) {
        return _datas;
    }
    _datas = [NSMutableArray array];
    _cacheForHeight = [[NSCache alloc] init];
    return _datas;
}
#pragma mark - 刷新
- (void)refreshData {
    [self endRefreshing];
}
- (void)setCurrectPage:(int)currectPage {
    if (currectPage<1) {
        _currectPage = 1;
    } else {
        _currectPage = currectPage;
    }
}
- (void)setWillShowTopButton:(BOOL)willShowTopButton {
    if (willShowTopButton == _willShowTopButton) {
        return;
    }
    _willShowTopButton = willShowTopButton;
    if (_willShowTopButton) {
        self.topButton = [JFQuick buttonWithTarget:self
                                            action:@selector(topButtonClick:)
                                             frame:CGRectMake(0, 0, 40, 40)
                                             image:@"返回顶部"
                                          selImage:nil];
        CGRect frame = self.frame;
        frame.origin.x += self.frame.size.width - 60;
        frame.origin.y += self.frame.size.height - 60;
        frame.size = self.topButton.frame.size;
        [self.topButton setFrame:frame];
        self.topButton.hidden = YES;
        _topButtonY = self.topButton.frame.origin.y;
        [self.superview insertSubview:self.topButton aboveSubview:self];
    } else {
        [self.topButton removeFromSuperview];
        self.topButton = nil;
    }
}
- (void)topButtonClick:(UIButton *)sender {
    [self setContentOffset:CGPointZero animated:YES];
}
- (void)addHeaderWithCallback:(void (^)())callback {
    [super addHeaderWithCallback:callback];
    [self setupRefresh];
}
- (void)addFooterWithCallback:(void (^)())callback {
    if (_willAutoFooterRefresh) {
        _isFootering = NO;
        _footerCallback = callback;
    } else {
        [super addFooterWithCallback:callback];
    }
    [self setupRefresh];
}
- (void)endRefreshing {
    [self footerEndRefreshing];
    [self headerEndRefreshing];
}
- (void)setupRefresh
{
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    
    self.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.footerRefreshingText = @"正努力帮您加载...";
    
    self.headerPullToRefreshText = @"下拉可以刷新了";
    self.headerReleaseToRefreshText = @"松开马上刷新了";
    self.headerRefreshingText = @"正努力帮您刷新...";
    
}
- (id)changePageForBody:(id)body {
    NSMutableDictionary *mBody = [body mutableCopy];
    [mBody setObject:@(self.currectPage) forKey:@"page"];
    return mBody;
}

#pragma mark - 重写
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    [super registerNib:nib forCellReuseIdentifier:identifier];
    
    [self savePlotCellForIdentifier:identifier];
}
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [super registerClass:cellClass forCellReuseIdentifier:identifier];
    
    [self savePlotCellForIdentifier:identifier];
}
- (void)savePlotCellForIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:_plotHeightForCells];
    [dictionary setObject:[self dequeueReusableCellWithIdentifier:identifier] forKey:identifier];
    _plotHeightForCells = dictionary;
}
- (void)reloadData {
    [_cacheForHeight removeAllObjects];
    
    [super reloadData];
    [self endRefreshing];
}
- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    [super deleteSections:sections withRowAnimation:animation];
}
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [_cacheForHeight removeAllObjects];
    
    [super reloadSections:sections withRowAnimation:animation];
}
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {

    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_cacheForHeight removeObjectForKey:obj];
    }];
    
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
- (NSString *)updateDefalutCellReusedIdentifier:(id)data {
    if (self.updateDefalutCellReusedIdentifierCallBack) {
        return self.updateDefalutCellReusedIdentifierCallBack(self, data);
    }
    return nil;
}
- (void)updateDefalutCell:(id)data {
    self.defaultReusedIdentifier = [self updateDefalutCellReusedIdentifier:data];
    self.plotHeightForCell = self.plotHeightForCells[self.defaultReusedIdentifier];
}
#pragma mark -  <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    _contentOffsetY = 500;
    
    return self.style==UITableViewStylePlain?1:_datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.style==UITableViewStylePlain?_datas.count:[_datas[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model =self.style==UITableViewStylePlain?_datas[indexPath.row]:_datas[indexPath.section][indexPath.row];
    [self updateDefalutCell:model];
    JFBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.defaultReusedIdentifier];
    [cell setTableView:self];
    [cell updateCellForData:model];
    JGExBlock(self.cellUpdateCallBack, self, cell, model);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cacheHeightForIndexPath:indexPath];
//    JFBaseModel *model =self.style==UITableViewStylePlain?_datas[indexPath.row]:_datas[indexPath.section][indexPath.row];
//    [self updateDefalutCell:model];
//    return  ([_plotHeightForCell cellHeightForData:model]) + self.plotHeightForCell.height;
}
- (CGFloat)cacheHeightForIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *height = [_cacheForHeight objectForKey:indexPath];
    if (height) {
        return [height floatValue];
    }
     id model =self.style==UITableViewStylePlain?_datas[indexPath.row]:_datas[indexPath.section][indexPath.row];
    [self updateDefalutCell:model];
    CGFloat cellHeight = ([_plotHeightForCell cellHeightForData:model]) + self.plotHeightForCell.height;
    [_cacheForHeight setObject:@(cellHeight) forKey:indexPath];
    
    return cellHeight;
}
- (void)setFrame:(CGRect)frame {
    CGRect headerFrame = self.tableHeaderView.frame;
    [super setFrame:frame];
    [self.tableHeaderView setFrame:headerFrame];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!scrollView.contentSize.height) {
        return;
    }
    
    CGFloat a = scrollView.contentSize.height - scrollView.contentOffset.y;
    CGFloat b = scrollView.frame.size.height;
    if (_willAutoFooterRefresh) {
        if (a < b
            && !_isFootering) {
            _isFootering = YES;
            if (_footerCallback) {
                _footerCallback();
            }
        } else if (a > b) {
            _isFootering = NO;
        }
    }
    if (_willShowTopButton) {
        if (self.contentOffset.y < b || self.contentOffset.y <= 0) {
            self.topButton.hidden = YES;
        } else {
            self.topButton.hidden = NO;
        }
    }
    if (_willAutoHideNavigation) {
        if (self.contentOffset.y < self.contentSize.height-b-100 && ( self.contentOffset.y < _contentOffsetY || self.contentOffset.y < scrollView.frame.size.height)) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            
            [self.topButton setFrame:CGRectMake(self.topButton.frame.origin.x, _topButtonY - 44,
                                                self.topButton.frame.size.width, self.topButton.frame.size.height)];
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
            [self.topButton setFrame:CGRectMake(self.topButton.frame.origin.x, _topButtonY,
                                                self.topButton.frame.size.width, self.topButton.frame.size.height)];
        }
        _contentOffsetY = self.contentOffset.y;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGExBlock(self.didSelectRowAtIndexPath, self, indexPath);
}
@end
