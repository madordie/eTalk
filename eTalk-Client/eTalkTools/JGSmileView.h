//
//  JGSmileView.h
//  eTalk-4.1
//
//  Created by madordie on 14-8-25.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGSmileViewDelegate.h"

@interface JGSmileView : UIView
@property (nonatomic, assign) id<JGSmileViewDelegate> smileViewDelegate;
@property (nonatomic, copy) NSString *filePath;

+ (JGSmileView *)smileViewWithFrame:(CGRect)frame file:(NSString *)path smileViewDelegate:(id<JGSmileViewDelegate>)smileViewDelegate;


@end
