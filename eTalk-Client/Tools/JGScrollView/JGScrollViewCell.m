//
//  JGScrollViewCell.m
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGScrollViewCell.h"

@implementation JGScrollViewCell
+ (JGScrollViewCell *)cellWithOwner:(id)owner reuseid:(NSString *)reuseid{
    JGScrollViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JGScrollViewCell class]) owner:owner options:nil] lastObject];
    
    [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:8];
    cell.reuseId = reuseid;
    return cell;
}

- (IBAction)cellHaveClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(scrollViewCell:didSelectRowAtIndexPath:)]) {
        [_delegate scrollViewCell:self didSelectRowAtIndexPath:self.indexPath];
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_imageView release];
    [_label release];
    [_backgroundImageView release];
    [_contentView release];
    [super dealloc];
}
@end
