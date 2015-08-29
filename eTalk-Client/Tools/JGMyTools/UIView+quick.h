//
//  UIView+quick.h
//  SkinRun
//
//  Created by sl on 14-12-25.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (quick)


- (CGFloat)quickWidth;
- (CGFloat)quickHeight;
- (CGFloat)quickX;
- (CGFloat)quickY;

//+ (instancetype)view;


- (void)showHUD;
- (void)hideHUD;


#pragma mark - size
- (CGFloat)quickContentHeight;
- (CGFloat)quickContentWidth;
- (CGSize)quickContentSize:(CGSize)size;


@end
