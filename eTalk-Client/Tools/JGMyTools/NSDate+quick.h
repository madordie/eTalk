//
//  NSDate+quick.h
//  SkinRun
//
//  Created by sl on 15/1/26.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (quick)
+ (NSDate *)dateFormatter:(NSString *)frome date:(NSString *)date;
- (NSString *)dateFormatter:(NSString *)formatter;

/**
    本地化时间
*/
- (NSString *)JFLocalTimer;
@end
