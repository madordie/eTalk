//
//  JFLeanService.h
//  SkinRun
//
//  Created by sl on 15/3/27.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFLeanServiceHeader.h"
#import "JFLeanChatMessage.h"
#import "JGContace.h"

/**
 *  数据库指针,用作判段是否准备好数据库
 */
@class FMDatabaseQueue;
extern FMDatabaseQueue *_dbQueue;

@interface JFLeanService : NSObject

+ (instancetype)shared;

/**
 *  消息发送获取
 */
+ (void)autoSendeMessage:(JFLeanChatMessage *)model toContace:(JGContace *)contace;
+ (void)autoReadMessageLastTime:(NSTimeInterval)time complete:(void(^)(NSArray *messages))complete;

/**
 *  消息广播
 */
+ (void)postMessageNotifyForUpdatemessage;
+ (void)addMessageObserver:(id)target selector:(SEL)selector;
+ (void)removeMessageObserver:(id)target;

@end
