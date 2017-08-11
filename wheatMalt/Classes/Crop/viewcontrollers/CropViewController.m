//
//  CropViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CropViewController.h"
#import "WriteCropViewController.h"
@interface CropViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_ShowIntroduceScrollView;

}
@end

@implementation CropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    [self NavTitleWithText:@"吐槽"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"writeCrop" highImageName:@"writeCrop" target:self action:@selector(writeCrop)];
    
    
    [self drawCropUI];
    //判断是否显示升级日志
    [self Todeterminewhethertodisplaytheupgradelog];
    
    //取出申请人数量
    [self getSQRNum];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求
/**
 获取申请人数量
 */
- (void)getSQRNum
{
    [HTTPRequestTool requestMothedWithPost:wheatMalt_GetSQRNum params:nil Token:YES success:^(id responseObject) {
        NSString *sqrNum = [NSString stringWithFormat:@"%@",responseObject[@"sqrs"]];
        NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
        [userdefalut setObject:sqrNum forKey:wheatMalt_SQRNum];
        [userdefalut synchronize];
    } failure:^(NSError *error) {
        
    } Target:nil];
}


#pragma mark - 绘制UI
- (void)drawCropUI
{
    NoDataView *noCropFunctionView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) type:PlaceholderViewTypeNoFunction delegate:nil];
    [self.view addSubview:noCropFunctionView];
}

#pragma mark - 按钮事件
/**
 麦讯
 */
- (void)writeCrop
{
    WriteCropViewController *WriteCropVC = [[WriteCropViewController alloc] init];
    [self.navigationController pushViewController:WriteCropVC animated:YES];
}


#pragma mark - 判断是否显示升级日志
- (void)Todeterminewhethertodisplaytheupgradelog
{
    [HTTPRequestTool requestMothedWithPost:wheatMalt_GetEdition params:nil Token:YES success:^(id responseObject) {
        NSString *userEidtion = responseObject[@"appver"];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *projectEidtion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        if (![userEidtion isEqualToString:projectEidtion]) {
            [self showNeedShowIntroduce];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //刷新iOS更新参数
                [self resetiOSShowIntroduceWithString:projectEidtion];
            });
        }
    } failure:^(NSError *error) {
        
    } Target:nil];

}

//刷新iOS更新参数
- (void)resetiOSShowIntroduceWithString:(NSString *)string
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:string forKey:@"appver"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_ResetEdition params:params Token:YES success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        
    } Target:nil];
}


- (void)showNeedShowIntroduce
{
    _ShowIntroduceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _ShowIntroduceScrollView.delegate = self;
    _ShowIntroduceScrollView.pagingEnabled = YES;
    _ShowIntroduceScrollView.showsHorizontalScrollIndicator = NO;
    _ShowIntroduceScrollView.showsVerticalScrollIndicator = NO;
    _ShowIntroduceScrollView.bounces = NO;
    _ShowIntroduceScrollView.backgroundColor = [UIColor clearColor];
    _ShowIntroduceScrollView.contentSize = CGSizeMake(KScreenWidth * 4, KScreenHeight);
    
    for (int i = 0; i < 3; i++) {
        UIImageView *introduceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight)];
        NSString *name = [NSString stringWithFormat:@"intoduce_%d", i];
        introduceImageView.image = [UIImage imageNamed:name];
        [_ShowIntroduceScrollView addSubview:introduceImageView];
        
        UIButton *cancleShow = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleShow.frame = CGRectMake((KScreenWidth - 60) + KScreenWidth * i, 30, 30, 30);
        [cancleShow setImage:[UIImage imageNamed:@"x_1"] forState:UIControlStateNormal];
        [cancleShow addTarget:self action:@selector(cancleshow) forControlEvents:UIControlEventTouchUpInside];
        [_ShowIntroduceScrollView addSubview:cancleShow];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:_ShowIntroduceScrollView];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_ShowIntroduceScrollView]) {
        float offset = scrollView.contentOffset.x;
        offset = offset / KScreenWidth;
        if (offset == 3) {
            [self cancleshow];
        }
    }
}


#pragma mark - 事件
/**
 隐藏版本介绍
 */
- (void)cancleshow
{
    [_ShowIntroduceScrollView removeFromSuperview];
}

@end
