//
//  UIGestureRecognizer+quick.m
//  SkinRun
//
//  Created by sl on 15/4/8.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "UIGestureRecognizer+quick.h"
#import <objc/runtime.h>

static const void *callBackBlockKey = &callBackBlockKey;

@implementation UIGestureRecognizer (quick)
- (instancetype)initWithView:(UIView *)view {
    self = [self init];
    if (self) {
        [view addGestureRecognizer:self];
    }
    return self;
}
- (instancetype)initWithGestureCallBack:(void (^)(UIGestureRecognizer*))callBack {
    self = [self init];
    if (self) {
        [self addGestureCallBack:callBack];
    }
    return self;
}
- (void)addGestureCallBack:(void (^)(UIGestureRecognizer*))callBack {
    objc_setAssociatedObject(self, callBackBlockKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(eventCallBack:)];
}
- (void)eventCallBack:(id)sender {
    void (^block)(id) = objc_getAssociatedObject(self, callBackBlockKey);
    block?block(self):nil;
}

@end
