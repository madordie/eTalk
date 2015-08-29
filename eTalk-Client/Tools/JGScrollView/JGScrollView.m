//
//  JGScrollView.m
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGScrollView.h"
#import "JGScrollViewTableViewCell.h"
#import "JGScrollViewCell.h"

@interface JGScrollView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *_reuseCells;
}

@end
@implementation JGScrollView
+ (JGScrollView *)scrollViewWithFrame:(CGRect)frame scrollViewDelegate:(id<JGScrollViewDelegate>)delegate {
    JGScrollView *sv = [[JGScrollView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [sv setScrolllViewDelegate:delegate];
    [sv setEstimatedSectionFooterHeight:0];
    [sv setEstimatedSectionHeaderHeight:0];
    return [sv autorelease];
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self setDelegate:self];
        [self setDataSource:self];
        _reuseCells = [[NSMutableDictionary alloc] init];
        self.scrollViewCellHeight = 140;
        self.scrollViewCellWide = 10;
        self.centerInVertical = YES;
        self.scrollViewCellSize = CGSizeMake(100, 140);
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)dealloc {
    [_reuseCells release], _reuseCells = nil;
    [super dealloc];
}
#pragma mark - scell重用
// 1. 字典存储
// 2. 重用标示符作为key
// 3. 每一个key下的value对应一个该类型的数组
// 4. 还没有充分测试。
- (JGScrollViewCell *)dequeueReusableScrollViewCellWithIdentifier:(NSString *)cellid {
    NSArray *keys = [_reuseCells allKeys];
    NSMutableArray *sameCells = nil;
    if ([keys containsObject:cellid]) { //查找是否有该类型存在。
        sameCells = _reuseCells[cellid];
    } else {
        return nil;     //不存在则直接返回
    }
    if ([sameCells count] == 0) {
        return nil;     //存在但是为空
    }
    
    JGScrollViewCell *cell = [sameCells firstObject];
    [[cell retain] autorelease];
    [sameCells removeObject:cell];
    return cell;
}

#pragma mark - tabelview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_scrolllViewDelegate respondsToSelector:@selector(numberOfLineWithScrollView:)]) {
        return [_scrolllViewDelegate numberOfLineWithScrollView:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cell";
    JGScrollViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [JGScrollViewTableViewCell cellWithOwner:self];
    }
    
    NSArray *subs = cell.scrollView.subviews;
    NSArray *allKeys = nil;   //取出垃圾站中的所有的key
    for (JGScrollViewCell *view in subs) {
        if (![view isKindOfClass:[JGScrollViewCell class]]) {
            continue;
        }
        allKeys = [_reuseCells allKeys];
            //逐个进行回收
        NSMutableArray *sameCells = nil;
        if ([allKeys containsObject:view.reuseId]) {
            sameCells = _reuseCells[view.reuseId];  //垃圾站中有该类型，则取出该类型的集合
        } else {
            sameCells = [NSMutableArray array];
        }
        [sameCells addObject:view];     //把该cell放入该类型的集合中
        [_reuseCells setValue:sameCells forKey:view.reuseId];   //更新该类型的集合
//        [_reuseCells addObject:view];
        [view removeFromSuperview];     //把该cell从父view移除
    }
        //获取该行的scrollViewCell个数
    NSInteger count = 0;
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:numberOfRowsInLine:)]) {
        count = [_scrolllViewDelegate scrollView:self numberOfRowsInLine:indexPath.section];
    }
        //排列
    CGFloat x = 0;
    for (int i=0; i<count; i++) {
        JGIndexPath *index = [JGIndexPath indexPathWithLine:indexPath.section row:i];
        CGFloat wide = _scrollViewCellWide;  //宽度默认10
        if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:wideForRowAtIndePath:)]) {
            wide = [_scrolllViewDelegate scrollView:self wideForRowAtIndePath:index];
        }
        x += wide;
            //取 scell
        JGScrollViewCell *scell = nil;
        if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:cellForRowAtIndexPath:)]) {
            scell = [_scrolllViewDelegate scrollView:self cellForRowAtIndexPath:index];
        }
        if (!scell) {
            return nil;
        }
            //
        CGSize size = _scrollViewCellSize;
        if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:sizeOfCellIndexPath:)]) {
            size = [_scrolllViewDelegate scrollView:self sizeOfCellIndexPath:index];
        }
            //cell上下居中
        if (self.isCenterInVertical) {
            CGFloat cellHeight = _scrollViewCellHeight;
            if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:heightForRowAtIndexPath:)]) {
                cellHeight = [_scrolllViewDelegate scrollView:self heightForRowAtIndexPath:index];
            }
            [scell setFrame:CGRectMake(x, (cellHeight-size.height)/2, size.width, size.height)];
        } else {
            [scell setFrame:CGRectMake(x, 0, size.width, size.height)];
        }
        [scell setIndexPath:index];
        [cell.scrollView addSubview:scell];
        x += size.width;
    }
    [cell.scrollView setContentSize:CGSizeMake(x, 0)];
    
        //设置每行的UIScrollView
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:subScrollViewOfLine:andScrollViewForLine:)]) {
        [_scrolllViewDelegate scrollView:self subScrollViewOfLine:indexPath.section andScrollViewForLine:cell.scrollView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:heightForRowAtIndexPath:)]) {
        return [_scrolllViewDelegate scrollView:self heightForRowAtIndexPath:[JGIndexPath indexPathWithLine:indexPath.section row:0]];
    }
    return _scrollViewCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:heightForFooterAtIndexPath:)]) {
        return [_scrolllViewDelegate scrollView:self heightForFooterAtIndexPath:section];
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:heightForHeaderAtIndexPath:)]) {
        return [_scrolllViewDelegate scrollView:self heightForHeaderAtIndexPath:section];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:viewForFooterInSection:)]) {
        return [_scrolllViewDelegate scrollView:self viewForFooterInSection:section];
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:viewForHeaderInSection:)]) {
        return [_scrolllViewDelegate scrollView:self viewForHeaderInSection:section];
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:titleForFooterInSection:)]) {
        return [_scrolllViewDelegate scrollView:self titleForFooterInSection:section];
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_scrolllViewDelegate respondsToSelector:@selector(scrollView:titleForHeaderInSection:)]) {
        return [_scrolllViewDelegate scrollView:self titleForHeaderInSection:section];
    }
    return nil;
}
@end
