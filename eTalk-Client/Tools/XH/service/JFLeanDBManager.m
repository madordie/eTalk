//
//  JFLeanDBManager.m
//  SkinRun
//
//  Created by sl on 15/3/30.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFLeanDBManager.h"
#import "JFLeanService.h"
#import "JFQuick.h"


#define MSG_TABLE_SQL @"CREATE TABLE IF NOT EXISTS `msgs` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `object` BLOB NOT NULL,`time` VARCHAR(63) NOT NULL)"

FMDatabaseQueue *_dbQueue;
static JFLeanDBManager *_self;
static NSString *_userID;
@interface JFLeanDBManager ()
@end
@implementation JFLeanDBManager
+ (void)autoInitWithUserID:(NSString *)userID callBack:(void(^)(void))callBack{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _self = [[self alloc] init];
    });
    _userID = userID;
    [_self setupWithUserId:userID callBack:callBack];
}
+ (void)autoInstallMessage:(JFLeanChatMessage *)meodel {
    if (!meodel.senderMessage) {
        return;
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSData* data=[NSKeyedArchiver archivedDataWithRootObject:meodel];
        [db executeUpdate:@"INSERT INTO msgs (object,time) VALUES(?,?)"
     withArgumentsInArray:@[data, meodel.time]];
        
        [JFQuick runAfterSecs:0.2 block:^{
            [JFLeanService postMessageNotifyForUpdatemessage];
        }];
//        [JFQuick runInMainQueue:^{
//            [JFLeanService postMessageNotifyForUpdatemessage];
//        }];
    }];

}
+ (void)autoReadMessageTime:(NSTimeInterval)time compleat:(void (^)(NSArray *))compleat {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString* timeStr= [@(time) stringValue];
        FMResultSet* rs=[db executeQuery:@"select * from msgs where time<? order by time desc limit ?" withArgumentsInArray:@[timeStr,@(JFLeanMessageLimit)]];
        
        NSMutableArray *result = [NSMutableArray array];
        while ([rs next]) {
            NSData* data=[rs objectForColumnName:@"object"];
            if([data isKindOfClass:[NSData class]] && data.length>0){
                JFLeanChatMessage* msg = nil;
                @try {
                    msg=[NSKeyedUnarchiver unarchiveObjectWithData:data];
                    msg.time = [rs objectForColumnName:@"time"];
                }
                @catch (NSException *exception) {
                }
                if (msg) {
                    [result addObject:msg];
                }
            }
        }
        [rs close];
        
        NSMutableArray* array=[NSMutableArray arrayWithCapacity:[result count]];
        NSEnumerator* enumerator=[result reverseObjectEnumerator];
        for(id element in enumerator){
            [array addObject:element];
        }
        
        JGExBlock(compleat, array);
    }];
}
+ (void)autoUpdateMessageTime:(NSUInteger)time stateIsNew:(BOOL)stateIsNew {

}

- (NSString *)dbPathWithUserId:(NSString*)userId {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"DB path:%@", libPath);
    return [libPath stringByAppendingPathComponent:[NSString stringWithFormat:@"chat_%@",userId]];
}

-(void)setupWithUserId:(NSString*)userId callBack:(void(^)(void))callBack {
    _dbQueue=[FMDatabaseQueue databaseQueueWithPath:[self dbPathWithUserId:userId]];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:MSG_TABLE_SQL];
        [JFQuick runInMainQueue:^{
            JGExBlock(callBack);
        }];
    }];
}

@end
