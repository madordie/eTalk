//
//  JGSocketManager.m
//  eTalk-4.1
//
//  Created by madordie on 14-8-19.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGSocketManager.h"
#import "JGSocket.h"
#import "JGSocketMsg.h"
@implementation JGSocketManager

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _socket = [[JGSocket alloc] init];
    [_socket setDelegate:self];
    self.contace = nil;
    return self;
}

- (void)dealloc {
    self.contace = nil;
    [self.db dbClose];
    self.db = nil;
    [super dealloc];
}

+ (JGSocketManager *)shared {
    static JGSocketManager *manager;
    if (!manager) {
        manager = [[JGSocketManager alloc] init];
        [manager startListen];
    }
    return manager;
}

- (void)setServerIP:(NSString *)serverIP serverPort:(NSInteger)serverPort {
    _serverIP = [serverIP copy];
    if (_serverIP != serverIP) {
        [_serverIP release];
        _serverIP = serverIP;
    }
    _serverPort = serverPort;
}
- (void)sendSocketMsg:(JGSocketMsg *)socketMsg {
    socketMsg.fromId = _contace.ID;
    socketMsg.mm = _contace.mm;
    [_socket sendMsg:[socketMsg socketmsgToStrmsg] ip:self.serverIP port:self.serverPort];
    NSLog(@"sendNew:%@", socketMsg);
}


- (void)startListen {
    [_socket startListenPort:IP_CELIENLISTENPORT];
}

- (void)socket:(JGSocket *)socket receiveNews:(NSString *)msg {
    JGSocketMsg *socketMsg =[[[JGSocketMsg alloc] initWithStrmsg:msg] autorelease];
    NSLog(@"haveNew:%@", socketMsg);
    if ([_contace.mm isEqualToString:socketMsg.mm] || (!_contace && ![socketMsg.mm length])) {
        [[NSNotificationCenter defaultCenter] postNotificationName:sockHaveNewMsg object:socketMsg];
    } else if (socketMsg.tp == MSG_VERF && socketMsg.tped == MSG_LOGI) {
        [[NSNotificationCenter defaultCenter] postNotificationName:sockHaveNewMsg object:socketMsg];        
    } else {
        NSLog(@"该消息属于异常消息(#验证失败)");
    }
    
}

- (JGDBController *)db {
    if (!_db) {
        _db = [[JGDBController DBControllerWithName:@"eTalk.sqlite" WithID:[JGSocketManager shared].contace.ID] retain];
    }
    return _db;
}

- (void)socket:(JGSocket *)socket sendMsgError:(JGSocketErrorType)errorType {
    
}

@end
