//
//  JGSocketDelegate.h
//  eTalk-4.1
//
//  Created by madordie on 14-8-19.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JGSocket;

typedef enum {
    JGSocketErrorTypeCreat,
    JGSocketErrorTypeBind,
    JGSocketErrorTypeConnect,
    JGSocketErrorTypeSend,
    JGSocketErrorTypeListen,
    JGSocketErrorTypeAccpet,
    JGSocketErrorTypeRecv,
    
} JGSocketErrorType;

#define JGSocketError(type)\
    if ([_delegate respondsToSelector:@selector(socket:sendMsgError:)]) { \
        dispatch_async(dispatch_get_main_queue(), ^{\
            [_delegate socket:self sendMsgError:type];\
        });\
        return ;\
    }

@protocol JGSocketDelegate <NSObject>

@optional
- (void)socket:(JGSocket *)socket receiveNews:(NSString *)msg;
- (void)socket:(JGSocket *)socket sendMsgError:(JGSocketErrorType)errorType;

@end
