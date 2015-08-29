//
//  JFBaseView.m
//  SkinRun
//
//  Created by sl on 15/1/6.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFBaseView.h"
#import "JFQuick.h"

@implementation JFBaseView

+(instancetype)viewWithFrame:(CGRect)frame {
    
    JFBaseView *view = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"]]) {
        view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                              owner:nil
                                            options:nil] firstObject];
    } else {
        view = [[self alloc] init];
    }
    if (!CGRectIsNull(frame)) {
        [view setFrame:frame];
    }
    [view initSomething];
    return view;
}
+ (instancetype)view {
    JFBaseView *view = [self viewWithFrame:CGRectNull];
    return view;
}

/**
    initSomething for init later.
 */
- (void)initSomething {

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
