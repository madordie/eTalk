//
//  JGScrollViewTableViewCell.m
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGScrollViewTableViewCell.h"

@implementation JGScrollViewTableViewCell
+ (JGScrollViewTableViewCell *)cellWithOwner:(id)owner {
    JGScrollViewTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JGScrollViewTableViewCell class]) owner:owner options:nil] lastObject];
    [cell.scrollView setAlwaysBounceHorizontal:YES];
    [cell.scrollView setAlwaysBounceVertical:NO];
    return cell;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}
@end
