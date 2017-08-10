//
//  ShareViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ShareViewController.h"
#import "EditShareViewViewController.h"

#import "ShareCollectionViewCell.h"
@interface ShareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_images;
    UICollectionView *_shareCollectionView;
}
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self NavTitleWithText:@"分享模板"];
    
    NoDataView *noCollectionCropView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) type:PlaceholderViewTypeNoFunction delegate:nil];
    [self.view addSubview:noCollectionCropView];
//    [self drawShareUI];
//    
//    [self getShareImageUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - 获取数据
- (void)getShareImageUI
{
    _images = [NSMutableArray array];
    
    for (int i = 0; i < 20; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *imagename = [NSString stringWithFormat:@"share_%d.jpg",(i % 4) + 1];
        [dic setObject:imagename forKey:@"imageName"];
        CGRect rect = CGRectMake(20, 300 + 50 * ((i % 4) + 1), KScreenWidth -40, 100);
        [dic setObject:[NSValue valueWithCGRect:rect] forKey:@"TFrect"];
        NSString *text = [NSString stringWithFormat:@"早上好_%d",(i % 4) + 1];
        [dic setObject:text forKey:@"text"];
        [_images addObject:dic];
    }
    [_shareCollectionView reloadData];
}

#pragma mark - 绘制UI
- (void)drawShareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake((KScreenWidth - 80) / 3, ((KScreenWidth - 80) / 3) * DeviceProportion);
    
    //2.初始化collectionView
    _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 40, KScreenHeight - 84) collectionViewLayout:layout];
    _shareCollectionView.backgroundColor = [UIColor clearColor];
    _shareCollectionView.showsVerticalScrollIndicator = NO;
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_shareCollectionView registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:@"SharecellId"];
    
    //4.设置代理
    _shareCollectionView.delegate = self;
    _shareCollectionView.dataSource = self;
    
    [self.view addSubview:_shareCollectionView];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareCollectionViewCell *cell = (ShareCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SharecellId" forIndexPath:indexPath];
    cell.dic = _images[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditShareViewViewController *EditShareViewVC = [[EditShareViewViewController alloc] init];
    EditShareViewVC.dic = _images[indexPath.row];
    [self.navigationController pushViewController:EditShareViewVC animated:YES];
}


@end
