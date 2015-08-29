//
//  UIGestureRecognizer+quick.h
//  SkinRun
//
//  Created by sl on 15/4/8.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (quick)
- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithGestureCallBack:(void(^)(UIGestureRecognizer * sender))callBack;
- (void)addGestureCallBack:(void(^)(UIGestureRecognizer * sender))callBack;
@end
