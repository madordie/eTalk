//
//  JGSocketMsg.h
//  eTalk-4.0
//
//  Created by Keith on 14-6-15.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eTalk.h"


typedef enum : NSUInteger {
    JGMsgTypeNone        = MSG_NONE,
    JGMsgTypeVerify      = MSG_VERF,
    JGMsgTypeLogin       = MSG_LOGI,
    JGMsgTypeList        = MSG_LIST,
    JGMsgTypeNews        = MSG_NEWS,
    JGMsgTypeLogout      = MSG_LOGO,
    JGMsgTypeListTime    = MSG_LTIM,
    JGMsgTypeAddContace  = MSG_ADDCT,
    JGMsgTypeUnreadMsg   = MSG_UNREAD,
    JGMsgTypeRegister    = MSG_REGIST,
    JGMsgTypeContaceInfo = MSG_CTINFO,
    JGMsgTypeTestServer  = MSG_TEST,
} JGMsgType;

typedef enum : NSUInteger {
    JGMsgBLTypeNo          = MSG_BLNO,
    JGMsgBLTypeYes         = MSG_BLYES,
    JGMsgBLTypeNoID        = MSG_BLNOID,
    JGMsgBLTypForcedLogout = MSG_BLCOM,
} JGMsgBLType;

@interface JGSocketMsg : NSObject
{
    NSString *mm;
    NSString *fromId;   //***是不是这两个属性没有作用哇 。。。。 ***
    NSString *toId;
    JGMsgType tp;
    JGMsgType tped;
    JGMsgBLType tpbl;
    NSString *msg;
}
@property (nonatomic, copy) NSString *mm;
@property (nonatomic, copy) NSString *fromId;
@property (nonatomic, copy) NSString *toId;
@property (nonatomic, assign) JGMsgType tp;
@property (nonatomic, assign) JGMsgType tped;
@property (nonatomic, assign) JGMsgBLType tpbl;
@property (nonatomic, copy) NSString *msg;

- (JGSocketMsg *)initWithStrmsg:(NSString *)strmsg;
- (JGSocketMsg *)msgWithStrmsg:(NSString *)strmsg;

- (JGSocketMsg *)initWithMM:(NSString *)mm from:(NSString *)from to:(NSString *)to tp:(char)tp tped:(char)tped tpbl:(char)tpbl msg:(NSString *)msg;
+ (JGSocketMsg *)msgWithMM:(NSString *)mm from:(NSString *)from to:(NSString *)to tp:(char)tp tped:(char)tped tpbl:(char)tpbl msg:(NSString *)msg;

+ (JGSocketMsg *)msgWithTo:(NSString *)to tp:(char)tp tped:(char)tped tpbl:(char)tpbl msg:(NSString *)msg;

- (NSString *)socketmsgToStrmsg;
+ (NSString *)msgMake:(NSString *)one two:(NSString *)two;
+ (NSArray *)msgCat:(NSString *)msg;

@end
