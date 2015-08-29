//
//  JGScrollView.h
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#warning JGScrollView警告
//  警告：
//      cell的重用标示符暂时没有用，就是说每一个cell都是一样的。
//
//     row0     row1
//  -----------------------------
//  |       ||        ||        |
//  |       ||        ||        |   line0
//  |       ||        ||        |
//  |       ||        ||        |
//  -----------------------------
//  |       ||        ||        |
//  |       ||        ||        |   line1
//  |       ||        ||        |
//  |       ||        ||        |
//  -----------------------------
//  |       ||        ||        |
//  |       ||        ||        |
//  |       ||        ||        |
//  |       ||        ||        |
//  -----------------------------
//  |       ||        ||        |
//  |       ||        ||        |
//  |       ||        ||        |
//  |       ||        ||        |
//  -----------------------------
//  整体为UITableView的分组模式。
//  line 为每一组中的唯一一行，所以具有头尾视图。
//  (line0, row0):JGScrollViewCell = scrollView
//  line0 = header + JGScrollViewTableViewCell + footer
//

#import <UIKit/UIKit.h>
#import "JGScrollViewDelegate.h"
#import "JGScrollViewCell.h"
@interface JGScrollView : UITableView

@property (nonatomic, assign, getter = isCenterInVertical) BOOL centerInVertical;   //D：YES。scrollViewCell竖直方向是否居中
@property (nonatomic, assign) CGFloat scrollViewCellHeight; //D：140。默认的scroll高度
@property (nonatomic, assign) CGSize scrollViewCellSize;    //D:(100,140)。默认scrollViewCell大小
@property (nonatomic, assign) CGFloat scrollViewCellWide;    //D:10。每个cell的距离

@property (nonatomic, assign) id<JGScrollViewDelegate> scrolllViewDelegate;

+ (JGScrollView *)scrollViewWithFrame:(CGRect)frame scrollViewDelegate:(id<JGScrollViewDelegate>)delegate;

- (JGScrollViewCell *)dequeueReusableScrollViewCellWithIdentifier:(NSString *)cellid;

@end
