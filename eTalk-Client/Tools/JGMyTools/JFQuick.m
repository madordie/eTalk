//
//  JFQuick.m
//  SkinRun
//
//  Created by sl on 14-12-25.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFQuick.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#include <stdarg.h>
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "UIColor+HexColor.h"

@implementation JFQuick
+ (UIImage *)imageBase64FromString:(NSString *)string {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}
+ (NSString *)imageBase64FromImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *imageString = [data base64EncodedStringWithOptions:0];
    return imageString;
}
+ (UIImage *)imageFromeView:(UIView *)view rect:(CGRect)rect {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (rect.origin.x == 0 && rect.origin.x == 0
        && rect.size.width == view.bounds.size.width
        && rect.size.height == view.bounds.size.height) {
        return image;
    }
    UIImage *resultImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, rect)];
    
    return resultImg;
}
+ (UIImage *)imageFromeLayer:(CALayer *)layer rect:(CGRect)rect {
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (rect.origin.x == 0 && rect.origin.x == 0
        && rect.size.width == layer.bounds.size.width
        && rect.size.height == layer.bounds.size.height) {
        return image;
    }
    UIImage *resultImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, rect)];
    
    return resultImg;
}

+ (NSString *)devUUIDMD5String {
    return [JFQuick MD5:[UIDevice currentDevice].identifierForVendor.UUIDString];
}
+ (NSString *)MD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)localTimeFromeDate:(NSString *)date {
    NSDateFormatter *formatter = [NSDateFormatter defaultDateFormatter];
    NSDate *localDate = [formatter dateFromString:date];
    return [localDate JFLocalTimer];
}
+ (NSString *)localTimeTodayWithDateFormat:(NSString *)dateFormat {
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:today];
}
+ (NSString *)localDate:(NSDate *)date DateFormat:(NSString *)dateFormat {
    NSDate *today = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:today];
}
+ (NSString *)locatTimeFromDate:(NSString *)date dateFormat:(NSString *)fromFormat toDateFormat:(NSString *)dateFormat {
    NSDate *locatDate = [NSDate dateFormatter:fromFormat date:date];
    return [self localDate:locatDate DateFormat:dateFormat];
}
+ (void)alerViewWithDelegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title msg:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alert show];
}

+ (UILabel *)labelWithTitleText:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    label.text = title;
    label.textColor = [UIColor colorWithHexString:@"#737373"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:19];
    [label setAdjustsFontSizeToFitWidth:YES];
    return label;
}
+ (UIBarButtonItem *)barButtonItemWithTarget:(id)taget action:(SEL)action size:(CGSize)size title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleForNormal:title];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor colorWithHexString:@"#737373"] forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, size.width, size.height)];
    [button addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}
+ (UIButton *)buttonWithTarget:(id)taget action:(SEL)action frame:(CGRect)frame title:(NSString *)title {
    return [JFQuick baseButtonWithTitle:title image:nil selImage:nil bgImage:nil target:taget action:action frame:frame];
}
+ (UIButton *)buttonWithTarget:(id)taget action:(SEL)action frame:(CGRect)frame title:(NSString *)title bgImage:(NSString *)image {
    return [JFQuick baseButtonWithTitle:title image:nil selImage:nil bgImage:image target:taget action:action frame:frame];
}
+ (UIButton *)buttonWithTarget:(id)taget action:(SEL)action frame:(CGRect)frame image:(NSString *)image selImage:(NSString *)selImage {
    return [JFQuick baseButtonWithTitle:nil image:image selImage:selImage bgImage:nil target:taget action:action frame:frame];
}

+ (UITextField *)textFieldWithDelegate:(id<UITextFieldDelegate>)delegate frame:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle text:(NSString *)text placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField setDelegate:delegate];
    [textField setBorderStyle:borderStyle];
    [textField setText:text];
    [textField setPlaceholder:placeholder];
    return textField;
}
+ (void)layerBorderForLayer:(CALayer *)layer borderWidth:(CGFloat)width {
    layer.masksToBounds = YES;
    //    layer.cornerRadius = 2.0f;
    layer.borderColor = [[UIColor colorWithWhite:0.875 alpha:1.000] CGColor];
    layer.borderWidth = width;
}
+ (void)layerBorderForLayer:(CALayer *)layer {
    [self layerBorderForLayer:layer borderWidth:1.5f];
}

+ (void)changeContaceForUITextField:(UITextField *)textField {
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)]];
}
+ (void)layerMasksToBoundsForView:(UIView *)view {
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:8];
}
+ (void)layerMasksToCircleForView:(UIView *)view {
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:view.quickWidth/2];
}

#pragma mark - 底部提示框
+ (void)showHintError:(NSError *)error {
    [JFQuick showHint:[NSString stringWithFormat:@"%@", error.domain]];
}
+ (void)showHint:(NSString *)hint {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor colorWithWhite:0.573 alpha:0.970];
    [hud hide:YES afterDelay:1];
}
+ (void)showHintForCenter:(NSString *)hint frame:(CGRect)frame {
    [self showHintForCenter:hint frame:frame afterDelay:1];
}

+ (void)showHintForCenter:(NSString *)hint frame:(CGRect)frame afterDelay:(NSTimeInterval)delay {
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 10.f;
    [hud setCenter:view.center];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = hint;
    label.numberOfLines = 0;
    [hud setCustomView:label];

}

+ (void)creatLayerForCoverView:(UIView *)coverView {
    
    UIScrollView *backgroundView = [[UIScrollView alloc] initWithFrame:JFQuickDeviceBounds];
    [backgroundView addSubview:coverView];
    [backgroundView setContentSize:coverView.bounds.size];
    [backgroundView setBounces:NO];
    //把该View添加到对应层
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [view addSubview:coverView];
}
+ (UIView *)changeWidthForDevice:(UIView *)view {
    CGRect frame = view.frame;
    frame.size.width = JFQuickDeviceBounds.size.width;
    view.frame = frame;
    return view;
}
+ (void)changeFrameForView:(UIView *)view type:(JGChangeFrameType)type forFloat:(CGFloat)change {
    CGRect frame = view.frame;
    switch (type) {
        case JGChangeFrameTypeX:
            frame.origin.x = change;
            break;
            
        case JGChangeFrameTypeY:
            frame.origin.y = change;
            break;
            
        case JGChangeFrameTypeWidth:
            frame.size.width = change;
            break;
            
        case JGChangeFrameTypeHeight:
            frame.size.height = change;
            break;
            
        default:
            break;
    }
    
    view.frame = frame;
}
+ (MBProgressHUD *)creatLoadingView {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (NSString *)appVersionString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleShortVersionString"];
}
+ (BOOL)deviceInstallAppURL:(JGAppURLType)url {
    BOOL install =  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
    return install;
}

+ (NSDateComponents *)distanceDateFrome:(NSDate *)frome to:(NSDate *)to {
    
    if (!frome || !to) {
        return nil;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [components setMonth:12];
//    [components setYear:3999];
//    [components setDay:30];
//    [components setHour:JFPm9StartHour];
//    [components setMinute:JFPm9StartMient];
//    [components setSecond:0];
    NSDate *fireDate =to; //[calendar dateFromComponents:components];//目标时间
    NSDate *today = frome;// [NSDate date];//当前时间
    
    NSCalendarUnit unitFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:fireDate options:0];//计算时间差
    return d;
}
+ (void)keyWindowEndEditing {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
+(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

+(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

+(void)runAfterSecs:(float)secs block:(void (^)())block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}
#pragma mark - base
+ (UIButton *)baseButtonWithTitle:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage bgImage:(NSString *)bgImage target:(id)taget action:(SEL)action frame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    return button;
}
+ (CGSize)returnText:(NSString *)string fontSize:(int)fsize weight:(CGFloat)weight {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fsize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(weight, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size;
}
NSDictionary *_JGMyDictionaryOfVariableBindings(NSString *listKey, ... )
{
    listKey = [[listKey componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\t"]] componentsJoinedByString:@""];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    id obj;
    va_list marker;
    
    va_start( marker, listKey ); /* Initialize variable arguments. */
    NSArray *array = [listKey componentsSeparatedByString:@","];
    for (NSString *key in array) {
        obj = va_arg( marker, id);
        obj = obj?obj:@"";
        [dictionary setObject:obj forKey:key];
    }
    
    va_end( marker ); /* Reset variable arguments. */
    
    return dictionary;
    
}

NSDictionary *JGJsonForNSString(NSString *string) {
    NSDictionary *dict = nil;
    if ([string isKindOfClass:[NSString class]]) {
        NSError *error = nil;
        dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableContainers
                                                 error:&error];
        if (error) {
            NSLog(@"\n\t*** NSString -> JSON \nerror:%@", error);
        }
    } else {
        NSLog(@"\n\t*** NSString -> JSON \nerror:No NSString");
    }
    return dict;
}
NSString *JGJsonToNSString(NSDictionary *dictionary) {
    NSString *string = nil;
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"\n\t*** Json -> NSString \nerror:%@", error);
            return nil;
        }
        
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"\n\t*** Json -> NSString \nerror:No NSString");
    }
    return string;
}


@end
