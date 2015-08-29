//
//  JGChat.m
//  eTalk-4.0
//
//  Created by Keith on 14-6-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGChat.h"

@implementation JGChat

- (JGChat *)initWithMsg:(NSString *)amsg isMine:(BOOL)aisMine msgTime:(NSString *)amsgTime {
    if ([super init]) {
        self.msg = amsg;
        self.isMine = aisMine;
        self.msgTime = amsgTime;
    }
    return self;
}
+ (JGChat *)chatWithMsg:(NSString *)msg isMine:(BOOL)isMine msgTime:(NSString *)msgTime {
    return [[[JGChat alloc] initWithMsg:msg isMine:isMine msgTime:msgTime] autorelease];
}

- (void)dealloc {
    self.msg = nil;
    self.msgTime = nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.msg forKey:@"chatMsg"];
    [aCoder encodeBool:self.isMine forKey:@"isMine"];
    [aCoder encodeObject:self.msgTime forKey:@"chatMsgTime"];

}
- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];
    if (self) {
        self.msg = [aDecoder decodeObjectForKey:@"chatMsg"];
        self.isMine = [aDecoder decodeBoolForKey:@"isMine"];
        self.msgTime = [aDecoder decodeObjectForKey:@"chatMsgTime"];
    }
   
    return self;
}


@end
