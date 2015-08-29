//
//  UIImageView+quick.m
//  SkinRun
//
//  Created by sl on 15/1/9.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "UIImageView+quick.h"

@implementation UIImageView (quick)

- (void)setImageName:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName]];
}
+ (instancetype)imageViewWithName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageName:imageName];
    return imageView;
}
@end
