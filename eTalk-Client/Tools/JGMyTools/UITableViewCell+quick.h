//
//  UITableViewCell+quick.h
//  SkinRun
//
//  Created by sl on 15/1/20.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (quick)

+ (UINib *)returnNib;
+ (NSString *)returnDefaultReuseIdentifier;
+ (void)autoRegistNibForTableView:(UITableView *)tableView;
+ (void)autoRegistClassForTableView:(UITableView *)tableView;
@end
