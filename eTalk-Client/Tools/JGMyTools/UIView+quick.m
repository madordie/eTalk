//
//  UIView+quick.m
//  SkinRun
//
//  Created by sl on 14-12-25.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import "UIView+quick.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIView (quick)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUD {
    [self setHUD:[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES]];
    [[self HUD] setRemoveFromSuperViewOnHide:NO];
}
- (void)hideHUD {
    [[self HUD] hide:YES];
}


- (CGFloat)quickWidth {
    return self.frame.size.width;
}
- (CGFloat)quickHeight {
    return self.frame.size.height;
}
- (CGFloat)quickX {
    return self.frame.origin.x;
}
- (CGFloat)quickY {
    return self.frame.origin.y;
}


- (CGFloat)quickContentHeight {
    CGRect frame = self.frame;
    frame.size.height = CGFLOAT_MAX;
    self.frame = frame;
    [self sizeToFit];
    return self.quickHeight;
}
- (CGFloat)quickContentWidth {
    CGRect frame = self.frame;
    frame.size.width = CGFLOAT_MAX;
    self.frame = frame;
    [self sizeToFit];
    return self.quickWidth;
}
- (CGSize)quickContentSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    [self sizeThatFits:size];
    return self.frame.size;
}
@end
