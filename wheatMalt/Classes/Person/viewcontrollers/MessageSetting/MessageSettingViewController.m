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

@property(nonatomic,strong)NSMutableArray *MessageSettingDataList;
@property(nonatomic,strong)UITableView *MessageSettingTableView;

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
    
    [self Processinglocaldata];
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
- (void)Processinglocaldata
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaluts objectForKey:wheatMalt_UserMessage];
    NSDictionary *userpersonset = [BasicControls dictionaryWithJsonString:[userMessage valueForKey:@"persionset"]];
    NSArray *warnings = [userpersonset valueForKey:@"txList"];
    
    NSArray *allOpen = @[
                         @{@"title":@"推送通知",@"isOpen":@"1"},
                         @{},
                         @{@"title":@"吐槽通知",@"isOpen":@"1",@"txlx": @"TCTZ"},
                         @{},
                         @{@"title":@"情报通知",@"isOpen":@"1",@"showline":@"1",@"txlx": @"QBTZ"},
                         @{@"title":@"情报通知时间",@"time":@"09:00"},
                         @{},
                         @{@"title":@"客户付款通知",@"isOpen":@"1",@"txlx": @"FKTZ"},
                         @{},
                         @{@"title":@"小麦芽申请通知",@"isOpen":@"1",@"txlx": @"SQTZ"}
                         ];
    
    _MessageSettingDataList = [NSMutableArray array];
    
    NSMutableArray *openStates = [NSMutableArray array];
    for (NSDictionary *warning in warnings) {
        [openStates addObject:[warning valueForKey:@"txflag"]];
    }

    //总开关
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:allOpen[0]];
    if (![openStates containsObject:@"1"]) {
        //关闭通知
        [dic setObject:@"0" forKey:@"isOpen"];
        [_MessageSettingDataList insertObject:dic atIndex:0];
    } else {
        //开启通知
        [_MessageSettingDataList insertObject:allOpen[0] atIndex:0];
        
        //吐槽通知
        for (NSDictionary *warnning in warnings) {
            if ([[warnning valueForKey:@"txname"] isEqualToString:@"吐槽通知"]) {
                [_MessageSettingDataList insertObject:allOpen[1] atIndex:_MessageSettingDataList.count];

                if ([[warnning valueForKey:@"txflag"] isEqualToString:@"1"]) {
                    [_MessageSettingDataList insertObject:allOpen[2] atIndex:_MessageSettingDataList.count];
                } else {
                    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:allOpen[2]];
                    [dic2 setObject:@"0" forKey:@"isOpen"];
                    [_MessageSettingDataList insertObject:dic2 atIndex:_MessageSettingDataList.count];
                }
                break;
            }
        }
        
        //情报通知
        for (NSDictionary *warnning in warnings) {
            if ([[warnning valueForKey:@"txname"] isEqualToString:@"情报通知"]) {
                [_MessageSettingDataList insertObject:allOpen[3] atIndex:_MessageSettingDataList.count];
                if ([[warnning valueForKey:@"txflag"] isEqualToString:@"1"]) {
                    [_MessageSettingDataList insertObject:allOpen[4] atIndex:_MessageSettingDataList.count];
                    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithDictionary:allOpen[5]];
                    [dic5 setObject:warnning[@"txtime"] forKey:@"time"];
                    [_MessageSettingDataList insertObject:dic5 atIndex:_MessageSettingDataList.count];
                } else {
                    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithDictionary:allOpen[2]];
                    [dic4 setObject:@"0" forKey:@"isOpen"];
                    [_MessageSettingDataList insertObject:dic4 atIndex:_MessageSettingDataList.count];
                }
                break;
            }
        }
        
        //客户付款通知
        for (NSDictionary *warnning in warnings) {
            if ([[warnning valueForKey:@"txname"] isEqualToString:@"客户付款通知"]) {
                [_MessageSettingDataList insertObject:allOpen[6] atIndex:_MessageSettingDataList.count];

                if ([[warnning valueForKey:@"txflag"] isEqualToString:@"1"]) {
                    [_MessageSettingDataList insertObject:allOpen[7] atIndex:_MessageSettingDataList.count];
                } else {
                    NSMutableDictionary *dic7 = [NSMutableDictionary dictionaryWithDictionary:allOpen[7]];
                    [dic7 setObject:@"0" forKey:@"isOpen"];
                    [_MessageSettingDataList insertObject:dic7 atIndex:_MessageSettingDataList.count];
                }
                break;
            }
        }
        
        //小麦芽申请通知
        for (NSDictionary *warnning in warnings) {
            if ([[warnning valueForKey:@"txname"] isEqualToString:@"小麦芽申请通知"]) {
                [_MessageSettingDataList insertObject:allOpen[8] atIndex:_MessageSettingDataList.count];
                
                if ([[warnning valueForKey:@"txflag"] isEqualToString:@"1"]) {
                    [_MessageSettingDataList insertObject:allOpen[9] atIndex:_MessageSettingDataList.count];
                } else {
                    NSMutableDictionary *dic9 = [NSMutableDictionary dictionaryWithDictionary:allOpen[9]];
                    [dic9 setObject:@"0" forKey:@"isOpen"];
                    [_MessageSettingDataList insertObject:dic9 atIndex:_MessageSettingDataList.count];
                }
                break;
            }
        }
    }
    
    [_MessageSettingTableView reloadData];
}

#pragma mark - 网络请求
/**
 总开关

 @param lx 开/关
 */
- (void)changeWarningStateWithLx:(NSString *)lx
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lx forKey:@"flag"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_Totalnotice params:params Token:YES success:^(id responseObject) {
        NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
        [userdefaluts setObject:responseObject[@"VO"] forKey:wheatMalt_UserMessage];
        NSLog(@"%@",responseObject);
        [userdefaluts synchronize];
    } failure:^(NSError *error) {
        
    } Target:self];
}

/**
 提醒的小开关

 @param txlx 提醒类型
 @param txflag 标志
 @param txtime 时间
 */
- (void)changeWarningStateDetailWithtxlx:(NSString *)txlx
                                  txflag:(NSString *)txflag
                                  txtime:(NSString *)txtime
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:txlx forKey:@"txlx"];
    [params setObject:txflag forKey:@"txflag"];
    [params setObject:txtime forKey:@"txtime"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_TotalnoticeDetail params:params Token:YES success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
        [userdefaluts setObject:responseObject[@"VO"] forKey:wheatMalt_UserMessage];
        [userdefaluts synchronize];
    } failure:^(NSError *error) {
        
    } Target:self];
}


#pragma mark - 通知事件
- (void)messageSetting:(NSNotification *)noti
{
    NSLog(@"%@",noti.object);
    for (int i = 0; i < _MessageSettingDataList.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_MessageSettingDataList[i]];
        if ([[dic valueForKey:@"title"] isEqualToString:[noti.object valueForKey:@"title"]]) {
            //点击的是按钮
            if ([dic.allKeys containsObject:@"isOpen"]) {
                //关闭
                if ([[dic valueForKey:@"isOpen"] isEqualToString:@"1"]) {
                    [dic setObject:@"0" forKey:@"isOpen"];
                    [_MessageSettingDataList replaceObjectAtIndex:i withObject:dic];
                    
                    if ([dic[@"title"] isEqualToString:@"推送通知"]) {
                        //关闭推送通知
                        [_MessageSettingDataList removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _MessageSettingDataList.count - 1)]];
                        [self changeWarningStateWithLx:@"0"];
                    } else if([dic[@"title"] isEqualToString:@"情报通知"]) {
                        //关闭情报通知
                        [dic removeObjectForKey:@"showline"];
                        [_MessageSettingDataList replaceObjectAtIndex:i withObject:dic];
                        [_MessageSettingDataList removeObjectAtIndex:i + 1];
                        [self changeWarningStateDetailWithtxlx:dic[@"txlx"] txflag:@"0" txtime:@""];
                    } else {
                        [self changeWarningStateDetailWithtxlx:dic[@"txlx"] txflag:@"0" txtime:@""];
                    }
                } else {
                    //开启
                    [dic setObject:@"1" forKey:@"isOpen"];
                    [_MessageSettingDataList replaceObjectAtIndex:i withObject:dic];
                    
                    if ([dic[@"title"] isEqualToString:@"推送通知"]) {
                        [_MessageSettingDataList addObjectsFromArray:@[@{},
                                                                       @{@"title":@"吐槽通知",@"isOpen":@"1"},
                                                                       @{},
                                                                       @{@"title":@"情报通知",@"isOpen":@"1",@"showline":@"1"},
                                                                       @{@"title":@"情报通知时间",@"time":@"09:00"},
                                                                       @{},
                                                                       @{@"title":@"客户付款通知",@"isOpen":@"1"},
                                                                       @{},
                                                                       @{@"title":@"小麦芽申请通知",@"isOpen":@"1"}]];
                        [self changeWarningStateWithLx:@"1"];

                    }else if ([dic[@"title"] isEqualToString:@"情报通知"]) {
                        [dic setObject:@"1" forKey:@"showline"];
                        [_MessageSettingDataList replaceObjectAtIndex:i withObject:dic];
                        [_MessageSettingDataList insertObject:@{@"title":@"情报通知时间",@"time":@"09:00"} atIndex:i + 1];
                        [self changeWarningStateDetailWithtxlx:dic[@"txlx"] txflag:@"1" txtime:@"09:00"];
                    } else {
                        [self changeWarningStateDetailWithtxlx:dic[@"txlx"] txflag:@"1" txtime:@""];
                    }
                }
            }

            //改变的是时间
            if ([dic.allKeys containsObject:@"time"]){
                
                //时间列表
                NSMutableArray *times = [NSMutableArray array];
                for (int i = 1; i < 25; i++) {
                    NSMutableDictionary *time = [NSMutableDictionary dictionary];
                    i < 10 ? [time setObject:[NSString stringWithFormat:@"0%d:00",i] forKey:@"time"] : [time setObject:[NSString stringWithFormat:@"%d:00",i] forKey:@"time"];
                    [times addObject:time];
                }
                
                SelectPersonInChargeViewController *SelectTimeVC = [[SelectPersonInChargeViewController alloc] init];
                SelectTimeVC.personInCharge = @{@"time":[self.MessageSettingDataList[5] valueForKey:@"time"]};
                SelectTimeVC.datalist = times;
                SelectTimeVC.key = @"time";
                __weak MessageSettingViewController *weakSelf = self;
                SelectTimeVC.changePersnInCharge = ^(NSDictionary *personMessage){
                    NSMutableDictionary *timedic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.MessageSettingDataList[5]];
                    [timedic setObject:[personMessage valueForKey:@"time"] forKey:@"time"];
                    [weakSelf.MessageSettingDataList replaceObjectAtIndex:5 withObject:timedic];
                    [weakSelf.MessageSettingTableView reloadData];
                    [self changeWarningStateDetailWithtxlx:@"QBTZ" txflag:@"1" txtime:[personMessage valueForKey:@"time"]];

                };
                [self.navigationController pushViewController:SelectTimeVC animated:YES];
            }
            
            [_MessageSettingTableView reloadData];

        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _MessageSettingDataList[indexPath.row];
    if (![dic.allKeys containsObject:@"title"]) {
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
    NSDictionary *dic = _MessageSettingDataList[indexPath.row];
    if (![dic.allKeys containsObject:@"title"]) {
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
