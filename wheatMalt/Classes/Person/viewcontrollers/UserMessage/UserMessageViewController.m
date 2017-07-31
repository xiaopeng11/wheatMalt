//
//  UserMessageViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserMessageViewController.h"
#import "UserHeaderViewViewController.h"
#import "showVViewController.h"
@interface UserMessageViewController ()
{
    NSMutableDictionary *_personMessageData;
    
}
@end

@implementation UserMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //0:公司,1:客户经理,2:商务,3:研发
    _personMessageData = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"肖鹏",@"level":@"1",@"lx":@"3",@"phone":@"18013547101",@"address":@"苏州工业园区若水路200号",@"headerurl":@"640.jpg"}];
    
    [self drawUserMessageUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawUserMessageUI
{
    [self NavTitleWithText:@"个人信息"];
    
    UIScrollView *scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    scrollView.userInteractionEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = BaseBgColor;
    [self.view addSubview:scrollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 280)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [scrollView addSubview:bgView];
    
    NSArray *array = @[@"头像",@"昵称",@"手机号",@"我的V级",@"地址"];
    NSArray *placers = @[@"",@"请输入昵称",@"请输入手机号",@"",@"请输入地址"];
    NSArray *Vs = @[@[@"V0"],@[@"V1_1",@"V1_2",@"V1_3"],@[@"V2_1",@"V2_2",@"V2_3"],@[@"V3_1",@"V3_2",@"V3_3"]];
    
    for (int i = 0; i < array.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        UIView *lineView;
        UITextField *textField = [[UITextField alloc] init];
        textField.tag = 51100 + i;
        if (i == 0) {
            titleLabel.frame = CGRectMake(10, 20, 100, 30);
            titleLabel.font = LargeFont;
            lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 80, KScreenWidth, .5)];
            
            UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 85, 15, 50, 50)];
            headerView.clipsToBounds = YES;
            headerView.layer.cornerRadius = 10;
            headerView.image = [UIImage imageNamed:[_personMessageData valueForKey:@"headerurl"]];
            [bgView addSubview:headerView];
            
            UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 25, 32.5, 15, 15)];
            leaderView.image = [UIImage imageNamed:@"lead"];
            [bgView addSubview:leaderView];
            
            UIButton *chooseHead = [UIButton buttonWithType:UIButtonTypeCustom];
            chooseHead.frame = CGRectMake(0, 0, KScreenWidth, 80);
            [chooseHead addTarget:self action:@selector(changeHeaderView) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:chooseHead];
        } else {
            titleLabel.frame = CGRectMake(10, 80 + 10 + (50 * (i - 1)), 100, 30);
            titleLabel.font = SmallFont;
            if (i < array.count - 1) {
                lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 80 + 50 * i, KScreenWidth, .5)];
            }
            
            if (i == 1 || i == 2 || i == 4) {
                textField.frame = CGRectMake(110, 80 + 10 + (50 * (i - 1)), KScreenWidth - 120, 30);
                textField.borderStyle = UITextBorderStyleNone;
                textField.font = SmallFont;
                textField.placeholder = placers[i];
                textField.textAlignment = NSTextAlignmentRight;
                if (i == 1) {
                    textField.text = [_personMessageData valueForKey:@"name"];
                } else if (i == 2) {
                    textField.text = [_personMessageData valueForKey:@"phone"];
                } else if (i == 4) {
                    textField.text = [_personMessageData valueForKey:@"address"];
                }
                [bgView addSubview:textField];
            }
            
            if (i == 3) {
                UIImageView *VView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 60, 10 + 80 + 50 * 2, 30, 30)];
                NSInteger lx = [[_personMessageData valueForKey:@"lx"] integerValue];
                NSInteger level = [[_personMessageData valueForKey:@"level"] integerValue];
                
                VView.image = [UIImage imageNamed:Vs[lx][level - 1]];
                [bgView addSubview:VView];
                
                UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 25, 180 + 17.5, 15, 15)];
                leaderView.image = [UIImage imageNamed:@"lead"];
                [bgView addSubview:leaderView];
                
                UIButton *chooseHead = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseHead.frame = CGRectMake(0, 180, KScreenWidth, 50);
                [chooseHead addTarget:self action:@selector(showV) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:chooseHead];
            }
        }
        
        titleLabel.text = array[i];
        [bgView addSubview:titleLabel];
        [bgView addSubview:lineView];
    }
    
    scrollView.contentSize = KScreenHeight - 64 > 300 ? CGSizeMake(KScreenWidth, KScreenHeight - 64 + 10) : CGSizeMake(KScreenWidth, 300);
}

#pragma mark - 点击头像
- (void)changeHeaderView
{
    UserHeaderViewViewController *UserHeaderViewVC = [[UserHeaderViewViewController alloc] init];
    [self.navigationController pushViewController:UserHeaderViewVC animated:YES];
}

- (void)showV
{
    showVViewController *showVVC = [[showVViewController alloc] init];
    [self.navigationController pushViewController:showVVC animated:YES];
}

@end
