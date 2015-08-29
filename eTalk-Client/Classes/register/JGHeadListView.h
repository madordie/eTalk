//
//  JGHeadListView.h
//  eTalk-4.1
//
//  Created by Mac on 14-10-25.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGScrollView.h"

@class JGHeadListView ;

@protocol JGHeadListViewDelegate <NSObject>
@optional
- (void)headListView:(JGHeadListView *)headListView didSelectImageName:(NSString *)imageName;
@end


@interface JGHeadListView : JGScrollView

@property (assign, nonatomic) CGRect oldFrame;

@property (assign, nonatomic) id<JGHeadListViewDelegate> listDelegate;

+ (JGHeadListView *)headListViewWithFrame:(CGRect)frame withDelegate:(id<JGHeadListViewDelegate>)delegate;

@end
