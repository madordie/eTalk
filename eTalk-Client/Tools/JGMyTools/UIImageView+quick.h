//
//  UIImageView+quick.h
//  SkinRun
//
//  Created by sl on 15/1/9.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (quick)

- (void)setImageName:(NSString *)imageName;

+ (instancetype)imageViewWithName:(NSString *)imageName;

@end
