//
//  HomeBatchOperationViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HomeBatchOperationViewController.h"


#import "BatchOperationTableViewCell.h"
@interface HomeBatchOperationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    double _BatchOperationPage;
    double _BatchOperationPages;
}

@property(nonatomic,strong)UITableView *BatchOperationTableView;
@property(nonatomic,strong)NSMutableArray *BatchOperationDataList;

@end

@implementation HomeBatchOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawHomeBatchOperationUI];
    
    [self getHomeBatchOperationDataWithPage:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (void)getHomeBatchOperationDataWithPage:(int)page
{
    self.BatchOperationDataList = [NSMutableArray array];
    for (NSDictionary *dic in CustomerData) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mutDic setObject:@NO forKey:@"isChoose"];
        [self.BatchOperationDataList addObject:mutDic];
    }
    [self.BatchOperationTableView reloadData];
}

#pragma mark - 绘制UI
- (void)drawHomeBatchOperationUI
{
    
    [self NavTitleWithText:@"批量操作"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"确定" target:self action:@selector(BatchOperation)];
    
    
    self.BatchOperationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    self.BatchOperationTableView.backgroundColor = BaseBgColor;
    self.BatchOperationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.BatchOperationTableView.delegate = self;
    self.BatchOperationTableView.dataSource = self;
    self.BatchOperationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.BatchOperationTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_BatchOperationPage ==_BatchOperationPages) {
            [self.BatchOperationTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _BatchOperationPage++;
                
                [self getHomeBatchOperationDataWithPage:_BatchOperationPage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [self.BatchOperationTableView reloadData];
                    if (_BatchOperationPage ==_BatchOperationPages) {
                        [self.BatchOperationTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [self.BatchOperationTableView.mj_footer endRefreshing];
                    }
                });
            });
        }
    }];
    
    [self.view addSubview:self.BatchOperationTableView];
}

#pragma mark - 按钮事件
- (void)BatchOperation
{
    
    NSMutableArray *datas = [NSMutableArray array];
    for (NSMutableDictionary *person in self.BatchOperationDataList) {
        if ([[person valueForKey:@"isChoose"] boolValue] == YES) {
            [datas addObject:person[@"msid"]];
        }
    }
    NSLog(@"%@",datas);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *changerateAction = [UIAlertAction actionWithTitle:@"改变负责人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:deleteAction];
    [alertController addAction:okAction];
    [alertController addAction:changerateAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *person = self.BatchOperationDataList[indexPath.row];
    person[@"isChoose"] = @(![person[@"isChoose"] boolValue]);
    [tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.BatchOperationDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BatchOperationIdent = @"BatchOperationIdent";
    BatchOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BatchOperationIdent];
    if (cell == nil) {
        cell = [[BatchOperationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BatchOperationIdent];
    }
    
    cell.dic = self.BatchOperationDataList[indexPath.row];
    return cell;
}
@end
