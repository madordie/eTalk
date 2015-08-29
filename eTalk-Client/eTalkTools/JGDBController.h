//
//  JGDBController.h
//  eTalk-4.0
//
//  Created by Keith on 14-6-19.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGDBController : NSObject

- (JGDBController *)initWithName:(NSString *)dbName WithID:(NSString *)ID;
+ (JGDBController *)DBControllerWithName:(NSString *)dbName WithID:(NSString *)ID;

- (BOOL)dbOpenWithName:(NSString *)dbname;

//add del
- (BOOL)dbExecWithSql:(NSString *)sql;
//action函数参数：列 行 二维数组  《第一行为列名》
typedef void(*tfun)(id, int, int, char **);
- (BOOL)dbGetWithSql:(NSString *)sql action:(void (^)(int ,int , char **))action;
- (void)dbClose;
@end
