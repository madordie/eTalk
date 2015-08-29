//
//  JFQuick.h
//  SkinRun
//
//  Created by sl on 14-12-25.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+quick.h"
#import "UIImageView+quick.h"
#import "UIButton+quick.h"
#import "UIWebView+quick.h"
#import "UITableViewCell+quick.h"
#import "NSDate+quick.h"
#import "MBProgressHUD.h"
#import "UIColor+HexColor.h"
#import "WCAlertView.h"
#import "UIGestureRecognizer+quick.h"


typedef enum : NSUInteger {
    JGChangeFrameTypeWidth  ,
    JGChangeFrameTypeHeight ,
    JGChangeFrameTypeX      ,
    JGChangeFrameTypeY      ,
} JGChangeFrameType;

typedef NSString* JGAppURLType;

typedef void(^JGLabelForSelectBlockType)(NSRange range, NSString *string);

@interface JFQuick : NSObject
+ (UIBarButtonItem *)barButtonItemWithTarget:(id)taget action:(SEL)action size:(CGSize)size title:(NSString *)title;
+ (UIButton *)buttonWithTarget:(id)taget action:(SEL)action frame:(CGRect)frame title:(NSString *)title;
+ (UIButton *)buttonWithTarget:(id)taget action:(SEL)action frame:(CGRect)frame image:(NSString *)image selImage:(NSString *)selImage;
+ (UIButton *)buttonWithTarget:(id)taget action:(SEL)action frame:(CGRect)frame title:(NSString *)title bgImage:(NSString *)image;

+ (UITextField *)textFieldWithDelegate:(id<UITextFieldDelegate>)delegate frame:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle text:(NSString *)text placeholder:(NSString *)placeholder;
/**
     画边缘线
 */
+ (void)layerBorderForLayer:(CALayer *)layer;
+ (void)layerBorderForLayer:(CALayer *)layer borderWidth:(CGFloat)width;
/**
 *  
 */
+ (void)changeContaceForUITextField:(UITextField *)textField;
/**
    切角
 */
+ (void)layerMasksToBoundsForView:(UIView *)view;
/**
    切圆
 */
+ (void)layerMasksToCircleForView:(UIView *)view;

+ (UILabel *)labelWithTitleText:(NSString *)title;


+ (void)alerViewWithDelegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title msg:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

/**
    格式化时间
 */
+ (NSString *)localTimeFromeDate:(NSString *)date;
/**
    当天日期
        {0:yyyy-MM-dd HH:mm:ss.fff}:使用24小时制格式化日期
        {0:yyyy-MM-dd hh:mm:ss.fff}:使用12小时制格式化日期
 */
+ (NSString *)localTimeTodayWithDateFormat:(NSString *)dateFormat;
#define JGDateFormatyyyyMMdd        @"yyyy-MM-dd"
#define JGDateFormatyyyyMMddHHmmss  @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)localDate:(NSDate *)date DateFormat:(NSString *)dateFormat;
#define JGDateForYesterday          [NSDate dateWithTimeIntervalSinceNow:-86400]
#define JGDateForYDay(yDayN)        [NSDate dateWithTimeIntervalSinceNow:-86400*((yDayN)-1)]
/**
    日期格式转换
 */
+ (NSString *)locatTimeFromDate:(NSString *)date dateFormat:(NSString *)fromFormat toDateFormat:(NSString *)dateFormat;
/**
    计算文本所占大小
 */
+ (CGSize)returnText:(NSString *)string fontSize:(int)fsize weight:(CGFloat)weight;


+ (NSString *)devUUIDMD5String;

+ (NSString *)MD5:(NSString *)md5;

#pragma mark - 底部提示框
+ (void)showHint:(NSString *)hint;
+ (void)showHintError:(NSError *)error;
+ (void)showHintForCenter:(NSString *)hint frame:(CGRect)frame;
+ (void)showHintForCenter:(NSString *)hint frame:(CGRect)frame afterDelay:(NSTimeInterval)delay;
#define JGHintFrameDefault  CGRectMake(0,0,200,60)

#pragma mark - 创建覆盖层
/**
    创建覆盖层。删除直接removeFromeSuperView。
 */
+ (void)creatLayerForCoverView:(UIView *)view;
//调整View的宽度
+ (UIView *)changeWidthForDevice:(UIView *)view;

+ (void)changeFrameForView:(UIView *)view type:(JGChangeFrameType)type forFloat:(CGFloat)change;

/**
    app版本
 */
+ (NSString *)appVersionString;

#define JGAppURLForWechat   @"weixin://"
#define JGAppURLForSina     @"weibo://"
#define JGAppURLForTencent  @"mqq://"
+ (BOOL)deviceInstallAppURL:(JGAppURLType)url;

/**
    两个日期的差
 */
+ (NSDateComponents *)distanceDateFrome:(NSDate *)frome to:(NSDate *)to;
/**
 *  收键盘
 */
+ (void)keyWindowEndEditing;
/**
    保存图片
 */
+ (UIImage *)imageFromeView:(UIView *)view rect:(CGRect)rect;
+ (UIImage *)imageFromeLayer:(CALayer *)layer rect:(CGRect)rect;
/**
 *  图片处理
 */
+ (UIImage *)imageBase64FromString:(NSString *)string;
+ (NSString *)imageBase64FromImage:(UIImage *)image;

+(void)runInMainQueue:(void (^)())queue;
+(void)runInGlobalQueue:(void (^)())queue;
+(void)runAfterSecs:(float)secs block:(void (^)())block;
@end

/**
    生成键值对  如果数据为nil则对应Value为 @""
 */
#define JGDictionaryOfVariableBindings(...) _JGMyDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)
NSDictionary *_JGMyDictionaryOfVariableBindings(NSString *listKey, ... );

/**
 *  JSON <-> NSDictionary
 */
NSDictionary *JGJsonForNSString(NSString *string);
NSString *JGJsonToNSString(NSDictionary *dictionary);



#define JFQuickDeviceBounds         ([UIScreen mainScreen].bounds)
#define JFQuickDeviceWindowBounds   ([[UIApplication sharedApplication].delegate window].bounds)
#define JFQuickTabbarHeight         114
#define JFQuickNavHeight            64

#ifndef JGTryCarryOut
#define JGTryCarryOutVA_ARGS(func, ...)  ((func)?(func(__VA_ARGS__)):nil)
#endif
#ifndef JGTryCarryOut
#define JGExBlock(func, ...)  ((func)?(func(__VA_ARGS__)):nil)
#endif

#define JGTryGetString(JString)     ((JString)?(JString):@"")
#define JGTryGetDivisor(JDivisor)   ((JDivisor)!=0?(JDivisor):1)

#define JGWeakSelf __weak __typeof(self)weakSelf = self;
#define JGWeakObjc(JObj) __weak __typeof(JObj)weakObjc = JObj;


#ifndef IS_IPHONE_5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#endif


//便利构造器
#define JGQuickCreatNSArray(name)   @property (nonatomic, strong) NSArray *(name)
#define JGQuickCreatNSDict(name)    @property (nonatomic, strong) NSDictionary *(name)
#define JGQuickCreatNSString(name)  @property (nonatomic, copy) NSString *(name)
#define JGQuickCreatNum(name)       @property (nonatomic, strong)  NSNumber *(name)
#define JGQuickCreatFloat(name)     @property (nonatomic, assign) CGFloat (name)
#define JGQuickStringWithObj(obj)   [NSString stringWithFormat:@"%@", obj]
#define JGQuickStringWithChar(char) [NSString stringWithFormat:@"%c", (int)(char)]
#define JGQuickStringWithInt(intnum)   [NSString stringWithFormat:@"%d", (int)(intnum)]

    //打包和解包
#define JGArchiverFor(archiverObj, fileName) [NSKeyedArchiver archiveRootObject:(archiverObj) \
    toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]\
        stringByAppendingPathComponent:(fileName)]];
#define JGUnarchiverFor(fileName) [NSKeyedUnarchiver unarchiveObjectWithFile: \
    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]\
        stringByAppendingPathComponent:(fileName)]]

    //生成一个定时器在子线程中
#define JGCreatTimerTheadForRunLoop(getTimer, threadName, timerInterval, SELtarget, SEL, UserInfo, Repeats) \
    {   \
        dispatch_queue_t timerThread = dispatch_queue_create(threadName, nil);  \
        dispatch_async(timerThread, ^{  \
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval  \
                                                              target:SELtarget  \
                                                            selector:SEL    \
                                                            userInfo:UserInfo   \
                                                             repeats:Repeats];  \
            getTimer = timer;   \
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];   \
            [[NSRunLoop currentRunLoop] run];   \
        }); \
    }
#define JGClearTimerTheadForRunLoop(JTimer)     \
    [JTimer invalidate];
