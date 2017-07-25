//
//  MessageSettingViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MessageSettingViewController.h"
#import "SelectPersonInChargeViewController.h"

#import "MessageSettingTableViewCell.h"
@interface MessageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_MessageSettingTableView;
}
@property(nonatomic,strong)NSMutableArray *MessageSettingDataList;
@end

@implementation MessageSettingViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageSetting:) name:@"messageSetting" object:nil];
    
    
    [self drawMessageSettingUI];
    
    [self getMessageSettingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawMessageSettingUI
{
    [self NavTitleWithText:@"消息设置"];
    
    _MessageSettingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _MessageSettingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _MessageSettingTableView.backgroundColor = BaseBgColor;
    _MessageSettingTableView.delegate = self;
    _MessageSettingTableView.dataSource = self;
    _MessageSettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MessageSettingTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_MessageSettingTableView];
}

#pragma mark - 获取数据
- (void)getMessageSettingData
{
    _MessageSettingDataList = [NSMutableArray arrayWithArray:@[@{@"title":@"新消息通知",@"isOpen":@"1"},@{},@{@"title":@"接受新情报通知",@"isOpen":@"1",@"showline":@"1"},@{@"title":@"情报推送时间",@"time":@"09:00"}]];
}

#pragma mark - 通知事件
- (void)messageSetting:(NSNotification *)noti
{
    NSLog(@"%@",noti.object);
    for (int i = 0; i < _MessageSettingDataList.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_MessageSettingDataList[i]];
        if ([dic.allValues containsObject:noti.object]) {
            if ([dic.allKeys containsObject:@"isOpen"]) {
                if ([[dic valueForKey:@"isOpen"] isEqualToString:@"1"]) {
                    [dic setObject:@"0" forKey:@"isOpen"];
                    [_MessageSettingDataList replaceObjectAtIndex:i withObject:dic];
                    if ([noti.object isEqualToString:@"新消息通知"]) {
                        [_MessageSettingDataList removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _MessageSettingDataList.count - 1)]];
                    } else if ([noti.object isEqualToString:@"接受新情报通知"]) {
                        [_MessageSettingDataList removeObjectAtIndex:3];
                    }
                } else {
                    [dic setObject:@"1" forKey:@"isOpen"];
                    [_MessageSettingDataList replaceObjectAtIndex:i withObject:dic];
                    if ([noti.object isEqualToString:@"新消息通知"]) {
                        [_MessageSettingDataList addObjectsFromArray:@[@{},@{@"title":@"接受新情报通知",@"isOpen":@"0",@"showline":@"1"}]];
                    } else if ([noti.object isEqualToString:@"接受新情报通知"]) {
                        [_MessageSettingDataList addObjectsFromArray:@[@{@"title":@"情报推送时间",@"time":@"09:00"}]];
                    }
                }
            }
            [_MessageSettingTableView reloadData];

            if ([dic.allKeys containsObject:@"time"]){
                NSMutableArray *times = [NSMutableArray array];
                for (int i = 1; i < 25; i++) {
                    NSMutableDictionary *time = [NSMutableDictionary dictionary];
                    i < 10 ? [time setObject:[NSString stringWithFormat:@"0%d:00",i] forKey:@"name"] : [time setObject:[NSString stringWithFormat:@"%d:00",i] forKey:@"name"];
                    [times addObject:time];
                }
                SelectPersonInChargeViewController *SelectTimeVC = [[SelectPersonInChargeViewController alloc] init];
                SelectTimeVC.personInCharge = @{@"name":[self.MessageSettingDataList[3] valueForKey:@"time"]};
                SelectTimeVC.datalist = times;
                SelectTimeVC.key = @"name";
                __weak MessageSettingViewController *weakSelf = self;
                SelectTimeVC.changePersnInCharge = ^(NSDictionary *personMessage){
                    NSMutableDictionary *timedic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.MessageSettingDataList[3]];
                    [timedic setObject:[personMessage valueForKey:@"name"] forKey:@"time"];
                    [weakSelf.MessageSettingDataList replaceObjectAtIndex:3 withObject:timedic];
                    [_MessageSettingTableView reloadData];

                };
                [self.navigationController pushViewController:SelectTimeVC animated:YES];
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 10;
    } else {
        return 50;
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _MessageSettingDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondcell"];
        cell.backgroundColor = BaseBgColor;
        cell.selectionStyle = NO;
        return cell;
    } else {
        MessageSettingTableViewCell *cell = [[MessageSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageSettingident"];
        cell.dic = _MessageSettingDataList[indexPath.row];
        cell.selectionStyle = NO;
        return cell;
    }
}

@end
