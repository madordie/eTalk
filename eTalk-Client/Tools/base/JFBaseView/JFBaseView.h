//
//  JFBaseView.h
//  SkinRun
//
//  Created by sl on 15/1/6.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFBaseView : UIView 

+ (instancetype)view;
+ (instancetype)viewWithFrame:(CGRect)frame;

/**
    initSomething for init later.
 */
- (void)initSomething;

@end
