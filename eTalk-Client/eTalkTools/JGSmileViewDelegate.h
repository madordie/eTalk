//
//  JGSmileViewDelegate.h
//  eTalk-4.1
//
//  Created by madordie on 14-8-25.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JGSmileView;
@protocol JGSmileViewDelegate <NSObject>

@optional
- (void)smileView:(JGSmileView *)smileView didSelectSmile:(NSString *)smile;
- (void)smileView:(JGSmileView *)smileView loadSmileError:(NSError *)error;

@end
