//
//  JGEmojiView.m
//  SkinRun
//
//  Created by sl on 14-12-25.
//  Copyright (c) 2014年 上海商路网络科技有限公司. All rights reserved.
//

#import "JGEmojiView.h"
#import "Emoji.h"
#import "JFQuick.h"
#import "JGEmojiStandardize.h"

@interface JGEmojiView () <UIScrollViewDelegate>
{
    UIScrollView *_emojiView;
    UIPageControl *_pageControl;
}

@property (nonatomic, copy) void(^selectedEmojiBlock)(NSString *, JGEmojiView *);
@property (nonatomic, copy) void(^deleteBlock)(UIButton *, JGEmojiView *);

@end
@implementation JGEmojiView

+ (instancetype)emojiViewWithSelectedEmoji:(void (^)(NSString *, JGEmojiView *))selectedEmojiBlock
                        deleteButtonAction:(void (^)(UIButton *, JGEmojiView *))deleteButtonBlock
                                     frame:(CGRect)frame {
    JGEmojiView *view =  [[self alloc] initWithFrame:frame];
    view.selectedEmojiBlock = selectedEmojiBlock;
    view.deleteBlock = deleteButtonBlock;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatData];
        CGRect frame = self.bounds;
        frame.size.height -= 30;
        [_emojiView setFrame:frame];
        [self creatUI];
        
    }
    return self;
}
- (void)creatData {
    _emojiView = [[UIScrollView alloc] init];
    [_emojiView setDelegate:self];
    [_emojiView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_emojiView];
//    [_emojiView setBackgroundColor:[UIColor blueColor]];
}
- (void)creatUI {
    NSArray *emojis = [JGEmojiStandardize emojiList];
    _allEmoji = emojis;
    NSInteger emojisCount = emojis.count;
        //每行、组 个数
    int rows = 7, sections = 3, pages = rows*sections-1;
        //当前 第 行、组、页
    int row = 0, section = 0, page = 0;
    
    CGFloat wide = _emojiView.frame.size.width/rows;
    CGFloat height = _emojiView.frame.size.height/sections;
    CGFloat rowX=wide/2, sectionY=height/2;
    
    BOOL stop = NO;
    NSInteger index = 0;
    UIButton *emoji = nil;
    for (; 1; page++) {
        sectionY = height/2;
        for (section = 0; section<3; section++) {
            rowX = wide/2 + page*_emojiView.frame.size.width;
            for (row = 0; row<7; row++) {
                index = pages*page + section*sections + row*rows - page;
                if (index > emojisCount) {
                    stop = YES;
                    break;
                }
                    //start layout
                if (section == sections-1 && row == rows-1) {
                        //  删除按钮
                    emoji = [self creatButtonWithTitle:@"" wide:wide*0.8f height:height*0.6f];
                    [emoji setImage:[UIImage imageNamed:@"撤回表情"] forState:UIControlStateNormal];
                    [emoji setTag:999];
                } else {
                        //  表情布局
                    emoji = [self creatButtonWithTitle:emojis[index] wide:wide height:height];
                }
                [emoji setCenter:CGPointMake(rowX, sectionY)];
                [_emojiView addSubview:emoji];
                
                
                rowX += wide;
            }
            if (stop) {
                break;
            }
            sectionY += height;
        }
        if (stop) {
            break;
        }
        rowX += _emojiView.frame.size.width;
    }
    page++;
    [_emojiView setContentSize:CGSizeMake(page*_emojiView.frame.size.width, 0)];
    [_emojiView setPagingEnabled:YES];
    
    _pageControl = [[UIPageControl alloc] init];
    [_pageControl setNumberOfPages:page];
    [_pageControl setFrame:CGRectMake(0, _emojiView.quickY+_emojiView.quickHeight+3, _emojiView.quickWidth, self.quickHeight-_emojiView.quickHeight)];
    [self addSubview:_pageControl];
}

- (UIButton *)creatButtonWithTitle:(NSString *)title wide:(CGFloat)wide height:(CGFloat)height {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, wide, height)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:25]];
    return button;
}
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 999) {
        _deleteBlock?_deleteBlock(button, self):nil;
    } else {
        _selectedEmojiBlock?_selectedEmojiBlock(button.titleLabel.text, self):nil;
    }
}

#pragma mark -  <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/scrollView.quickWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
