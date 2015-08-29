//
//  JGRegisterViewController.m
//  eTalk
//
//  Created by sl on 15/3/26.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGRegisterViewController.h"
#import "JGHeadListView.h"

@interface JGRegisterViewController () <JGHeadListViewDelegate>
{
    NSString *_curHeader;
}
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *headerImage;

@end

@implementation JGRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [JFQuick layerBorderForLayer:_username.layer];
    [JFQuick layerBorderForLayer:_password.layer];
    [JFQuick layerBorderForLayer:_headerImage.layer];
    [JFQuick changeContaceForUITextField:_username];
    [JFQuick changeContaceForUITextField:_password];
    
    _curHeader = @"1";
    
    [_headerImage setImageForNormal:_curHeader];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerButtonClick:(id)sender {
    [JGManagerHelper registerUsername:_username.text password:_password.text header:_curHeader];
}
- (void)socketHaveMsg:(NSNotification *)sockmsg {
    [JGManagerHelper registerMsg:sockmsg callBack:^(JGSocketMsg *msg, NSError *error) {
        [JGControl controlMakeAlViewTitle:@"账号注册成功"
                                     info:[NSString stringWithFormat:@"恭喜您申请成功，申请账号为:%@", msg.msg]
                              buttonTitle:@"确定"];
    }];
}

- (IBAction)headerImageButtonClick:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    JGHeadListView *listView = [JGHeadListView headListViewWithFrame:sender.frame withDelegate:self];
    [listView setBackgroundColor:[UIColor whiteColor]];
    [listView setOldFrame:sender.frame];
    [UIView animateWithDuration:0.2 animations:^{
        [listView setFrame:CGRectMake(0, 0, 310, 200)];
        listView.center = self.view.center;
    }];
    [self.view addSubview:listView];
    [JFQuick layerBorderForLayer:listView.layer];
}
- (void)headListView:(JGHeadListView *)headListView didSelectImageName:(NSString *)imageName {
    _curHeader = imageName;
    [_headerImage setImageForNormal:imageName];
}

@end
