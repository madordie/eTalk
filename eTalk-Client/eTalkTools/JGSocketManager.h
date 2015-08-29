//
//  JGSocketManager.h
//  eTalk-4.1
//
//  Created by madordie on 14-8-19.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSocketDelegate.h"
#import "JGSocketMsg.h"
#import "JGContace.h"
#import "JGDBController.h"

@interface JGSocketManager : NSObject <JGSocketDelegate>
@property (nonatomic, retain) JGSocket *socket;
@property (nonatomic, retain) JGContace *contace;
@property (nonatomic, retain) JGDBController *db;


@property (nonatomic, copy, readonly) NSString *serverIP;
@property (nonatomic, assign, readonly) NSInteger serverPort;

+ (JGSocketManager *)shared;
//设置服务器的地址和端口都则无法调用send方法
- (void)setServerIP:(NSString *)serverIP serverPort:(NSInteger)serverPort;

- (void)sendSocketMsg:(JGSocketMsg *)socketMsg;

- (void)startListen;

@end

#define kStateKeyForIP      @"stateIP"
#define kStateKeyForPORT    @"statePORT"