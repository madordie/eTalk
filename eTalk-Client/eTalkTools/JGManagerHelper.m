//
//  JGManagerHelper.m
//  eTalk
//
//  Created by sl on 15/3/25.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGManagerHelper.h"
#import "JGContace.h"
#import "JGControl.h"
#import "JGSocketMsg.h"
#import "JFQuick.h"
#import "JGSharedInfo.h"
#import "JFLeanChatMessage.h"
#import "JGSocketManager.h"

@implementation JGManagerHelper
+ (void)autoReset {
    [[JGSocketManager shared] startListen];
}
+ (void)logout {
    [[JGSocketManager shared] sendSocketMsg:[JGSocketMsg msgWithTo:nil tp:MSG_VERF tped:MSG_LOGO tpbl:MSG_BLYES msg:nil]];
}

+ (void)autoSetIPPort {
    NSString *ip, *port;
    [JGSharedInfo readIP:&ip port:&port];
    if (ip.length > 0 && port > 0) {
        [[JGSocketManager shared] setServerIP:ip serverPort:[port integerValue]];
    }
}
+ (void)haveMsgTo:(id)tager action:(SEL)action {
    [[NSNotificationCenter defaultCenter] addObserver:tager selector:action name:sockHaveNewMsg object:nil];
}
+ (void)haveMsgclear:(id)tager {
    [[NSNotificationCenter defaultCenter] removeObserver:tager];
}

+ (void)testServerIP:(NSString *)ip port:(NSString *)port {
    JGSocketManager *socketManager = [JGSocketManager shared];
    [socketManager setServerIP:ip serverPort:[port integerValue]];
    [socketManager sendSocketMsg:[JGSocketMsg msgWithTo:nil tp:MSG_VERF tped:MSG_TEST tpbl:MSG_BLNO msg:@"this is a test to server from a clien"]];
    
    [JGSharedInfo writerIP:ip port:port];
}
+ (void)testMsg:(NSNotification *)sockmsg callBack:(msgCallBack)msgCallBack {
    JGSocketMsg *msg = sockmsg.object;
    if (msg.tp == MSG_VERF && msg.tped == MSG_TEST && msg.tpbl == MSG_BLYES) {
        JGTryCarryOutVA_ARGS(msgCallBack, msg, nil);
    }
}
+ (void)loginUsername:(NSString *)username password:(NSString *)password {
    [[JGSocketManager shared] sendSocketMsg:[JGSocketMsg msgWithTo:nil tp:MSG_VERF tped:MSG_LOGI tpbl:MSG_BLYES msg:[JGSocketMsg msgMake:username two:[JGControl base64ToSocket:password]]]];
}
+ (void)loginMsg:(NSNotification *)sockmsg callBack:(msgCallBack)msgCallback {
    JGSocketManager *socketManager = [JGSocketManager shared];
    JGSocketMsg *msg = sockmsg.object;
    if (socketManager.contace == nil && msg.tp == MSG_VERF) {
        
        if (msg.tped == MSG_LOGI && msg.tpbl == MSG_BLYES) {
            NSArray *array = [JGSocketMsg msgCat:msg.msg];
            if (array.count <3) {
                JGTryCarryOutVA_ARGS(msgCallback, msg, [NSError errorWithTag:JGSocketErrorMessage]);
                return;
            }
            socketManager.contace = [JGContace contaceWithName:array[1] ID:array[0]];
            [socketManager.contace setName:[JGControl base64FromSocket:socketManager.contace.name]];
            [socketManager.contace setHeadImage:array[2]];
            [socketManager.contace setMm:msg.mm];
            JGTryCarryOutVA_ARGS(msgCallback, msg, nil);
            
            [self updateForList];
        } else if (msg.tped == MSG_LOGI) {
            JGTryCarryOutVA_ARGS(msgCallback, msg, [NSError errorWithTag:JGSocketErrorRequtst]);
        }
        
    }
}
+ (void)registerUsername:(NSString *)username password:(NSString *)password header:(NSString *)header {    
    NSString *bname = [JGControl base64ToSocket:username];
    NSString *bpw = [JGControl base64ToSocket:password];
    bpw = [JGSocketMsg msgMake:bpw two:header];    //头像添加
    [[JGSocketManager shared] sendSocketMsg:[JGSocketMsg msgWithTo:nil tp:MSG_VERF tped:MSG_REGIST tpbl:MSG_BLYES msg:[JGSocketMsg msgMake:bname two:bpw]]];
}
+ (void)registerMsg:(NSNotification *)sockmsg callBack:(msgCallBack)msgCallback {
    JGSocketMsg *msg = sockmsg.object;
    if (msg.tp == MSG_VERF && msg.tped == MSG_REGIST) {
        if (msg.tpbl == MSG_BLYES) {
            JGTryCarryOutVA_ARGS(msgCallback, msg, nil);
        } else {
            
        }
    }
}
+ (void)updateForList {
    [[JGSocketManager shared] sendSocketMsg:[JGSocketMsg msgWithTo:nil tp:MSG_LTIM tped:MSG_VERF tpbl:MSG_NONE msg:@"this is reload time"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[JGSocketManager shared] sendSocketMsg:[JGSocketMsg msgWithTo:nil tp:MSG_VERF tped:MSG_UNREAD tpbl:MSG_BLYES msg:nil]];        
    });
}
+ (void)updateMsg:(NSNotification *)sockmsg callBack:(msgCallBack)msgCallBack {
    JGSocketMsg *msg = sockmsg.object;
    
    //联系人列表更新
    if (msg.tp == MSG_LIST) {
        if (msg.tpbl == MSG_BLYES) {
            //列表更新信息
            NSArray *array = [JGSocketMsg msgCat:msg.msg];
            if (array.count < 2) {
                NSLog(@"消息列表消息解析失败(%@)",NSStringFromSelector(_cmd));
                JGExBlock(msgCallBack, msg, [NSError errorWithTag:JGSocketErrorMessage]);
                return;
            }
            JGContace *contace = [JGContace contaceWithName:[JGControl base64FromSocket:array[1]] ID:array[0]];
            contace.headImage = array[2];
            [self contaceSaveDB:contace];
            
            JGExBlock(msgCallBack, msg, nil);
        } else {
            NSLog(@"列表更新失败");
            JGExBlock(msgCallBack, msg, [NSError errorWithTag:JGSocketErrorMessage]);
        }
    }
}
+ (void)updateContaceMsg:(NSNotification *)sockmsg callBack:(msgRespondCallBack)msgCallBack {
    JGSocketMsg *msg = sockmsg.object;
    //未读消息
    if (msg.tp == MSG_NEWS || msg.tp == MSG_UNREAD) {
        
        if (msg.tp == MSG_UNREAD) {
            NSArray *array = [JGSocketMsg msgCat:msg.msg];
            if (array.count < 2) {
                NSLog(@"未读消息解析失败");
                return;
            }
            msg.fromId = array[0];
            msg.msg = array[1];
        }
        msg.msg = [JGControl base64FromSocket:msg.msg];
        NSLog(@"%@", msg.msg);
        NSDictionary *info = JGJsonForNSString(msg.msg);
        JFLeanChatMessage *message = [JFLeanChatMessage messageWithSender:msg.fromId
                                                                     name:info[@"name"]
                                                              headerImage:info[@"header"]
                                                                  message:info[@"message"]];
        message.time = @([info[@"time"] doubleValue]);
        JGExBlock(msgCallBack, msg, message, nil);
    }
}

+ (void)messageSend:(NSString *)message toContaceID:(NSString *)ID {
    JGContace *sender = [JGSocketManager shared].contace;
    NSString *sfm = [@([[NSDate date] timeIntervalSince1970]) stringValue];
    NSString *str = JGJsonToNSString(@{@"name":sender.name,
                                       @"header":sender.headImage,
                                       @"message":message,
                                       @"time":sfm});
    
    JGSocketMsg *socketMsg = [JGSocketMsg msgWithTo:ID tp:MSG_NEWS tped:MSG_NONE tpbl:MSG_NONE msg:[JGControl base64ToSocket:str]];
    [[JGSocketManager shared] sendSocketMsg:socketMsg];
}
+ (void)updateForAutoLogoutMsg:(NSNotification *)sockmsg callBack:(msgCallBack)msgCallBack {
    JGSocketMsg *msg = sockmsg.object;
    if (msg.tp == MSG_LOGO) {
        if (msg.tpbl == MSG_BLYES) {
            //            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forceQuit) object:nil];
            [WCAlertView showAlertWithTitle:@"" message:@"您已经退出" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                JGExBlock(msgCallBack, msg, nil);
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [JGSocketManager shared].contace = nil;
            NSLog(@"这货已经成功退出");
        } else if (msg.tpbl == MSG_BLCOM) {
            [WCAlertView showAlertWithTitle:@"" message:@"您的帐号在别处登录，您已被迫下线" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                JGExBlock(msgCallBack, msg, nil);
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
        } else {
            NSLog(@"退出失败");
        }
    } else if ( msg.tp == MSG_BLCOM) {
        //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forceQuit) object:nil];
        [WCAlertView showAlertWithTitle:@"" message:@"您的帐号在别处登录，您已被迫下线" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            JGExBlock(msgCallBack, msg, nil);
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [JGSocketManager shared].contace = nil;
    }
}
+ (void)searchContace:(NSString *)contace {
    JGSocketMsg *msg;
    if ([contace length]) {
        msg = [JGSocketMsg msgWithTo:nil tp:MSG_LIST tped:MSG_NONE tpbl:MSG_BLYES msg:contace];
    } else {
        msg = [JGSocketMsg msgWithTo:nil tp:MSG_LIST tped:MSG_NONE tpbl:MSG_BLYES msg:nil];
    }
    [[JGSocketManager shared] sendSocketMsg:msg];
}
+ (void)searchContaceMsg:(NSNotification *)sockmsg callBack:(msgRespondCallBack)msgCallBack {
    JGSocketMsg *msg = sockmsg.object;
    if (msg.tp == MSG_CTINFO) {
        if (msg.tpbl == MSG_BLYES) {
            NSArray *array = [JGSocketMsg msgCat:msg.msg];
            if (array.count<2) {
                NSLog(@" *** 联系人信息部分不完整");
                JGExBlock(msgCallBack, msg, nil, [NSError errorWithTag:JGSocketErrorMessage]);
                return;
            }
            JGContace *contace = [JGContace contaceWithName:array[1] ID:array[0]];
            contace.headImage = array[2];
            [contace setName:[JGControl base64FromSocket:contace.name]];
            JGExBlock(msgCallBack, msg, contace, nil);
//            [_tableViewData addObject:contace];
//            [_tableView reloadData];
        } else {
            NSLog(@"联系人信息请求失败");
            JGExBlock(msgCallBack, msg, nil, [NSError errorWithTag:JGSocketErrorRequtst]);
        }
    }

}
+ (void)searchAddContace:(JGContace *)contace {
    JGSocketMsg *msg = [JGSocketMsg msgWithTo:nil tp:MSG_ADDCT tped:MSG_NONE tpbl:MSG_BLYES msg:contace.ID];
    [[JGSocketManager shared] sendSocketMsg:msg];
}
+ (void)searchAddContaceMsg:(NSNotification *)sockmsg callBack:(msgRespondCallBack)msgCallBack {
    JGSocketMsg *msg = sockmsg.object;
    if (msg.tp == MSG_ADDCT) {
        if (msg.tpbl == MSG_BLYES) {
            NSArray *array = [JGSocketMsg msgCat:msg.msg];
            if (array.count<2) {
                NSLog(@" *** 联系人信息部分不完整");
                return;
            }
            JGContace *contace = [JGContace contaceWithName:array[1] ID:array[0]];
            [contace setName:[JGControl base64FromSocket:contace.name]];
            NSString *sql =[JGContace sqlAddContace:contace WithID:[JGSocketManager shared].contace.ID];
            [[JGSocketManager shared].db dbExecWithSql:sql];
            JGExBlock(msgCallBack, msg, contace, nil);
        } else {
            NSLog(@"联系人添加失败");
            JGExBlock(msgCallBack, nil, nil, [NSError errorWithTag:JGSocketErrorRequtst]);
        }
    }
}
+ (void)contaceSaveDB:(JGContace *)contace {
    
    NSString *sqlDel = [JGContace sqlDelContace:contace WithID:[JGSocketManager shared].contace.ID];
    [[JGSocketManager shared].db dbExecWithSql:sqlDel];
    
    NSString *sql = [JGContace sqlAddContace:contace WithID:[[JGSocketManager shared] contace].ID];
    [[JGSocketManager shared].db dbExecWithSql:sql];
}
+ (void)contaceLoadFromDB:(void(^)(NSArray *contaces))callBack {
    NSString *sql = [JGContace sqlSelRecentAllContaceWithID:[JGSocketManager shared].contace.ID];
    [[JGSocketManager shared].db dbGetWithSql:sql action:^(int col, int row, char ** datas) {
        int len = (row+1)*col;
        NSMutableArray *array = [NSMutableArray array];
        for (int i=col; i<len; i+=col) {
            NSString *ID = [NSString stringWithUTF8String:datas[i]];
            NSString *name = [NSString stringWithUTF8String:datas[i+1]];
            JGContace *contace = [[JGContace alloc] initWithName:name ID:ID];
            contace.unreadNum = *datas[i+2];
            NSLog(@"%s", datas[i+3]);
            contace.headImage = [NSString stringWithUTF8String:datas[i+3]];
            [array addObject:contace];
        }
        JGExBlock(callBack, array);
    }];
}
+ (void)contaceLoadAllFromDB:(void (^)(NSArray *))callBack {
    NSString *sql = [JGContace sqlSelAllContaceWithID:[JGSocketManager shared].contace.ID];
    [[JGSocketManager shared].db dbGetWithSql:sql action:^(int col, int row, char ** datas) {
        int len = (row+1)*col;
        NSMutableArray *array = [NSMutableArray array];
        for (int i=col; i<len; i+=col) {
            NSString *ID = [NSString stringWithUTF8String:datas[i+0]];
            NSString *name = [NSString stringWithUTF8String:datas[i+1]];
            JGContace *contace = [[JGContace alloc] initWithName:name ID:ID];
            contace.headImage = [NSString stringWithUTF8String:datas[i+2]];
            [array addObject:contace];
        }
        JGExBlock(callBack, array);
    }];
}
@end

@implementation NSError (JGSocket)

+ (instancetype)errorWithTag:(JGSocketError)type {
    NSString *domain = nil;
    switch (type) {
        case JGSocketErrorNone:
            domain = @"none";
            break;
        case JGSocketErrorMessage:
            domain = @"消息解析错误";
            break;
        case JGSocketErrorRequtst:
            domain = @"请求失败";
            break;
            
        default:
            break;
    }
    
    return [NSError errorWithDomain:domain code:type userInfo:nil];
}

@end
