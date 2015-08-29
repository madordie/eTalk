//
//  UIButton+quick.m
//  SkinRun
//
//  Created by sl on 15/1/12.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "UIButton+quick.h"

@implementation UIButton (quick)
- (void)setTitleForNormal:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.text = title;
}
- (void)setBackgroundImageForNormal:(NSString *)image {
    [self setBackgroundImage:[UIImage imageNamed:image]
                    forState:UIControlStateNormal];
}
- (void)setImageForNormal:(NSString *)image {
    [self setImage:[UIImage imageNamed:image]
          forState:UIControlStateNormal];
}
@end
