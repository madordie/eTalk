//
//  JFLeanChatHelper.h
//  SkinRun
//
//  Created by sl on 15/3/25.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JFChatRoomViewController.h"

@interface JFLeanChatHelper : NSObject
+ (void)helperGoChatRoom:(UINavigationController *)navigation toContace:(JGContace *)contace;

+ (void)helperSendMessage:(NSString *)content image:(UIImage *)imag toContace:(JGContace *)contace;
+ (void)helperReadMessageLastTime:(NSTimeInterval)time complete:(void(^)(NSArray *messages))complete;
+ (void)helperListenMessageObserver:(id)target selector:(SEL)selector;
+ (void)helperListenRemoveMessageObserver:(id)target;


@end
