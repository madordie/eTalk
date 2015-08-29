//
//  JGChat.h
//  eTalk-4.0
//
//  Created by Keith on 14-6-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JGChat : NSObject <NSCoding>
{
    NSString *_msg;
    BOOL _isMine;
    NSString *_msgTime;
}
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, copy) NSString *msgTime;
@property (nonatomic, assign) CGSize size;
- (JGChat *)initWithMsg:(NSString *)msg isMine:(BOOL)isMine msgTime:(NSString *)msgTime;
+ (JGChat *)chatWithMsg:(NSString *)msg isMine:(BOOL)isMine msgTime:(NSString *)msgTime;
@end
