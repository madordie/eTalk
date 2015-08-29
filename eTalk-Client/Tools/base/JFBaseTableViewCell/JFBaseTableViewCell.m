//
//  JFBaseTableViewCell.m
//  SkinRun
//
//  Created by sl on 15/1/2.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "JFBaseTableViewCell.h"
#import "JFQuick.h"

@implementation JFBaseTableViewCell
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellForData:(id)data {
    self.height = 0;
    // 子类实现
    self.updateData = data;
}
- (CGFloat)cellHeightForData:(id)data {
    self.height = 0;
    [self updateCellForData:data];
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    return size.height+1;
}

- (CGFloat)cellHeight {
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    return size.height+1+ self.height;
}

#pragma mark - 编辑

- (void)setMenuControl:(BOOL)menuControl {
    _menuControl = menuControl;
    if (_menuControl) {
        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(BaseCellmenuControlLongStart:)];
        [self addGestureRecognizer:longP];
    }
}
- (void)BaseCellmenuControlLongStart:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIView *cell = recognizer.view;
        if (![cell becomeFirstResponder]) {
            NSLog(@"%@不能响应第一事件", cell);
            return;
        }
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:self.menuControlItems];
        [self setMenuTargetRectInView:menu];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder {
    return self.menuControlItems.count>0;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    __block BOOL canResponst = NO;
    [self.menuControlItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIMenuItem *item = obj;
        if (item.action == action) {
            canResponst = YES;
            *stop = YES;
        }
    }];
    return canResponst;
}
- (void)setMenuTargetRectInView:(UIMenuController *)menu {
    [menu setTargetRect:self.bounds inView:self];
}
- (NSMutableArray *)menuControlItems {
    if (!_menuControlItems) {
        _menuControlItems = [NSMutableArray array];
    }
    return _menuControlItems;
}
#pragma mark - - - -
@end

@implementation UILabel (heightForCell)

- (CGFloat)heightForLabel {
    return [self sizeThatFits:CGSizeMake(self.quickWidth, CGFLOAT_MAX)].height;
}


@end
