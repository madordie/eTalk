//
//  JFLeanChatHelper.m
//  SkinRun
//
//  Created by sl on 15/3/25.
//  Copyright (c) 2015 All rights reserved.
//

#import "JFLeanChatHelper.h"
#import "JFQuick.h"
#import "JFLeanService.h"
#import "JFChatRoomViewController.h"
#import "JGContace.h"
#import "JFLeanDBManager.h"

static JFLeanChatHelper *_helper;
@interface JFLeanChatHelper ()

@end
@implementation JFLeanChatHelper
+ (instancetype)helper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[self alloc] init];
    });
    return _helper;
}
+ (void)helperGoChatRoom:(UINavigationController *)navigation toContace:(JGContace *)contace {
    [JFLeanDBManager autoInitWithUserID:[NSString stringWithFormat:@"%@-%@", [JGSocketManager shared].contace.ID, contace.ID] callBack:^{
        JFChatRoomViewController *rootVC = [[JFChatRoomViewController alloc] init];
        [rootVC setToContace:contace];
        [navigation pushViewController:rootVC animated:YES];
    }];
    
}
+ (void)helperReadMessageLastTime:(NSTimeInterval)time complete:(void(^)(NSArray *messages))complete {
    [JFLeanService autoReadMessageLastTime:time complete:complete];
}
+ (void)helperSendMessage:(NSString *)content image:(UIImage *)imag toContace:(JGContace *)contace {
    
    JGContace *user = [JGSocketManager shared].contace;
    
    JFLeanChatMessageType type = JFLeanChatMessageTypeText;
    if (imag) {
        type = JFLeanChatMessageTypeImage;
//        content = [[NSString alloc] initWithData: encoding:NSUTF8StringEncoding];
        content = [UIImageJPEGRepresentation(imag, 0.5) base64EncodedStringWithOptions:0];
    }
    
    JFLeanChatMessage *model = [JFLeanChatMessage messageWithSender:user.ID name:user.name headerImage:user.headImage message:content];
    model.type = type;
    [model time];
    [JFLeanService autoSendeMessage:model toContace:contace];
}
+ (void)helperListenMessageObserver:(id)target selector:(SEL)selector {
    [JFLeanService addMessageObserver:target selector:selector];
}
+ (void)helperListenRemoveMessageObserver:(id)target {
    [JFLeanService removeMessageObserver:target];
}

@end
