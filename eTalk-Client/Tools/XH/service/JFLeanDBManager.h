//
//  JFLeanDBManager.h
//  SkinRun
//
//  Created by sl on 15/3/30.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "JFLeanChatMessage.h"

@interface JFLeanDBManager : NSObject
extern FMDatabaseQueue *_dbQueue;
/**
 *  数据库初始化。包括自动删除
 */
+ (void)autoInitWithUserID:(NSString *)userID callBack:(void(^)(void))callBack;
/**
 *  插入数据
 *
 *  @param meodel 需要遵守插入协议（返回sql语句)。
 */
+ (void)autoInstallMessage:(JFLeanChatMessage *)meodel;
/**
 *  检索
 *
 *  @param time     该时间点之前的消息
 *  @param compleat 检索完毕之后的消息数组以及消息条数 message:JFLeanmessgeModel
 */
#define JFLeanMessageLimit  10
+ (void)autoReadMessageTime:(NSTimeInterval)time
                   compleat:(void(^)(NSArray *messages))compleat;
/**
 *  更新状态
 *
 *  @param time       该时间点之前
 *  @param stateIsNew 状态
 */
+ (void)autoUpdateMessageTime:(NSUInteger)time
                   stateIsNew:(BOOL)stateIsNew;
@end
