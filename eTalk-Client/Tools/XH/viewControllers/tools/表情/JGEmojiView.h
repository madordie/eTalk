//
//  JGEmojiView.h
//  SkinRun
//
//  Created by sl on 14-12-25.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGEmojiView : UIView

@property (strong, nonatomic) NSArray *allEmoji;

+ (instancetype)emojiViewWithSelectedEmoji:(void(^)(NSString *emoji, JGEmojiView *view)) selectedEmojiBlock
                        deleteButtonAction:(void(^)(UIButton *deleteButton, JGEmojiView *view)) deleteButtonBlock
                                     frame:(CGRect)frame;

@end
