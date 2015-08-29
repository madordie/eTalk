//
//  JGLoginViewController.m
//  eTalk
//
//  Created by sl on 15/3/18.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGLoginViewController.h"
#import "JGTestViewController.h"
#import "JGRegisterViewController.h"
#import "JFListViewController.h"
#import "JGSharedInfo.h"

@interface JGLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usrname;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation JGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [JFQuick layerBorderForLayer:_usrname.layer];
    [JFQuick layerBorderForLayer:_password.layer];
    [JFQuick changeContaceForUITextField:_usrname];
    [JFQuick changeContaceForUITextField:_password];
    [self setViewControllerTitle:@"eTalk"];
    self.navigationItem.leftBarButtonItem = [JFQuick barButtonItemWithTarget:self
                                                                      action:@selector(registButtonClick:)
                                                                        size:CGSizeMake(50, 50)
                                                                       title:@"注册"];
    self.navigationItem.rightBarButtonItem = [JFQuick barButtonItemWithTarget:self
                                                                       action:@selector(testIP:)
                                                                         size:CGSizeMake(50, 50)
                                                                        title:@"测试"];
    [JGManagerHelper autoSetIPPort];
    NSString *ID = @"";
    NSString *pw = @"";
    [JGSharedInfo readerID:&ID password:&pw];
    _usrname.text = ID;
    _password.text = pw;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
- (IBAction)loginAction:(id)sender {
    [JFQuick keyWindowEndEditing];
    [JGManagerHelper loginUsername:_usrname.text password:_password.text];
}
- (void)registButtonClick:(UIButton *)sender {
    [self.navigationController pushViewController:[JGRegisterViewController viewController]
                                         animated:YES];
}
- (void)socketHaveMsg:(NSNotification *)sockmsg {
    [JGManagerHelper loginMsg:sockmsg callBack:^(JGSocketMsg *msg, NSError *error) {
        if (error) {
            [JFQuick showHint:@"用户名或密码错误"];
        } else {
            //  登录成功
            [self.navigationController pushViewController:[JFListViewController viewController]
                                                 animated:YES];
            [JGSharedInfo writerID:_usrname.text password:_password.text];
        }
    }];
}
- (void)testIP:(UIButton *)sender {
    [self.navigationController pushViewController:[JGTestViewController viewController]
                                         animated:YES];
}

@end
