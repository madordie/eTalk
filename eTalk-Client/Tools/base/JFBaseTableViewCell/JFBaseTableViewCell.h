//
//  JFBaseTableViewCell.h
//  SkinRun
//
//  Created by sl on 15/1/2.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFQuick.h"
#import "JFBaseTableView.h"

@interface JFBaseTableViewCell : UITableViewCell

#pragma mark - menuController
@property (nonatomic, assign, getter=isCanMenuControl) BOOL menuControl;    //Default NO
@property (nonatomic, strong) NSMutableArray *menuControlItems; //编辑菜单UIMenuItem s.
- (void)setMenuTargetRectInView:(UIMenuController *)menu;   //编辑菜单开始位置

//UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//pasteboard.string = self.label.text;


#pragma mark - 附加内容
@property (nonatomic, assign) JFBaseTableView *tableView;
@property (nonatomic, strong) id updateData;

#pragma mark - 额外增加高度
@property (nonatomic, assign) CGFloat height;


#pragma mark - 填充数据
- (void)updateCellForData:(id)data;

#pragma mark - 自动计算高度
- (CGFloat)cellHeightForData:(id)data;
- (CGFloat)cellHeight;

@end

@interface UILabel (heightForCell)

- (CGFloat)heightForLabel;

@end