//
//  JGSmileView.m
//  eTalk-4.1
//
//  Created by madordie on 14-8-25.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import "JGSmileView.h"

@interface JGSmileView () <UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
}
@end

@implementation JGSmileView

+ (JGSmileView *)smileViewWithFrame:(CGRect)frame file:(NSString *)path smileViewDelegate:(id<JGSmileViewDelegate>)smileViewDelegate{
    JGSmileView *sv = [[JGSmileView alloc] initWithFrame:frame];
    [sv setSmileViewDelegate:smileViewDelegate];
    [sv setFilePath:path];
    [sv loadSmile];
    return [sv autorelease];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:_scrollView];
        [_scrollView setDelegate:self];
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 182, 320, 30)];
        [self addSubview:_pageControl];
        [_pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
        [_pageControl setPageIndicatorTintColor:[UIColor darkGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor brownColor]];
        [self setBackgroundColor:[UIColor colorWithRed:248 green:248 blue:248 alpha:1]];
    }
    return self;
}
- (void)dealloc {
    self.filePath = nil;
    [_pageControl release], _pageControl = nil;
    [_scrollView release], _scrollView = nil;
    [super dealloc];
}


- (void)loadSmile {
    NSError *error = nil;
    NSString *smiles;// = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:&error];
    smiles = @"😄😊😃😉😍😘😚😳😌😁😜😝😒😏😓😔😞😖😥😰😨😣😢😭😂😲😱😠😡😪😷👿👽💛💙💜💗💚💔💓💘🌟💢❕❔💤💨💦🎶🎵🔥💩👍👎👌👊👋👐👆👇👉👈🙌🙏👏💪🚶🏃👫💃👯🙆🙅💁🙇💏💑💆💇💅👦👧👩👨👶👵👴👱👲👳👷👮👼👸💂💀👣💋👄👂👀🌙🌀🌊🐱🐶🐭🐹🐰🐺🐸🐯🐨🐻🐷🐮🐗🐵🐒🐴🐎🐫🐑🐘🐍🐦🐤🐔🐧🐛🐙🐠🐟🐳🐬💐🌸🌷🍀🌹🌻🌺🍁🍃🍂🌴🌵🌾🐚🏠🏫🏢🏣🏥🏦🏪🏩🏨💒🏬🌇🌆🏯🏰🏭🗼🗻🌄🌅🌃🗽🌈🎡🎢🚢🚤🚀🚲🚙🚗🚕🚌🚓🚒🚑🚚🚃🚉🚄🚅🎫🚥🚧🔰🏧🎰🚏💈🏁🎌1⃣2⃣3⃣4⃣5⃣6⃣7⃣8⃣9⃣0⃣#⃣🆗🆕🔝🆙🆒🎦🈁📶🎍💝🎎🎒🎓🎏🎆🎇🎐🎑🎃👻🎅🎄🎁🔔🎉🎈💿📀📷🎥💻📺📱📠💽📼🔊📢📣📻📡🔍🔓🔒🔑🔨💡📲📩📫📮🛀🚽💺💰🔱🚬💣🔫💊💉🏈🏀🎾🎱🏊🏄🎿🏆👾🎯🀄🎬📝📖🎨🎤🎧🎺🎷🎸👟👡👠👢👕👔👗👘👙🎀🎩👑👒🌂💼👜💄💍💎🍵🍺🍻🍸";
    if (error) {
        if ([_smileViewDelegate respondsToSelector:@selector(smileView:loadSmileError:)]) {
            [_smileViewDelegate smileView:self loadSmileError:error];
        }
    }
#if 0
    for (int i=0; i<smiles.length; i+=20) {
        for (int j=0; j<10; j++) {
            if (i+j*2>=smiles.length) {
                break;
            }
            UIButton *button =  [self buttonWithSmile:[smiles substringWithRange:NSMakeRange(i+j*2, 2)] origin:CGPointMake(2+30*j, 2+i/20*30)];
            [_scrollView addSubview:button];
        }
    }
#else
    int p=0;
    for (int i=0, j=0; i<6; i++) {
        for (j=0; j<10; j++) {
            if (p*120 + i*20+j*2 +2>=smiles.length) {
                break;
            }
            UIButton *smile = [self buttonWithSmile:
                               [smiles substringWithRange:NSMakeRange(i*20+j*2 + 120*p, 2)]
                                             origin:CGPointMake(2+j*30 + 320*p, 2+i*30)];
            [_scrollView addSubview:smile];
        }
        if (j!=10) {
            break;
        }
        if (i == 5) {
            p++;
            i=-1;
        }
    }
#endif
    [_scrollView setContentSize:CGSizeMake(320 + 320*p, 200)];
//    [self setBackgroundColor:[UIColor orangeColor]];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:YES];
    
    [_scrollView setPagingEnabled:YES];
    [_scrollView setAlwaysBounceVertical:NO];
    [_pageControl setCurrentPage:0];
    [_pageControl setNumberOfPages:p+1];
}

- (void)pageControlValueChange:(UIPageControl *)pc {
    [_scrollView setContentOffset:CGPointMake(320*pc.currentPage, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/320;
}

- (UIButton *)buttonWithSmile:(NSString *)smile origin:(CGPoint)origin {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:smile forState:UIControlStateNormal];
    [button setFrame:CGRectMake(origin.x, origin.y, 40, 40)];
    [button addTarget:self action:@selector(smileHaveSelect:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)smileHaveSelect:(UIButton *)sender {
    if ([_smileViewDelegate respondsToSelector:@selector(smileView:didSelectSmile:)]) {
        [_smileViewDelegate smileView:self didSelectSmile:sender.titleLabel.text];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
