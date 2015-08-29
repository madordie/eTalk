//
//  JGSocketMsg.m
//  eTalk-4.0
//
//  Created by Keith on 14-6-15.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGSocketMsg.h"

@implementation JGSocketMsg

@synthesize mm, fromId, toId, tp, tpbl, tped, msg;
- (void)dealloc {
    self.mm = nil;
    self.fromId = nil;
    self.toId = nil;
    self.msg = nil;
    [super dealloc];
}
- (NSString *)socketmsgToStrmsg {
    const char *chmm, *chfid, *chtid, *chmsg;
    if ([mm length]) {
        chmm = [mm UTF8String];
    } else {
        chmm = "\0";
    }
    if ([fromId length]) {
        chfid = [fromId UTF8String];
    } else {
        chfid = "\0";
    }
    if ([toId length]) {
        chtid = [toId UTF8String];
    } else {
        chtid = "\0";
    }
    if ([msg length]) {
        chmsg = [msg UTF8String];
    } else {
        chmsg = "\0";
    }

    return [NSString stringWithFormat:@"%s#%s#%s#%c#%c#%c#%s", chmm, chfid, chtid, tp, tped, tpbl, chmsg];
}

+ (NSString *)msgMake:(NSString *)one two:(NSString *)two {
    return [NSString stringWithFormat:@"%@`%@", one, two];
}
+ (NSArray *)msgCat:(NSString *)msg {
    return [msg componentsSeparatedByString:@"`"];
}
- (JGSocketMsg *)initWithStrmsg:(NSString *)strmsg {
    if ([super init]) {
        NSArray *msgArray = [strmsg componentsSeparatedByString:@"#"];
        self.mm = msgArray[0];
        self.fromId = msgArray[1];
        self.toId = msgArray[2];

        NSString *s = msgArray[3];
        if ([s length] == 0) {
            self.tp = MSG_NONE;
        } else
            self.tp = [s characterAtIndex:0];
        s = msgArray[4];
        if ([s length] == 0) {
            self.tped = MSG_NONE;
        } else
            self.tped = [s characterAtIndex:0];
        s = msgArray[5];
        if ([s length] == 0) {
            self.tpbl = MSG_NONE;
        } else
            self.tpbl = [s characterAtIndex:0];

        self.msg = msgArray[6];
    }
    return self;
}
- (JGSocketMsg *)msgWithStrmsg:(NSString *)strmsg {
    return [[[JGSocketMsg alloc] initWithStrmsg:strmsg] autorelease];
}

- (JGSocketMsg *)initWithMM:(NSString *)amm from:(NSString *)afrom to:(NSString *)ato tp:(char)atp tped:(char)atped tpbl:(char)atpbl msg:(NSString *)amsg {
    if ([super init]) {
        self.mm = amm?amm:@"";
        self.fromId = afrom;
        self.toId = ato;
        self.tp = atp;
        self.tped = atped;
        self.tpbl = atpbl;
        self.msg = amsg;
    }
    return self;
}
+ (JGSocketMsg *)msgWithMM:(NSString *)mm from:(NSString *)from to:(NSString *)to tp:(char)tp tped:(char)tped tpbl:(char)tpbl msg:(NSString *)msg {
    return [[[JGSocketMsg alloc] initWithMM:mm from:from to:to tp:tp tped:tped tpbl:tpbl msg:msg] autorelease];
}

+ (JGSocketMsg *)msgWithTo:(NSString *)to tp:(char)tp tped:(char)tped tpbl:(char)tpbl msg:(NSString *)msg {
    return [[[JGSocketMsg alloc] initWithMM:nil from:nil to:to tp:tp tped:tped tpbl:tpbl msg:msg] autorelease];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"mm:%@ fid:%@ tid:%@ tp:%d tped:%d tpbl:%c msg:%@", self.mm, self.fromId, self.toId, self.tp, self.tped, self.tpbl, self.msg];
}
@end
