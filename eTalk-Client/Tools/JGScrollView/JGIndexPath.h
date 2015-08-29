//
//  JGIndexPath.h
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGIndexPath : NSObject
@property (nonatomic, assign) NSInteger line;
@property (nonatomic, assign) NSInteger row;

+ (JGIndexPath *)indexPathWithLine:(NSInteger)line row:(NSInteger)row;
- (id)initWithLine:(NSInteger)line row:(NSInteger)row;

@end
