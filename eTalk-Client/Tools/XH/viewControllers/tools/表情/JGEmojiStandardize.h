//
//  JGEmojiStandardize.h
//  SkinRun
//
//  Created by sl on 15/1/23.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGEmojiStandardize : NSObject


+ (NSArray *)emojiDictionary;
+ (NSArray *)emojiList;

+ (NSString *)convertToCommonEmoticons:(NSString *)text;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;


@end
