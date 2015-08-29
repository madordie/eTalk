//
//  UIWebView+quick.m
//  SkinRun
//
//  Created by sl on 15/1/15.
//  Copyright (c) 2015年 上海商路网络科技有限公司. All rights reserved.
//

#import "UIWebView+quick.h"
#import "JFQuick.h"

@interface UIWebView ()<UIWebViewDelegate>

@end
@implementation UIWebView (quick)

- (void)loadRequestURL:(NSString *)url {
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (CGFloat)autoHeight {
//    //调整webview字体的大小
//    [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
//    
//    CGRect frame = self.frame;
//    frame.size.height = 1;
//    self.frame = frame;
//    CGSize fittingSize = [self sizeThatFits:CGSizeZero];
//    return fittingSize.height;
//    return  [[self stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    return self.scrollView.contentSize.height;
}
@end
