//
//  JGControl.m
//  eTalk-4.1
//
//  Created by madordie on 14-8-18.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGControl.h"
#import "GTMBase64.h"
#import "JGChat.h"
#import "JGSocketMsg.h"

@implementation JGControl


+ (void)controlMakeLocalNotificationWithFireDate:(NSDate *)fireDate alertBoby:(NSString *)alertBoby localizedString:(NSString *)localizedString userInfo:(NSDictionary *)userInfo repeatInterval:(NSCalendarUnit)repeatInterval {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        notification.fireDate = fireDate;
        notification.repeatInterval = repeatInterval;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = alertBoby;
        notification.alertAction = NSLocalizedString(localizedString, nil);
        notification.hasAction = YES;
        notification.userInfo = userInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [notification release];
    }
}

+ (void)controlCancelNotificationWithUserInfo:(NSDictionary *)userInfo {
    
    NSString *willCancelKey = [[userInfo allKeys] firstObject];
    
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    UILocalNotification *localNoti = nil;
    
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key"];
                if ([inKey isEqualToString:willCancelKey]) {
                    if (localNoti){
                        [localNoti release];
                        localNoti = nil;
                    }
                    localNoti = [noti retain];
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!localNoti) {
            //不存在 初始化
            localNoti = [[UILocalNotification alloc] init];
        }
//        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (localNoti) {
            //不推送 取消推送
            [app cancelLocalNotification:localNoti];
            [localNoti release];
            return;
        }
    }
    
}

+ (UIButton *)controlCreatButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)obj action:(SEL)select {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    [button addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)controlCreatLabelWithTitle:(NSString *)title frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setText:title];
    return [label autorelease];
}
+ (UIImageView *)controlCreatImageViewWithFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    return [imageView autorelease];
}

+ (UITextField *)controlCreatTextFieldPlaceholder:(NSString *)placeholder frame:(CGRect)frame delegate:(id<UITextFieldDelegate>)delegate {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField setPlaceholder:placeholder];
    [textField setBorderStyle:UITextBorderStyleLine];
    [textField setAdjustsFontSizeToFitWidth:YES];
    [textField setDelegate:delegate];
    return [textField autorelease];
}


+ (void)controlMakeAlViewTitle:(NSString *)title info:(NSString *)info buttonTitle:(NSString *)btitl {
    [JGControl controlMakeAlViewTitle:title info:info buttonTitle:btitl delegate:nil tag:0];
}

+ (void)controlMakeAlViewTitle:(NSString *)title info:(NSString *)info buttonTitle:(NSString *)btitl delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag{
    UIAlertView *alv = [[UIAlertView alloc] initWithTitle:title message:info delegate:delegate cancelButtonTitle:btitl otherButtonTitles:nil, nil];
    [alv setTag:tag];
    [alv show];
    [alv release];
}

+ (CGSize)returnText:(NSString *)string fontSize:(int)fsize weight:(CGFloat)weight {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fsize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(weight, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

+ (NSString *)date:(NSDate *)date formatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

#pragma mark - base64 from string to string

+ (NSString *)base64FromSocket:(NSString *)string {
    NSData *data = [GTMBase64 decodeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}
+ (NSString *)base64ToSocket:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    data = [GTMBase64 encodeData:data];
    NSString *end = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [end autorelease];
}
#pragma mark - save chat data
+ (void)saveChatData:(NSString *)msg myID:(NSString *)myID fromID:(NSString *)fromID {
    
    NSString *filename = [JGControl filePathWithFilename:fromID Type:@"Chat.plist" ID:myID];
    
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    
    NSString *strmsg = [JGControl base64FromSocket:msg];
    NSArray *msgs = [JGSocketMsg msgCat:strmsg];
    NSString *strmsginfo = msgs[1];
    NSString *strmsgtime = msgs[0];
    NSLog(@"save:%@", strmsg);
    JGChat *chat = [[JGChat alloc] initWithMsg:strmsginfo isMine:NO msgTime:strmsgtime];
    [array addObject:[chat autorelease]];
    [NSKeyedArchiver archiveRootObject:array toFile:filename];
    NSLog(@"%@", filename);
}
#pragma mark - filePath
+ (NSString *)filePathWithFilename:(NSString *)fineName Type:(NSString *)type ID:(NSString *)ID {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filePath=[plistPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@%@",ID, fineName, type]];
    return filePath;
}


+ (void)archiverArray:(NSMutableArray *)array myID:(NSString *)myID fromID:(NSString *)fromID {
    if (array == nil) {
        return;
    }
    
    //        防止聊天记录过大，所以在切换出talking时候对消息长度进行确认，保证保存文件中的消息长度<100
    
    while ([array count] > 100) {
        [array removeObjectAtIndex:0];
    }
    
    NSString *filename = [JGControl filePathWithFilename:fromID Type:@"Chat.plist" ID:myID];
    [NSKeyedArchiver archiveRootObject:array toFile:filename];

}

@end
