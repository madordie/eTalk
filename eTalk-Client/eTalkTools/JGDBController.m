//
//  JGDBController.m
//  eTalk-4.0
//
//  Created by Keith on 14-6-19.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGDBController.h"
#import <sqlite3.h>
#import "JGContace.h"

@implementation JGDBController
{
    sqlite3 *_db;
}

- (JGDBController *)initWithName:(NSString *)dbName WithID:(NSString *)ID {
    if (self = [super init]) {
        [self dbOpenWithName:dbName];
        [self dbExecWithSql:[JGContace sqlCreatTableStatementWithID:ID]];
        [self dbExecWithSql:[JGContace sqlCreatTableRecentStatementWithID:ID]];
    }
    return self;
}

+ (JGDBController *)DBControllerWithName:(NSString *)dbName WithID:(NSString *)ID {
    return [[[JGDBController alloc] initWithName:dbName WithID:ID] autorelease];
}


#pragma mark - db 操作
- (BOOL)dbOpenWithName:(NSString *)dbname {
    if ([dbname length] == 0) {
        return NO;
    }
    NSString *path = [self dbPathWithUserId:dbname];
    if (sqlite3_open([path UTF8String], &_db)) {
        printf("sqlite3_open error:%s\n", sqlite3_errmsg(_db));
        sqlite3_close(_db);
    }

    return YES;
}

- (NSString *)dbPathWithUserId:(NSString*)userId {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"DB path:%@", libPath);
    return [libPath stringByAppendingPathComponent:[NSString stringWithFormat:@"chat_%@",userId]];
}


    //add del
- (BOOL)dbExecWithSql:(NSString *)sql {
    char *zErrMsg;
	sqlite3_exec(_db , [sql UTF8String] , 0 , 0 , &zErrMsg );
    if (zErrMsg) printf("*** DB ERROR : %s\n\tsql:%s\n", zErrMsg, [sql UTF8String]);
	return YES;
}
    //action函数参数：列 行 二维数组  《第一行为列名》
// ( int, int, char **);
- (BOOL)dbGetWithSql:(NSString *)sql action:(void (^)(int ,int , char **))action {
    int nrow = 0, ncolumn = 0;
    char **azResult; //二维数组存放结果
    char *zErrMsg = 0;

    sqlite3_get_table( _db , [sql UTF8String], &azResult , &nrow , &ncolumn , &zErrMsg );

//    printf( "row:%d column=%d \n" , nrow , ncolumn );
    action( ncolumn, nrow, azResult);
 		//释放掉  azResult 的内存空间
    sqlite3_free_table( azResult );
    return YES;
}

- (void)dbClose {
    sqlite3_close(_db);
}

@end
