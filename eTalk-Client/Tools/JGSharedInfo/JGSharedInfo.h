//
//  JGSharedInfo.h
//  eTalk
//
//  Created by sl on 15/3/26.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFQuick.h"

@interface JGSharedInfo : NSObject

@property (nonatomic, getter=serverIP, copy) NSString *ip;
@property (nonatomic, getter=serverPort, copy) NSString *port;

+ (instancetype)shared;

+ (void)writerIP:(NSString *)ip port:(NSString *)port;
+ (void)readIP:(NSString **)ip port:(NSString **)port;

+ (void)writerID:(NSString *)ID password:(NSString *)password;
+ (void)readerID:(NSString **)ID password:(NSString **)password;


@end
