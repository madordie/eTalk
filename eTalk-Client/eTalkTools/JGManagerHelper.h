//
//  JGManagerHelper.h
//  eTalk
//
//  Created by sl on 15/3/25.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eTalk.h"
#import "JGSocketMsg.h"
#import "JGControl.h"
#import "JGSocketManager.h"

typedef void(^msgCallBack)(JGSocketMsg *msg, NSError *error);
typedef void(^msgRespondCallBack)(JGSocketMsg *msg, id respondData, NSError *error);
@interface JGManagerHelper : NSObject

/**
 *  auto reset
 */
+ (void)autoReset;
/**
 *  register msg nofition
 *
 *  @param tager
 *  @param action
 */
+ (void)haveMsgTo:(id)tager action:(SEL)action;
+ (void)haveMsgclear:(id)tager;

/**
 *  auto set ip and port.
 */
+ (void)autoSetIPPort;

/**
 *  login
 *
 *  @param username user name.
 *  @param password password.
 */
+ (void)loginUsername:(NSString *)username password:(NSString *)password;
+ (void)loginMsg:(NSNotification *)msg callBack:(msgCallBack)msgCallback;
/**
 *  update for list.
 */
+ (void)updateForList;
+ (void)updateMsg:(NSNotification *)msg callBack:(msgCallBack)msgCallBack;
+ (void)updateContaceMsg:(NSNotification *)msg callBack:(msgRespondCallBack)msgCallBack;
+ (void)updateForAutoLogoutMsg:(NSNotification *)msg callBack:(msgCallBack)msgCallBack;
/**
 *  register user.
 *
 *  @param username user name.
 *  @param password pass word.
 *  @param header   header image name.
 */
+ (void)registerUsername:(NSString *)username password:(NSString *)password header:(NSString *)header;
+ (void)registerMsg:(NSNotification *)msg callBack:(msgCallBack)msgCallback;

/**
 *  test for server.
 *
 *  @param ip   server ip.
 *  @param port server port.
 */
+ (void)testServerIP:(NSString *)ip port:(NSString *)port;
+ (void)testMsg:(NSNotification *)msg callBack:(msgCallBack)msgCallBack;

/**
 *  search contace.
 *
 *  @param contace search contace key.
 */
+ (void)searchContace:(NSString *)contace;
+ (void)searchContaceMsg:(NSNotification *)msg callBack:(msgRespondCallBack)msgCallBack;
+ (void)searchAddContace:(JGContace  *)contace;
+ (void)searchAddContaceMsg:(NSNotification *)msg callBack:(msgRespondCallBack)msgCallBack;

/**
 *  save contace to DB.
 *
 *  @param contace contace.
 */
+ (void)contaceSaveDB:(JGContace *)contace;

/**
 *  load contace from DB
 *
 *  @param callBack callBack.
 */
+ (void)contaceLoadFromDB:(void(^)(NSArray *contaces))callBack;
+ (void)contaceLoadAllFromDB:(void (^)(NSArray *))callBack;

/**
 *  message send and receive.
 */
+ (void)messageSend:(NSString *)message toContaceID:(NSString *)ID;

/**
 *  登出
 */
+ (void)logout;

@end

typedef enum : NSUInteger {
    JGSocketErrorNone = 1,
    JGSocketErrorNoServer,
    JGSocketErrorMessage,
    JGSocketErrorRequtst,
} JGSocketError;

@interface NSError (JGSocket)

+ (instancetype)errorWithTag:(JGSocketError)type;

@end
