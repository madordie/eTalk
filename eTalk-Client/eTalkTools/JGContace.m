//
//  JGContace.m
//  eTalk-4.0
//
//  Created by Keith on 14-6-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGContace.h"

@implementation JGContace

- (JGContace *)initWithName:(NSString *)aname ID:(NSString *)aID{
    if ([super init]) {
        self.name = aname;// [JGControl base64FromSocket:aname];
        self.ID  = aID;
    }
    return self;
}
+ (JGContace *)contaceWithName:(NSString *)name ID:(NSString *)ID {
    return [[[JGContace alloc] initWithName:name ID:ID] autorelease];
}
- (void)dealloc {
    self.name = nil;
    self.ID = nil;
    self.mm = nil;
    self.headImage = nil;
    [super dealloc];
}
#pragma mark - 联系人数据库语句
+ (NSString *)sqlCreatTableStatementWithID:(NSString *)ID {
    return [NSString stringWithFormat:@"create table Contaces%@ (ID char(10) not null PRIMARY KEY,name char(10),headImage char(10))", ID];
}

+ (NSString *)sqlAddContace:(JGContace *)contace WithID:(NSString *)ID {
    return [NSString stringWithFormat:@"insert into Contaces%@ (ID,name,headImage) values ('%@','%@','%@')", ID, contace.ID, contace.name, contace.headImage];
}
+ (NSString *)sqlDelContace:(JGContace *)contace WithID:(NSString *)ID {
    return [NSString stringWithFormat:@"delete from Contaces%@ where ID like '%@'", ID, contace.ID];
}
+ (NSString *)sqlSelContace:(JGContace *)contace WithID:(NSString *)ID {
    return [NSString stringWithFormat:@"select * from Contaces%@ where ID like '%@'", ID, contace.ID];
}
+ (NSString *)sqlSelAllContaceWithID:(NSString *)ID {
    return [NSString stringWithFormat:@"select * from Contaces%@", ID];
}


#pragma mark - 最近联系人数据库语句

+ (NSString *)sqlCreatTableRecentStatementWithID:(NSString *)ID{
    return [NSString stringWithFormat:@"create table RecentContaces%@ (ID char(10) not null PRIMARY KEY,name char(10), unnum char(1), headImage char(10))", ID];
}
+ (NSString *)sqlAddRecentContace:(JGContace *)contace WithID:(NSString *)ID andUnreadNum:(int)num{
    return [NSString stringWithFormat:@"insert into RecentContaces%@ (ID,name,unnum,headImage) values ('%@','%@','%c','%@')", ID, contace.ID, contace.name, num,contace.headImage];
}
+ (NSString *)sqlDelRecentContace:(JGContace *)contace  WithID:(NSString *)ID{
    return [NSString stringWithFormat:@"delete from RecentContaces%@ where ID like '%@'", ID, contace.ID];
}

+ (NSString *)sqlDelAllRecentContace:(NSString *)ID {
    return [NSString stringWithFormat:@"delete from RecentContaces%@", ID];
}

+ (NSString *)sqlSelRecentContace:(JGContace *)contace WithID:(NSString *)ID{
    return [NSString stringWithFormat:@"select * from RecentContaces%@ where ID like '%@'", ID, contace.ID];
}
+ (NSString *)sqlSelRecentAllContaceWithID:(NSString *)ID {
    return [NSString stringWithFormat:@"select * from RecentContaces%@", ID];
}
@end
