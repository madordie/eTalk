//
//  JFLeanChatMessage.h
//  eTalk
//
//  Created by sl on 15/4/19.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JFLeanChatMessageType) {
    JFLeanChatMessageTypeText,
    JFLeanChatMessageTypeImage,
};

@interface JFLeanChatMessage : NSObject<NSCoding>

@property (nonatomic, copy) NSString *senderID;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *senderHeader;
@property (nonatomic, copy) NSString *senderMessage;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, assign) JFLeanChatMessageType type;



+ (instancetype)messageWithSender:(NSString *)uid name:(NSString *)name headerImage:(NSString *)image message:(NSString *)message;


@end
