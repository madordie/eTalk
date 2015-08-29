//
//  JFLeanService.m
//  SkinRun
//
//  Created by sl on 15/3/27.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFLeanService.h"
#import "JFLeanDBManager.h"
#import "JGManagerHelper.h"

static JFLeanService *_leanService;
@interface JFLeanService ()
@property BOOL isLoadingMore;
@end
@implementation JFLeanService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _leanService = [[self alloc] init];
        _leanService.isLoadingMore = NO;
    });
    
    return _leanService;
}
+ (void)autoSendeMessage:(JFLeanChatMessage *)model toContace:(JGContace *)contace {
    dispatch_async(dispatch_queue_create("auto push", nil), ^{
        [JFLeanDBManager autoInstallMessage:model];
        //发送消息
        [JGManagerHelper messageSend:model.senderMessage toContaceID:contace.ID];
    });
}
+ (void)autoReadMessageLastTime:(NSTimeInterval)time complete:(void(^)(NSArray *messages))complete {
    if (_leanService.isLoadingMore) {
        JGExBlock(complete, nil);
        return;
    } else {
        _leanService.isLoadingMore = YES;
        [JFLeanDBManager autoReadMessageTime:time compleat:^(NSArray *messages) {
            JGExBlock(complete, messages);
            _leanService.isLoadingMore = NO;
        }];
    }
}
#define JFLeanServiceNotifyMessageUpdate @"JFLeanServiceNotifyMessageUpdate"
+ (void)postMessageNotifyForUpdatemessage {
    [[NSNotificationCenter defaultCenter] postNotificationName:JFLeanServiceNotifyMessageUpdate object:nil];
}
+ (void)addMessageObserver:(id)target selector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:JFLeanServiceNotifyMessageUpdate object:nil];
}

+ (void)removeMessageObserver:(id)target{
    [[NSNotificationCenter defaultCenter] removeObserver:target name:JFLeanServiceNotifyMessageUpdate object:nil];
}
@end
