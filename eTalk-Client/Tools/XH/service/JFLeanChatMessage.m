//
//  JFLeanChatMessage.m
//  eTalk
//
//  Created by sl on 15/4/19.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JFLeanChatMessage.h"

@implementation JFLeanChatMessage
+ (instancetype)messageWithSender:(NSString *)uid name:(NSString *)name headerImage:(NSString *)image message:(NSString *)message {
    JFLeanChatMessage *chat = [[JFLeanChatMessage alloc] init];
    chat.senderName = name;
    chat.senderHeader = image;
    chat.senderMessage = message;
    chat.senderID = uid;
    chat.time = @([[NSDate date] timeIntervalSince1970]);
    return chat;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.senderName = [aDecoder decodeObjectForKey:@"name"];
        self.senderMessage = [aDecoder decodeObjectForKey:@"message"];
        self.senderHeader = [aDecoder decodeObjectForKey:@"header"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
        self.senderID = [aDecoder decodeObjectForKey:@"uid"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.senderHeader forKey:@"header"];
    [aCoder encodeObject:self.senderMessage forKey:@"message"];
    [aCoder encodeObject:self.senderName forKey:@"name"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:self.senderID forKey:@"uid"];
}
- (NSNumber *)time {
    if (!_time) {
        _time = @([[NSDate date] timeIntervalSince1970]);
    }
    return _time;
}
@end
