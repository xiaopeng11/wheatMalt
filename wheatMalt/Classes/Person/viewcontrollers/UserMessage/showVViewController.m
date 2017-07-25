//
//  showVViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "showVViewController.h"
#define showVWidth ((KScreenWidth - 81) / 3)
@interface showVViewController ()

@end

@implementation showVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawshowVUI];
    
//    [self getVData];
    
    [HTTPRequestTool requestMothedWithPost:wheatMalt_V params:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject[@"List"]);
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 绘制UI
- (void)drawshowVUI
{
    [self NavTitleWithText:@"V等级"];
    
    NSArray *Vs = @[@"V1_1",@"V1_2",@"V1_3",@"V2_1",@"V2_2",@"V2_3",@"V3_1",@"V3_2",@"V3_3",@"V0"];
    NSArray *values = @[@"10000-100000",@"100000-500000",@"500000-1000000",@"10000-100000",@"100000-500000",@"500000-1000000",@"10000-100000",@"100000-500000",@"500000-1000000",@"+∞"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    scrollView.backgroundColor = BaseBgColor;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50 + 500)];
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];
    
    NSArray *titles = @[@"部门",@"标志",@"贡献值"];
    NSArray *bumens = @[@"区域经理",@"商务部",@"研发部",@"总公司"];
    for (int i = 0; i < 10; i++) {
        if (i < 4) {
            //部门
            UILabel *bumenLabel = [[UILabel alloc] init];
            if (i < 3) {
                bumenLabel.frame = CGRectMake(0, 110 + 150 * i, showVWidth, 30);
            } else {
                bumenLabel.frame = CGRectMake(0, 510, showVWidth, 30);
            }
            bumenLabel.font = LargeFont;
            bumenLabel.textAlignment = NSTextAlignmentCenter;
            bumenLabel.text = bumens[i];
            [bgView addSubview:bumenLabel];
            if (i < 3) {
                //标题
                UILabel *titleLabel = [[UILabel alloc] init];
                if (i == 0) {
                    titleLabel.frame = CGRectMake(0, 0, showVWidth, 50);
                } else if (i == 1) {
                    titleLabel.frame = CGRectMake(showVWidth + .5, 0, 80, 50);
                } else if (i == 2) {
                    titleLabel.frame = CGRectMake(showVWidth + 80.5, 0, showVWidth * 2, 50);
                }
                titleLabel.font = [UIFont boldSystemFontOfSize:15];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.backgroundColor = TabbarColor;
                titleLabel.text = titles[i];
                [bgView addSubview:titleLabel];
                
                UIView *longline = [BasicControls drawLineWithFrame:CGRectMake(0, 200 + (150 * i), showVWidth, .5)];
                [bgView addSubview:longline];
            }
        }
        
        UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(showVWidth + 25.5, 60 + 50 * i, 30, 30)];
        levelImageView.image = [UIImage imageNamed:Vs[i]];
        [bgView addSubview:levelImageView];
        
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(showVWidth + 81, 60 + 50 * i, showVWidth * 2, 30)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.font = SmallFont;
        valueLabel.text = values[i];
        [bgView addSubview:valueLabel];
        
        
        if (i < 9) {
            UIView *shortline = [BasicControls drawLineWithFrame:CGRectMake(showVWidth + .5, 100 + (50 * i), KScreenWidth - showVWidth - .5, .5)];
            [bgView addSubview:shortline];
            if (i < 2) {
                UIView *lline = [BasicControls drawLineWithFrame:CGRectMake(showVWidth + (80.5 * i), 0, .5, 550)];
                [bgView addSubview:lline];
            }
        }
    }
    
    scrollView.contentSize = KScreenHeight - 64 > 550 ? CGSizeMake(KScreenWidth, KScreenHeight - 64 + 10) : CGSizeMake(KScreenWidth, 550);
}

@end
