//
//  JGIndexPath.m
//  限免
//
//  Created by Mac on 14-9-14.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGIndexPath.h"

@implementation JGIndexPath
+ (JGIndexPath *)indexPathWithLine:(NSInteger)line row:(NSInteger)row {
    JGIndexPath *indexPath = [[JGIndexPath alloc] initWithLine:line row:row];
    return [indexPath autorelease];
}
- (id)initWithLine:(NSInteger)line row:(NSInteger)row {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.line = line;
    self.row = row;
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"<%d, %d>", (int)self.line, (int)self.row];
}
@end
