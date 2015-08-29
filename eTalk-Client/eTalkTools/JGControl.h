//
//  JGControl.h
//  eTalk-4.1
//
//  Created by madordie on 14-8-18.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JGControl : NSObject

+ (void)controlMakeLocalNotificationWithFireDate:(NSDate *)fireDate alertBoby:(NSString *)alertBoby localizedString:(NSString *)localizedString userInfo:(NSDictionary *)userInfo repeatInterval:(NSCalendarUnit)repeatInterval;

+ (void)controlCancelNotificationWithUserInfo:(NSDictionary *)userInfo;

+ (UIButton *)controlCreatButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)obj    action:(SEL)select ;

+ (UILabel *)controlCreatLabelWithTitle:(NSString *)title frame:(CGRect)frame;

+ (UIImageView *)controlCreatImageViewWithFrame:(CGRect)frame;

+ (UITextField *)controlCreatTextFieldPlaceholder:(NSString *)placeholder frame:(CGRect)frame delegate:(id<UITextFieldDelegate>)delegate;

+ (CGSize)returnText:(NSString *)string fontSize:(int)fsize weight:(CGFloat)weight;

+ (NSString *)base64FromSocket:(NSString *)string;
+ (NSString *)base64ToSocket:(NSString *)string;

+ (void)controlMakeAlViewTitle:(NSString *)title info:(NSString *)info buttonTitle:(NSString *)btitl;
+ (void)controlMakeAlViewTitle:(NSString *)title info:(NSString *)info buttonTitle:(NSString *)btitl delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;

+ (NSString *)date:(NSDate *)date formatter:(NSString *)dateFormat;

#pragma mark - filePath
+ (NSString *)filePathWithFilename:(NSString *)fineName Type:(NSString *)type ID:(NSString *)ID;

+ (void)saveChatData:(NSString *)msg myID:(NSString *)myID fromID:(NSString *)fromID;

+ (void)archiverArray:(NSMutableArray *)array myID:(NSString *)myID fromID:(NSString *)fromID;

@end
