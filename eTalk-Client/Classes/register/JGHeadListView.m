//
//  JGHeadListView.m
//  eTalk-4.1
//
//  Created by Mac on 14-10-25.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGHeadListView.h"
@interface JGHeadListView () <JGScrollViewDelegate, JGScrollViewCellDelegate>

@end

@implementation JGHeadListView

+ (JGHeadListView *)headListViewWithFrame:(CGRect)frame withDelegate:(id<JGHeadListViewDelegate>)delegate {
    JGHeadListView *sv = [[JGHeadListView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [sv setScrolllViewDelegate:sv];
    [sv setEstimatedSectionFooterHeight:0];
    [sv setEstimatedSectionHeaderHeight:0];
    [sv setListDelegate:delegate];
    [sv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [sv setBackgroundColor:[UIColor blackColor]];
    return sv;
}


#pragma mark - JGScrollViewCellDelegate
- (void)scrollViewCell:(JGScrollViewCell *)scrollViewCell didSelectRowAtIndexPath:(JGIndexPath *)indexPath {
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:self.oldFrame];
    } completion:^(BOOL finished) {
        if ([_listDelegate respondsToSelector:@selector(headListView:didSelectImageName:)]) {
            [_listDelegate headListView:self didSelectImageName:[NSString stringWithFormat:@"%d", (int)scrollViewCell.tag]];
        }
        [self removeFromSuperview];
    }];
}
#pragma mark - JGScrollViewDelegate
- (NSInteger)scrollView:(JGScrollView *)scrollView numberOfRowsInLine:(NSInteger)line {
    return line != 21 ? 6:1 ;
}
- (NSInteger)numberOfLineWithScrollView:(JGScrollView *)scrollView {
    return 4;
}
- (JGScrollViewCell *)scrollView:(JGScrollView *)scrollView cellForRowAtIndexPath:(JGIndexPath *)indexPath {
    static NSString *idcell = @"cell";
    JGScrollViewCell *cell = [scrollView dequeueReusableScrollViewCellWithIdentifier:idcell];
    if (!cell) {
        cell = [JGScrollViewCell cellWithOwner:self reuseid:idcell];
        [cell setDelegate:self];
        [cell.imageView setFrame:cell.contentView.bounds];
        [cell setTag:-1];
    }
    [cell setTag:indexPath.line*6+indexPath.row+1];
    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", (int)cell.tag]]];
    return cell;
}
- (void)scrollView:(JGScrollView *)scrollView subScrollViewOfLine:(NSInteger)line andScrollViewForLine:(UIScrollView *)subScrollView {
    [subScrollView setScrollEnabled:NO];
}
- (CGSize)scrollView:(JGScrollView *)scrollView sizeOfCellIndexPath:(JGIndexPath *)indexPath {
    return CGSizeMake(40, 40);
}
- (CGFloat)scrollView:(JGScrollView *)scrollView heightForRowAtIndexPath:(JGIndexPath *)indexPath {
    return 50;
}
@end
