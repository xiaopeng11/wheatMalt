//
//  CustomerViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CustomerViewController.h"
#import "AddCustomerViewController.h"
#import "CustomerMessageViewController.h"

#import "CustomerTableViewCell.h"
@interface CustomerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_CustomerTableView;
    NSMutableArray *_CustomerDatalist;
}

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawCustomerUI];
    
    [self getCustomerData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏按钮事件
- (void)addKehu
{
    AddCustomerViewController *AddCustomerVC = [[AddCustomerViewController alloc] init];
    [self.navigationController pushViewController:AddCustomerVC animated:YES];
}

#pragma mark - 绘制UI
- (void)drawCustomerUI
{
    [self NavTitleWithText:@"情报"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"add_kehu" highImageName:@"add_kehu" target:self action:@selector(addKehu)];
    
    _CustomerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _CustomerTableView.backgroundColor = BaseBgColor;
    _CustomerTableView.dataSource = self;
    _CustomerTableView.delegate = self;
    _CustomerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _CustomerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_CustomerTableView];
}

#pragma mark - 获取数据
- (void)getCustomerData
{
    _CustomerDatalist = [NSMutableArray arrayWithArray:CustomerData];
    
    [_CustomerTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustomerMessageViewController *CustomerMessageVC = [[CustomerMessageViewController alloc] init];
    CustomerMessageVC.customer = _CustomerDatalist[indexPath.row];
    [self.navigationController pushViewController:CustomerMessageVC animated:YES];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _CustomerDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customerIdent = @"customerIdent";
    CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerIdent];
    if (cell == nil) {
        cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customerIdent];
    }
    cell.dic = _CustomerDatalist[indexPath.row];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *InvalidAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"失效" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:_CustomerDatalist[indexPath.row]];
        [mutDic setObject:@"5" forKey:@"lx"];
        [_CustomerDatalist replaceObjectAtIndex:indexPath.row withObject:mutDic];
        [_CustomerDatalist removeObjectAtIndex:indexPath.row];
        [_CustomerDatalist insertObject:mutDic atIndex:_CustomerDatalist.count - 1];
        [tableView reloadData];
    }];
    InvalidAction.backgroundColor = [UIColor colorWithHexString:@"#efb336"];
    
    UITableViewRowAction *recoveryAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"恢复" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:_CustomerDatalist[indexPath.row]];
        [mutDic setObject:[mutDic valueForKey:@"usedlx"] forKey:@"lx"];
        [_CustomerDatalist replaceObjectAtIndex:indexPath.row withObject:mutDic];
        [tableView reloadData];
    }];
    recoveryAction.backgroundColor = [UIColor colorWithHexString:@"#efb336"];

    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [_CustomerDatalist removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    if ([[_CustomerDatalist[indexPath.row] valueForKey:@"lx"] isEqualToString:@"5"]) {
        return @[deleteAction,recoveryAction];
    } else {
        return @[deleteAction,InvalidAction];
    }
}

@end
