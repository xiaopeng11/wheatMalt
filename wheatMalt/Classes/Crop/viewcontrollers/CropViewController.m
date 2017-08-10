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
//    [self Todeterminewhethertodisplaytheupgradelog];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefault objectForKey:wheatMalt_UserMessage];
    NSString *banben = [userMessage valueForKey:@"iosbbh"];
    NSString *release = [userdefault objectForKey:wheatMalt_Edition];
    if (banben.length == 0) {
        //升级提示
        [self showNeedShowIntroduce];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //刷新iOS更新参数
            [self resetiOSShowIntroduceWithString:release];
        });
    } else {
        NSArray *banbenarrayed = [banben componentsSeparatedByString:@"."];
        NSArray *releasearrayed = [release componentsSeparatedByString:@"."];
        
        NSString *banbenVersion = [NSString stringWithFormat:@"%@%@",banbenarrayed[1],banbenarrayed[2]];
        NSString *releaseVersion = [NSString stringWithFormat:@"%@%@",releasearrayed[1],releasearrayed[2]];
        if ([banbenVersion longLongValue] != [releaseVersion longLongValue]) {
            //升级提示
            [self showNeedShowIntroduce];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //刷新iOS更新参数
                [self resetiOSShowIntroduceWithString:release];
            });
        }
    }
}

//刷新iOS更新参数
- (void)resetiOSShowIntroduceWithString:(NSString *)string
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    [params setObject:string forKey:@"bbh"];
    [params setObject:@"ios" forKey:@"cztype"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_ResetEdition params:params Token:YES success:^(id responseObject) {
        NSMutableDictionary *userMessageed = [NSMutableDictionary dictionaryWithDictionary:[userdefalut objectForKey:wheatMalt_UserMessage]];
        [userMessageed setObject:string forKey:@"iosbbh"];
        [userdefalut setObject:userMessageed forKey:wheatMalt_UserMessage];
        [userdefalut synchronize];
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
