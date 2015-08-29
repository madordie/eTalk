//
//  JFBaseViewController.h
//  SkinRun
//
//  Created by sl on 14-12-21.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFQuick.h"
#import "JGManagerHelper.h"
#import "JGSharedInfo.h"

@interface JFBaseViewController : UIViewController

    //VC标题
@property (nonatomic, copy) NSString *viewControllerTitle;

+ (instancetype)viewController;

/**
 *  socket have msage.
 *
 *  @param msage msg.
 */
- (void)socketHaveMsg:(NSNotification *)sockmsg;

@end
