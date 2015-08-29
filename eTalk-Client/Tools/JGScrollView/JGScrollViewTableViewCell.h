//
//  JGScrollViewTableViewCell.h
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGScrollViewTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

+ (JGScrollViewTableViewCell *)cellWithOwner:(id)owner;

@end
