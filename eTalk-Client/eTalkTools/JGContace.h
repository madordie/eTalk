//
//  JGContace.h
//  eTalk-4.0
//
//  Created by Keith on 14-6-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGContace : NSObject
{
    
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *mm;
@property (nonatomic, assign) int unreadNum;
@property (nonatomic, copy) NSString *headImage;

- (JGContace *)initWithName:(NSString *)name ID:(NSString *)ID;
+ (JGContace *)contaceWithName:(NSString *)name ID:(NSString *)ID;

#pragma mark - 联系人数据库语句
+ (NSString *)sqlCreatTableStatementWithID:(NSString *)ID;
+ (NSString *)sqlAddContace:(JGContace *)contace WithID:(NSString *)ID;
+ (NSString *)sqlDelContace:(JGContace *)contace WithID:(NSString *)ID;
+ (NSString *)sqlSelContace:(JGContace *)contace WithID:(NSString *)ID;
+ (NSString *)sqlSelAllContaceWithID:(NSString *)ID;

#pragma mark - 最近联系人数据库语句
+ (NSString *)sqlCreatTableRecentStatementWithID:(NSString *)ID;
+ (NSString *)sqlAddRecentContace:(JGContace *)contace WithID:(NSString *)ID andUnreadNum:(int)num;
+ (NSString *)sqlDelRecentContace:(JGContace *)contace WithID:(NSString *)ID;
+ (NSString *)sqlSelRecentContace:(JGContace *)contace WithID:(NSString *)ID;
+ (NSString *)sqlSelRecentAllContaceWithID:(NSString *)ID;
+ (NSString *)sqlDelAllRecentContace:(NSString *)ID;

@end
