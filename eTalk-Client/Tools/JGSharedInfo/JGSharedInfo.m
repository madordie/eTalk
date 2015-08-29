//
//  JGSharedInfo.m
//  eTalk
//
//  Created by sl on 15/3/26.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGSharedInfo.h"
#import "JGSocketManager.h"

static JGSharedInfo *_self;
@implementation JGSharedInfo

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _self = [[self alloc] init];
    });
    
    return _self;
}

#define JGSharedInfoKeyIpPort   @"JGSharedInfoKeyIpPort"
+ (void)writerIP:(NSString *)ip port:(NSString *)port {
    [[NSUserDefaults standardUserDefaults] setObject:@{@"ip":ip,
                                                       @"port":port}
                                              forKey:JGSharedInfoKeyIpPort];
}
+ (void)readIP:(NSString *__autoreleasing *)ip port:(NSString *__autoreleasing *)port {
    NSDictionary *ipport = [[NSUserDefaults standardUserDefaults] objectForKey:JGSharedInfoKeyIpPort];
    if (ipport) {
        *ip = ipport[@"ip"];
        *port = ipport[@"port"];
    } else {
        *ip = @"";
        *port = @"";
    }
}

#define JGSharedInfoKeyIDPassword   @"JGSharedInfoKeyIDPassword"
+ (void)writerID:(NSString *)ID password:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:@{@"id":JGTryGetString(ID),
                                                      @"pw":JGTryGetString(password)}
                                              forKey:JGSharedInfoKeyIDPassword];
}
+ (void)readerID:(NSString *__autoreleasing *)ID password:(NSString *__autoreleasing *)password {
    NSDictionary *idPw = [[NSUserDefaults standardUserDefaults] objectForKey:JGSharedInfoKeyIDPassword];
    *ID = JGTryGetString(idPw[@"id"]);
    *password = JGTryGetString(idPw[@"pw"]);
}
- (NSString *)serverIP {
    return [JGSocketManager shared].serverIP;
}
- (NSString *)serverPort {
    return [NSString stringWithFormat:@"%d", (int)[JGSocketManager shared].serverPort];
}

@end
