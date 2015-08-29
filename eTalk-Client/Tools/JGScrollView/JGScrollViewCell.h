//
//  JGScrollViewCell.h
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGIndexPath.h"

@class JGScrollViewCell;
@protocol JGScrollViewCellDelegate <NSObject>

@optional
- (void)scrollViewCell:(JGScrollViewCell *)scrollViewCell didSelectRowAtIndexPath:(JGIndexPath *)indexPath;

@end

@interface JGScrollViewCell : UIView
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, retain) NSString *reuseId;

@property (nonatomic, retain) JGIndexPath *indexPath;

@property (nonatomic, assign) id<JGScrollViewCellDelegate> delegate;

+ (JGScrollViewCell *)cellWithOwner:(id)owner reuseid:(NSString *)reuseid;
- (IBAction)cellHaveClick:(UIButton *)sender;

@end
