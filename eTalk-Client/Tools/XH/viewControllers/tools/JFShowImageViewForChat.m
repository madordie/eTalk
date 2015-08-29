//
//  JFShowImageViewForChat.m
//  SkinRun
//
//  Created by sl on 15/4/13.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFShowImageViewForChat.h"
#import "JFQuick.h"

@interface JFShowImageViewForChat () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation JFShowImageViewForChat

+ (instancetype)showImage:(UIImage *)image URL:(NSString *)url {
    JFShowImageViewForChat *view = [[JFShowImageViewForChat alloc] init];
//    JGWeakObjc(view);
    [view.imageView setImage:image];
//    [view.imageView setImageUrl:[NSURL URLWithString:url]
//               placeholderImage:image
//                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////                              [JFQuick runAfterSecs:0.3 block:^{
////                                  
//                                  [weakObjc layout];
////                              }];
//                          }];
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    [HUD setRemoveFromSuperViewOnHide:YES];
//    [HUD hide:NO];
//    [view.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
//    [HUD hide:YES];
//    [HUD removeFromSuperview];
    [view autoShow];
    return view;
}

- (void)layout {
    
    if (!_imageView.image) {
        return;
    }
    
    CGRect frame = [UIScreen mainScreen].bounds;
    _scrollView.frame = frame;
    CGPoint center = _scrollView.center;
    
    frame.size = _imageView.image.size;
    if (frame.size.height/frame.size.width > _scrollView.frame.size.height/JGTryGetDivisor(_scrollView.frame.size.width)) {
        //  高超出
        frame.size.width = _scrollView.frame.size.height*frame.size.width/JGTryGetDivisor(frame.size.height);
        frame.size.height = _scrollView.frame.size.height;
    } else {
        //  宽超出
        frame.size.height = _scrollView.frame.size.width*frame.size.height/JGTryGetDivisor(frame.size.width);
        frame.size.width = _scrollView.frame.size.width;
    }
    _imageView.frame = frame;
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    _imageView.center = center;
    _scrollView.contentSize = frame.size;
    
}
- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    
    _imageView = [[UIImageView alloc] init];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    _imageView.userInteractionEnabled = YES;
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView addSubview:_imageView];
    [self addSubview:_scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithView:self];
    [tap addGestureCallBack:^(UIGestureRecognizer *sender) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self removeFromSuperview];
    }];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithView:_imageView];
    [pinch addGestureCallBack:^(UIGestureRecognizer *sender) {
        UIPinchGestureRecognizer *pinch = (id)sender;
        
        CGRect frame = _imageView.bounds;
        frame.size.height *= pinch.scale;
        frame.size.width *= pinch.scale;
        _imageView.bounds = frame;
        frame = _imageView.frame;
        if (CGRectGetMaxX(_imageView.frame)>_scrollView.frame.size.width) {
            frame.origin.x = pinch.scale>1?MAX(frame.origin.x, 0):MIN(frame.origin.x, 0);
        }
        if (CGRectGetMaxY(_imageView.frame)>_scrollView.frame.size.height) {
            frame.origin.y = pinch.scale>1?MAX(frame.origin.y, 0):MIN(frame.origin.y, 0);
        }
        _imageView.frame = frame;
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame), CGRectGetMaxY(_imageView.frame));
        
        pinch.scale = 1;
    }];
    
    
    return _imageView;
}

#pragma mark -
- (void)autoShow {
    
    if (!_imageView.image) {
        NSLog(@"预览的图片为空");
        return;
    }
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [window addSubview:self];
    self.frame = [UIScreen mainScreen].bounds   ;
    [self layout];
}

@end
