//
//  UIButton+quick.h
//  SkinRun
//
//  Created by sl on 15/1/12.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (quick)

- (void)setTitleForNormal:(NSString *)title;
- (void)setBackgroundImageForNormal:(NSString *)image;
- (void)setImageForNormal:(NSString *)image;

@end

typedef void(^JGButtonActionBlock)(id sender, UIButton *button, UIControlEvents events);