//
//  UITableViewCell+quick.m
//  SkinRun
//
//  Created by sl on 15/1/20.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "UITableViewCell+quick.h"

@implementation UITableViewCell (quick)

+ (UINib *)returnNib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}
+ (NSString *)returnDefaultReuseIdentifier {
    return NSStringFromClass(self);
}
+ (void)autoRegistNibForTableView:(UITableView *)tableView {
    [tableView registerNib:[self returnNib] forCellReuseIdentifier:[self returnDefaultReuseIdentifier]];
}
+ (void)autoRegistClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:[self returnDefaultReuseIdentifier]];
}

@end
