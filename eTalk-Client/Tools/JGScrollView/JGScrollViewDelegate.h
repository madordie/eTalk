//
//  JGScrollViewDelegate.h
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "JGIndexPath.h"

@class JGScrollView;
@class JGScrollViewCell;

@protocol JGScrollViewDelegate <NSObject>
    //总行数
- (NSInteger)numberOfLineWithScrollView:(JGScrollView *)scrollView;
    //每行列数
- (NSInteger)scrollView:(JGScrollView *)scrollView numberOfRowsInLine:(NSInteger)line;

    //数据填充
- (JGScrollViewCell *)scrollView:(JGScrollView *)scrollView cellForRowAtIndexPath:(JGIndexPath *)indexPath;
    //每个cell的尺寸
- (CGSize)scrollView:(JGScrollView *)scrollView sizeOfCellIndexPath:(JGIndexPath *)indexPath;

@optional
    //设置每行的滚动视图UIScrollView
- (void)scrollView:(JGScrollView *)scrollView subScrollViewOfLine:(NSInteger)line andScrollViewForLine:(UIScrollView *)subScrollView;
    //设置每行的头尾视图
- (UIView *)scrollView:(JGScrollView *)scrollView viewForHeaderInSection:(NSInteger)line;
- (UIView *)scrollView:(JGScrollView *)scrollView viewForFooterInSection:(NSInteger)line;
- (NSString *)scrollView:(JGScrollView *)scrollView titleForHeaderInSection:(NSInteger)line;
- (NSString *)scrollView:(JGScrollView *)scrollView titleForFooterInSection:(NSInteger)line;

    //高度
- (CGFloat)scrollView:(JGScrollView *)scrollView heightForRowAtIndexPath:(JGIndexPath *)indexPath;
- (CGFloat)scrollView:(JGScrollView *)scrollView heightForHeaderAtIndexPath:(NSInteger)line;
- (CGFloat)scrollView:(JGScrollView *)scrollView heightForFooterAtIndexPath:(NSInteger)line;
    //与上一个的距离
- (CGFloat)scrollView:(JGScrollView *)scrollView wideForRowAtIndePath:(JGIndexPath *)indePath;

@end
