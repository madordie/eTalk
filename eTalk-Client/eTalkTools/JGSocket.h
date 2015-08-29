//
//  JGSockte.h
//  eTalk-4.1
//
//  Created by madordie on 14-8-19.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSocketDelegate.h"

@interface JGSocket : NSObject
@property (nonatomic, assign) BOOL isListing;
@property (nonatomic, assign) id<JGSocketDelegate> delegate;


- (void)stopListen;
- (void)startListenPort:(NSInteger)port;
- (void)sendMsg:(NSString *)msg ip:(NSString *)ip port:(NSInteger)port;

@end
