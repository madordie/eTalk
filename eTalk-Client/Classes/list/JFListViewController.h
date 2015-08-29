//
//  JFMyTestViewController.h
//  SkinRun
//
//  Created by sl on 15/3/18.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#include "JFBaseViewController.h"

@interface JFListViewController : JFBaseViewController
/**
 *  三个纯属继承用的
 */
@property (nonatomic, strong) NSArray *viewController;
@property (nonatomic, assign) int index;
@property (nonatomic, copy) void(^tabbarChangeVCBlock)(id oldViewController, id newViewController);

#pragma mark - set tools
- (NSArray *)titles;
- (id)subViewControllerClassIndex:(int)index;
@end
