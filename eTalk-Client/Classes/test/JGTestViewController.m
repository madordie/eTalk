//
//  JGTestViewController.m
//  eTalk
//
//  Created by sl on 15/3/26.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGTestViewController.h"

@interface JGTestViewController ()
@property (strong, nonatomic) IBOutlet UITextField *ip;
@property (strong, nonatomic) IBOutlet UITextField *port;

@end

@implementation JGTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [JFQuick layerBorderForLayer:_ip.layer];
    [JFQuick layerBorderForLayer:_port.layer];
    [JFQuick changeContaceForUITextField:_ip];
    [JFQuick changeContaceForUITextField:_port];
    
    _ip.text = [JGSharedInfo shared].serverIP;
    _port.text = [JGSharedInfo shared].serverPort;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testAction:(id)sender {
    [JGManagerHelper testServerIP:_ip.text port:_port.text];
    [self performSelector:@selector(autoShowNoServer) withObject:nil afterDelay:2];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [JFQuick showHint:@"正在搜索服务..."];
}

- (void)socketHaveMsg:(NSNotification *)sockmsg {
    [JGManagerHelper testMsg:sockmsg callBack:^(JGSocketMsg *msg, NSError *error) {
        [JFQuick showHint:@"该服务可以使用"];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoShowNoServer) object:nil];
    }];
}

- (void)autoShowNoServer {
    [JFQuick showHint:@"找不到服务"];
}

@end
