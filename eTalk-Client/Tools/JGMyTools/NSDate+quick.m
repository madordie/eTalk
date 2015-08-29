//
//  NSDate+quick.m
//  SkinRun
//
//  Created by sl on 15/1/26.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "NSDate+quick.h"
#import "JFQuick.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

@implementation NSDate (quick)
+ (NSDate *)dateFormatter:(NSString *)frome date:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = frome;
    NSDate *localDate = [formatter dateFromString:date];
    return localDate;
}
- (NSString *)dateFormatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:self];
}

/*
 5分钟以内：刚刚
 5分钟及以上开始统计时间：XX分钟以前
 60分钟及以上以小时计：XX小时以前
 一天以上按天计：X天以前
 第6天及以上显示发布月日：06-24，当年不显示年份，往年加上2013-06-24
 */
- (NSString *)JFLocalTimer
{
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 300) {    //五分钟以内
        return @"刚刚";
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:@"%d分钟前", (int)timeInterval / 60];
    } else if (timeInterval < 86400) {
        return [NSString stringWithFormat:@"%d小时前", (int)timeInterval / 3600];
    } else if (timeInterval < 518400) {//6天内
        return [NSString stringWithFormat:@"%d天前", (int)timeInterval / 86400];
    } else if (timeInterval < 31536000) {//30天至1年内
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"MM-dd"];
        return [dateFormatter stringFromDate:self];
    } else {
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:self];
    }
}

@end
