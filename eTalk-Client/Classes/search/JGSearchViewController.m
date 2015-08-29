//
//  JGSearchViewController.m
//  eTalk
//
//  Created by sl on 15/4/14.
//  Copyright (c) 2015年 Madordie. All rights reserved.
//

#import "JGSearchViewController.h"
#import "JGSearchResultTableViewCell.h"

@interface JGSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation JGSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureTableView];
}
- (void)configureTableView {
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.datas = [NSMutableArray array];
    [JGSearchResultTableViewCell autoRegistNibForTableView:self.tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)socketHaveMsg:(NSNotification *)sockmsg {
        //搜索联系人回调
    [JGManagerHelper searchContaceMsg:sockmsg callBack:^(JGSocketMsg *msg, id respondData, NSError *error) {
        if (!respondData) {
            return ;
        }
        [self.datas addObject:respondData];
        [self.tableView reloadData];
    }];
        //添加联系人回调
    [JGManagerHelper searchAddContaceMsg:sockmsg callBack:^(JGSocketMsg *msg, id respondData, NSError *error) {
        if (error) {
            [JFQuick showHint:@"添加失败"];
            return ;
        }
        UIAlertView * alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜您添加好友成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alview show];
        JGExBlock(self.exIfAddContace, self, respondData);
    }];
}

//数据填充
- (void)cellDataSource:(id)data cell:(UITableViewCell *)cell {
    JGContace *contace = data;
    [cell.imageView setImageName:contace.headImage];
    cell.textLabel.text = contace.name;
    cell.detailTextLabel.text = contace.ID;
}
//添加联系人
- (void)addContaceForData:(id)data {
    [JGManagerHelper searchAddContace:data];

}

#pragma mark - <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [JGManagerHelper searchContace:[[searchBar.text componentsSeparatedByString:@" "] componentsJoinedByString:@""]];
    [self.datas removeAllObjects];
    searchBar.text = nil;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.datas removeAllObjects];
    [self.tableView reloadData];
    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JGSearchResultTableViewCell returnDefaultReuseIdentifier]];
    [self cellDataSource:self.datas[indexPath.row] cell:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self addContaceForData:self.datas[indexPath.row]];
}

@end
