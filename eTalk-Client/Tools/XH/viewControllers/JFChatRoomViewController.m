//
//  CDChatRoomController.m
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "JFChatRoomViewController.h"
#import "UIImage+Resize.h"

#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHContactDetailTableViewController.h"
#import "XHAudioPlayerHelper.h"

#import "JFLeanChatHelper.h"
#import "JFQuick.h"
#import "JGEmojiStandardize.h"
#import "JGEmojiView.h"
#import "JFBaseViewController.h"
#import "JFShowImageViewForChat.h"
#import "JGSocketManager.h"
#import "JFLeanChatMessage.h"
    //修改过
#import "XHMessageTableView.h"
#import "XHMessageTableViewController.h"
#import "XHBaseViewController.h"


#define ONE_PAGE_SIZE 20

typedef void(^JFNSArrayCallback)(NSArray* objects,NSError* error);

@interface JFChatRoomViewController () <UINavigationControllerDelegate>

@property NSMutableArray* leanMessageModels;

@property BOOL isLoadingMsg;

@property (nonatomic, strong) NSArray *emotionManagers;

@end

@implementation JFChatRoomViewController

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
//        self.allowsSendVoice = NO;
//        self.allowsSendFace = NO;
        self.allowsSendMultiMedia = NO;
        _isLoadingMsg=NO;
//        _loadedImages = [[NSMutableDictionary alloc] init];
//        _avatars=[[NSMutableDictionary alloc] init];
//        _defaultAvatar=[UIImage imageNamed:@"default_user_avatar"];
        _leanMessageModels = [NSMutableArray new];
    }
    return self;
}


-(void)initBarButton{
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:nil
                                                              action:nil];
    [[self navigationItem] setBackBarButtonItem:backBtn];
}

-(void)initBottomMenuAndEmotionView{
    
    self.allowsSendMultiMedia = NO;
    
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"晚九点聊天部件图片", @"晚九点聊天部件照相"];
    NSArray *plugTitle = @[@"照片", @"拍摄"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    [self.shareMenuView setBounds:CGRectMake(0, 0, JFQuickDeviceBounds.size.width, 110)];
    
    [self.emotionManagerView setBounds:CGRectMake(0, 0, JFQuickDeviceBounds.size.width, 150)];
    UIView *view = [JGEmojiView emojiViewWithSelectedEmoji:^(NSString *emoji, JGEmojiView *view) {
        self.messageInputView.inputTextView.text = [self.messageInputView.inputTextView.text stringByAppendingString:emoji];
    } deleteButtonAction:^(UIButton *deleteButton, JGEmojiView *view) {
        int len = 1;
        if (self.messageInputView.inputTextView.text.length >= 2) {
            NSString *string = [self.messageInputView.inputTextView.text substringFromIndex:self.messageInputView.inputTextView.text.length-2];
            if ([view.allEmoji containsObject:string]) {
                len = 2;
            }
        } else if (self.messageInputView.inputTextView.text.length == 0) {
            return ;
        }
        self.messageInputView.inputTextView.text = [self.messageInputView.inputTextView.text substringToIndex:self.messageInputView.inputTextView.text.length-len];
    } frame:self.emotionManagerView.bounds];
    [self.emotionManagerView addSubview:view];
    
//    self.emotionManagers = [self makeEmotionManagers];
//    self.emotionManagerView.isShowEmotionStoreButton=YES;
//    [self.emotionManagerView reloadData];
//    self.allowsSendFace = YES;
}
- (void)initSendButton {

    CGRect frame = self.messageInputView.voiceChangeButton.frame;
    frame.origin.x -= 10;
    frame.size.width += 15;
    self.messageInputView.voiceChangeButton.frame = frame;
    
    UIButton *send = [JFQuick buttonWithTarget:self action:@selector(autoSendMessageClick:) frame:self.messageInputView.voiceChangeButton.bounds title:@"发送"];
    [send.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [JFQuick layerBorderForLayer:send.layer];
    [send setBackgroundColor:[UIColor colorWithWhite:0.961 alpha:1.000]];
    [send setTitleColor:[UIColor colorWithRed:0.513 green:0.509 blue:0.509 alpha:1.000] forState:UIControlStateNormal];
    [self.messageInputView.voiceChangeButton addSubview:send];
}
- (void)autoSendMessageClick:(UIButton *)button {
    [self didSendText:self.messageInputView.inputTextView.text fromSender:nil onDate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self initBarButton];
    // 设置自身用户名
    self.messageSender = [JGSocketManager shared].contace.name;
    [self initBottomMenuAndEmotionView];
    [self initSendButton];
    
    [self.messageTableView addHeaderWithCallback:^{
        [self loadMsgsWithLoadMore:YES];
    }];
    [self loadMsgsWithLoadMore:NO];
    
        //设置顶部显示名字
    [self setViewControllerTitle:self.toContace.name];
}
/**
 *  不要问我这个函数干嘛的，我不知道！  去问XH去。。！父类隐藏方法，覆盖掉了直接
 *
 *  @param bottom ＝＝、
 *
 *  @return 。。
 */
- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
//        insets.top = 64;
    }
    
    insets.bottom = bottom;
    
    return insets;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [JFLeanChatHelper helperListenMessageObserver:self selector:@selector(loadMsg:)];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadMsgsWithLoadMore:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [JFLeanChatHelper helperListenRemoveMessageObserver:self];
}

-(void)dealloc{
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    [JFLeanChatHelper helperListenRemoveMessageObserver:self];
}

#pragma mark - prev and next controller

-(void)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - message data

-(void)loadMsg:(NSNotification*)notification{
    [self loadMsgsWithLoadMore:NO];
}

-(NSDate*)getTimestampDate:(int64_t)timestamp{
    return [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
}

-(XHMessage*)getXHMessageByMsg:(JFLeanChatMessage *)msg{
    XHMessage* xhMessage;
    NSDate* time=[self getTimestampDate:[msg.time integerValue]];
    if(msg.type == JFLeanChatMessageTypeText){
        NSString *text = [JGEmojiStandardize convertToSystemEmoticons:msg.senderMessage];
        xhMessage=[[XHMessage alloc] initWithText:text sender:msg.senderName timestamp:time];
    }else if(msg.type == JFLeanChatMessageTypeImage) {
        UIImage *image = [JFQuick imageBase64FromString:msg.senderMessage];
        xhMessage=[[XHMessage alloc] initWithPhoto:image thumbnailUrl:nil originPhotoUrl:nil sender:msg.senderName timestamp:time];
    }else{
        DLog();
    }
    xhMessage.timestamp = [NSDate dateWithTimeIntervalSince1970:[msg.time doubleValue]];
    xhMessage.bubbleMessageType = ![msg.senderID isEqualToString:[JGSocketManager shared].contace.ID];
    xhMessage.status=XHMessageStatusReceived;
    xhMessage.avator = [UIImage imageNamed:msg.senderHeader];
    return xhMessage;
}
- (NSMutableArray *)getXHMessages:(NSArray *)msgs {
    NSMutableArray* messages=[[NSMutableArray alloc] init];
    for(JFLeanChatMessage* msg in msgs){
        XHMessage* xhMsg=[self getXHMessageByMsg:msg];
        if(xhMsg){
            [messages addObject:xhMsg];
        }
    }
    return messages;
}

-(void)loadMsgsWithLoadMore:(BOOL)isLoadMore{
    if (_isLoadingMsg) {
        return;
    }
    _isLoadingMsg = YES;
    JFLeanChatMessage *model = isLoadMore?[_leanMessageModels firstObject]:nil;
    double time = [model.time doubleValue];
    if (time == 0) {
        time = [[NSDate date] timeIntervalSince1970];
    }
    [JFLeanChatHelper helperReadMessageLastTime:time complete:^(NSArray *messages) {
        if (!messages) {
            _isLoadingMsg = NO;
            return;
        }
        [JFQuick runInGlobalQueue:^{
            
            if (isLoadMore) {
                for (int i = (int)messages.count-1; i>=0; i--) {
                    [_leanMessageModels insertObject:messages[i] atIndex:0];
                }
            } else {
                [_leanMessageModels removeAllObjects];
                [_leanMessageModels addObjectsFromArray:messages];
            }
            
            NSMutableArray *messages = [self getXHMessages:_leanMessageModels];
            NSInteger row = isLoadMore?((messages.count-1)-(self.messages.count-1)):messages.count-1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row>=0?row:0 inSection:0];
            [JFQuick runInMainQueue:^{
                self.messages = messages;
                [self.messageTableView reloadData];
                if (messages.count) {
                    [self.messageTableView scrollToRowAtIndexPath:indexPath
                                                 atScrollPosition:isLoadMore?UITableViewScrollPositionTop:UITableViewScrollPositionBottom animated:YES];
                }
                _isLoadingMsg = NO;
            }];
        }];
    }];
}

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIViewController *disPlayViewController = nil;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            UIView *view =[JFShowImageViewForChat showImage:[messageTableViewCell.messageBubbleView.bubblePhotoImageView messagePhoto] URL:[message originPhotoUrl]];
            [view setBackgroundColor:[UIColor blackColor]];
//            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
//            messageDisplayTextView.message = message;
//            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}
//
//- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
//    DLog(@"text : %@", message.text);
//    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
//    displayTextViewController.message = message;
//    [self.navigationController pushViewController:displayTextViewController animated:YES];
//}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

//#pragma mark - XHEmotionManagerView DataSource
//
//- (NSInteger)numberOfEmotionManagers {
//    return self.emotionManagers.count;
//}
//
//- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
//    return [self.emotionManagers objectAtIndex:column];
//}
//
//- (NSArray *)emotionManagersAtManager {
//    return self.emotionManagers;
//}

#pragma mark - XHMessageTableViewController Delegate

/**
 *  巨卡！废弃。。
 
 //- (BOOL)shouldLoadMoreMessagesScrollToTop {
 //    return YES;
 //}
 //
 //- (void)loadMoreMessagesScrollTotop {
 //    [self loadMsgsWithLoadMore:YES];
 //}
 */

//发送文本消息的回调方法
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    if([text length]>0){
        text = [JGEmojiStandardize convertToCommonEmoticons:text];
        [self autoSendMessage:text image:nil];
    }
}

//发送图片消息的回调方法
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self autoSendMessage:nil image:photo];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
}
- (void)autoSendMessage:(NSString *)message image:(UIImage *)photo {
    [JFLeanChatHelper helperSendMessage:message image:photo toContace:self.toContace];
    self.messageInputView.inputTextView.text = nil;
}

//// 发送表情消息的回调方法
//- (void)didSendEmotion:(NSString *)emotion fromSender:(NSString *)sender onDate:(NSDate *)date {
//    UITextView *textView=self.messageInputView.inputTextView;
//    NSRange range=[textView selectedRange];
//    NSMutableString* str=[[NSMutableString alloc] initWithString:textView.text];
//    [str deleteCharactersInRange:range];
//    [str insertString:emotion atIndex:range.location];
////    textView.text=[CDEmotionUtils convertWithText:str toEmoji:YES];
//    textView.selectedRange=NSMakeRange(range.location+emotion.length, 0);
//    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
//}


// 是否显示时间轴Label的回调方法
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
        return YES;
    }else{
        XHMessage* msg=[self.messages objectAtIndex:indexPath.row];
        XHMessage* lastMsg=[self.messages objectAtIndex:indexPath.row-1];
        int interval=[msg.timestamp timeIntervalSinceDate:lastMsg.timestamp];
        if(interval>60*3){
            return YES;
        }else{
            return NO;
        }
    }
}
// 配置Cell的样式或者字体
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    XHMessage* msg=[self.messages objectAtIndex:indexPath.row];
    if([self shouldDisplayTimestampForRowAtIndexPath:indexPath]){
        NSDate* ts=msg.timestamp;
        NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString* str=[dateFormatter stringFromDate:ts];
        cell.timestampLabel.text=str;
        cell.timestampLabel.center = CGPointMake(cell.timestampLabel.superview.center.x, cell.timestampLabel.center.y);
        [cell.timestampLabel setBadgeColor:[UIColor colorWithRed:0.705 green:0.701 blue:0.683 alpha:1.000]];
    }
    SETextView* textView=cell.messageBubbleView.displayTextView;
    if(msg.bubbleMessageType==XHBubbleMessageTypeSending){
        [textView setTextColor:[UIColor whiteColor]];
    }else{
        [textView setTextColor:[UIColor blackColor]];
    }
    [JFQuick layerMasksToCircleForView:cell.avatorButton];
    [cell.userNameLabel setTextColor:[UIColor colorWithWhite:0.431 alpha:1.000]];
}

// 协议回掉是否支持用户手动滚动
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

-(void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    [super didSelecteShareMenuItem:shareMenuItem atIndex:index];
}


@end

