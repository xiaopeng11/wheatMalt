//
//  MyhomeViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyhomeViewController.h"
#import "PendingPersonsViewController.h"
#import "UnSettledProfitViewController.h"
#import "TouchView.h"

#import "MyhomeModel.h"
//左右边距
#define EdgeX 10
#define TopEdge 10

//每行频道的个数
#define ButtonCountOneRow 2
#define ButtonHeight (ButtonWidth / 3)
#define LocationWidth (KScreenWidth - EdgeX * 2)
#define ButtonWidth (LocationWidth / ButtonCountOneRow)

#define TitleSize 16.0
#define EditTextSize 14.0
@interface MyhomeViewController ()<UITextFieldDelegate>
{
    CGPoint _oldCenter;
    NSInteger _moveIndex;
    
    UIView *_RebatebgView;
    UITextField *_textField;
    
    double _myRebate; //我的返利点
    double _UserRebate;  //登陆者的返利点
    
    ChannelUnitModel *_nowModel;

}


@property(nonatomic,strong)NSMutableArray<ChannelUnitModel *> *topDataSource;
@property(nonatomic,strong)NSMutableArray<ChannelUnitModel *> *bottomDataSource;

@property (nonatomic, strong) NSMutableArray<TouchView *> *topViewArr;
@property (nonatomic, strong) NSMutableArray<TouchView *> *bottomViewArr;


@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, assign) CGFloat bottomHeight;

@property(nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) TouchView *clearView;
@property (nonatomic, strong) ChannelUnitModel *placeHolderModel;
@property (nonatomic, strong) ChannelUnitModel *touchingModel;

@property (nonatomic, strong) ChannelUnitModel *initialIndexModel;
@property (nonatomic, strong) TouchView *initalTouchView;
@property (nonatomic, assign) NSInteger locationIndex;
@end

@implementation MyhomeViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)initWithTopDataSource:(NSArray<ChannelUnitModel *> *)topDataArr andBottomDataSource:(NSArray<ChannelUnitModel *> *)bottomDataSource andInitialIndex:(NSInteger)initialIndex{
    if (self = [super init]) {
        self.topDataSource = [NSMutableArray arrayWithArray:topDataArr];
        self.bottomDataSource = [NSMutableArray arrayWithArray:bottomDataSource];
        self.locationIndex = initialIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self NavTitleWithText:@"麦圈"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPersonInCharge:) name:@"addPersonInCharge" object:nil];
    
    self.topViewArr = [NSMutableArray array];
    self.bottomViewArr = [NSMutableArray array];
    
    self.topDataSource = [NSMutableArray array];
    self.bottomDataSource = [NSMutableArray array];
    
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefalut objectForKey:wheatMalt_UserMessage];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc ]init];
    [nf setMaximumIntegerDigits:1];
    NSNumber *number = [nf numberFromString:[NSString stringWithFormat:@"%@",[userMessage valueForKey:@"fd"]]];
    _UserRebate = [number doubleValue];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.topViewArr.count != 0) {
        [self.topViewArr removeAllObjects];
    }
    if (self.bottomViewArr.count != 0) {
        [self.bottomViewArr removeAllObjects];
    }
    if (self.topDataSource.count != 0) {
        [self.topDataSource removeAllObjects];
    }
    if (self.bottomDataSource.count != 0) {
        [self.bottomDataSource removeAllObjects];
    }
    
    if (_scrollView != nil) {
        [_scrollView removeFromSuperview];
    }
    [self getCircleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 获取数据
- (void)getCircleData
{
    [HTTPRequestTool requestMothedWithPost:wheatMalt_Myhome params:nil Token:YES success:^(id responseObject) {
        NSMutableArray *totalData = [MyhomeModel mj_keyValuesArrayWithObjectArray:responseObject[@"List"]];
        NSMutableArray *topdata = [NSMutableArray array];
        NSMutableArray *bottomdata = [NSMutableArray array];
        for (NSDictionary *dic in totalData) {
            if ([[dic valueForKey:@"fzrdm"] intValue] == 0) {
                [bottomdata addObject:dic];
            } else {
                [topdata addObject:dic];
            }
        }
        for (int i = 0; i < topdata.count; i++) {
            NSDictionary *dic = topdata[i];
            NSArray *sqList = [dic valueForKey:@"sqList"];
            ChannelUnitModel *channelModel = [[ChannelUnitModel alloc] init];
            channelModel.name = [NSString stringWithFormat:@"%@(%@)", [dic valueForKey:@"name"],[dic valueForKey:@"fzrname"]];
            channelModel.cid = [NSString stringWithFormat:@"%d", i];
            channelModel.personid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"fzrdm"]];
            channelModel.isTop = sqList.count;
            channelModel.fd = [[dic valueForKey:@"fd"] doubleValue];
            channelModel.qqlist = [dic valueForKey:@"sqList"];
            channelModel.Rebate = [[dic valueForKey:@"fd"] doubleValue];
            [_topDataSource addObject:channelModel];
        }
        for (int i = 0; i < bottomdata.count; i++) {
            NSDictionary *dic = bottomdata[i];
            NSArray *sqList = [dic valueForKey:@"sqList"];
            
            ChannelUnitModel *channelModel = [[ChannelUnitModel alloc] init];
            channelModel.name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
            channelModel.cid = [NSString stringWithFormat:@"%d", i];
            channelModel.personid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"fzrdm"]];
            channelModel.fd = [[dic valueForKey:@"fd"] doubleValue];
            channelModel.isTop = sqList.count;
            channelModel.qqlist = [dic valueForKey:@"sqList"];
            [_bottomDataSource addObject:channelModel];
        }
        [self configUI];

    } failure:^(NSError *error) {
    } Target:self];
    
}


#pragma mark - 绘制UI
-(void)configUI{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    //上面的标题
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, TopEdge, KScreenWidth, 20)];
    self.topLabel.text = @"已启用区域";
    self.topLabel.font = [UIFont boldSystemFontOfSize:TitleSize];
    [self.scrollView addSubview:self.topLabel];
    
    for (int i = 0; i < self.topDataSource.count; ++i) {
        TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(5 + i % ButtonCountOneRow * ButtonWidth, TopEdge + 30 + i/ButtonCountOneRow * ButtonHeight, ButtonWidth, ButtonHeight)];
        touchView.userInteractionEnabled = YES;
        
        ChannelUnitModel *model = self.topDataSource[i];
        touchView.contentLabel.text = model.name;

        touchView.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTapAct:)];
        [touchView addGestureRecognizer:touchView.tap];
        
        [self.scrollView addSubview:touchView];
        [self.topViewArr addObject:touchView];
    }
    
    //下面的标题
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,TopEdge + 30 + 25 + self.topHeight, KScreenWidth, 20)];
    self.bottomLabel.textAlignment = NSTextAlignmentLeft;
    self.bottomLabel.text = @"未开启的区域";
    self.bottomLabel.font = [UIFont boldSystemFontOfSize:TitleSize];
    [self.scrollView addSubview:self.bottomLabel];
    
    CGFloat startHeight = self.bottomLabel.frame.origin.y + 20 + 10;
    
    for (int i = 0; i < self.bottomDataSource.count; ++i) {
        TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(EdgeX + i%ButtonCountOneRow * ButtonWidth, startHeight + i/ButtonCountOneRow * ButtonHeight, ButtonWidth, ButtonHeight)];
        ChannelUnitModel *model = self.bottomDataSource[i];
        touchView.contentLabel.text = model.name;
        touchView.userInteractionEnabled = YES;
        touchView.contentLabel.textAlignment = NSTextAlignmentCenter;
        if (model.isTop > 0) {
            touchView.warningLabel.hidden = NO;
            touchView.warningLabel.text = [NSString stringWithFormat:@"%ld",(long)model.isTop];
        }
        [self.scrollView addSubview:touchView];
        [self.bottomViewArr addObject:touchView];
        
        touchView.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomTapAct:)];
        [touchView addGestureRecognizer:touchView.tap];
    }

    self.scrollView.contentSize = 85 + self.topHeight + self.bottomHeight + ButtonHeight <= KScreenHeight - 64 ? CGSizeMake(KScreenWidth, KScreenHeight) : CGSizeMake(KScreenWidth, 85 + self.topHeight + self.bottomHeight + ButtonHeight);
}
#pragma mark - 重新布局下边
- (void) reconfigBottomView
{
    CGFloat startHeight = self.bottomLabel.frame.origin.y + 20 + 10;
    for (int i = 0; i < self.bottomViewArr.count; ++i) {
        TouchView *touchView = self.bottomViewArr[i];
        touchView.frame = CGRectMake(EdgeX + i%ButtonCountOneRow * ButtonWidth, startHeight + i/ButtonCountOneRow * ButtonHeight, ButtonWidth, ButtonHeight);
    }
}
#pragma mark - 重新布局上边
- (void)reconfigTopView
{
    for (int i = 0; i < self.topViewArr.count; ++i) {
        TouchView *touchView = self.topViewArr[i];
        touchView.frame = CGRectMake(EdgeX + i%ButtonCountOneRow * ButtonWidth, TopEdge + 30 + i/ButtonCountOneRow*ButtonHeight, ButtonWidth, ButtonHeight);
    }
}

#pragma mark - 从上到下
-(void)topTapAct:(UITapGestureRecognizer *)tap{
    TouchView *touchView = (TouchView *)tap.view;
    NSInteger index = [self.topViewArr indexOfObject:touchView];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"移除负责人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *sureRemovePerson = [UIAlertController alertControllerWithTitle:nil message:@"确定移除该区域负责人？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureRemoveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:self.topDataSource[index].personid forKey:@"id"];
            [HTTPRequestTool requestMothedWithPost:wheatMalt_MyhomeRemovePerson params:params Token:YES success:^(id responseObject) {
                [self.scrollView bringSubviewToFront:touchView];
                
                //获取点击view的位置
                [self.bottomViewArr insertObject:touchView atIndex:0];
                [self.topViewArr removeObject:touchView];
                //为了安全, 加判断
                if (index < self.topDataSource.count) {
                    ChannelUnitModel *cModel = self.topDataSource[index];
                    //标记
                    if (cModel.isTop == 0) {
                        touchView.warningLabel.hidden = YES;
                    } else {
                        touchView.warningLabel.hidden = NO;
                        touchView.warningLabel.text = [NSString stringWithFormat:@"%ld",(long)cModel.isTop];
                    }
                    
                    //移除负责人
                    cModel.name = [cModel.name substringWithRange:NSMakeRange(0, [cModel.name rangeOfString:@"("].location)];
                    touchView.contentLabel.text = cModel.name;
                    
                    [self.bottomDataSource insertObject:cModel atIndex:0];
                    [self.topDataSource removeObjectAtIndex:index];
                }
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.bottomLabel.frame = CGRectMake(10, TopEdge + 25 + 30 + self.topHeight, 200, 20);
                    [self reconfigTopView];
                    [self reconfigBottomView];
                }];
                
                [touchView.tap removeTarget:self action:@selector(topTapAct:)];
                [touchView.tap addTarget:self action:@selector(bottomTapAct:)];
                
            } failure:^(NSError *error) {
                
            } Target:self];

        }];
        
        UIAlertAction *cancleRemoveAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [sureRemovePerson addAction:sureRemoveAction];
        [sureRemovePerson addAction:cancleRemoveAction];
        [self presentViewController:sureRemovePerson animated:YES completion:nil];
 
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"改变返利点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _nowModel = self.topDataSource[index];
        _myRebate = _nowModel.fd;
        [self ShowchangePersonInChargeOfRebateView];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"结算收益" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UnSettledProfitViewController *UnSettledProfitVC = [[UnSettledProfitViewController alloc] init];
        [self.navigationController pushViewController:UnSettledProfitVC animated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 从下到上
-(void)bottomTapAct:(UITapGestureRecognizer *)tap{
    TouchView *touchView = (TouchView *)tap.view;
    NSInteger index = [self.bottomViewArr indexOfObject:touchView];

    PendingPersonsViewController *PendingPersonsVC = [[PendingPersonsViewController alloc] init];
    PendingPersonsVC.touchView = touchView;
    PendingPersonsVC.quyu = self.bottomDataSource[index].name;
    PendingPersonsVC.pendingList = [self.bottomDataSource[index].qqlist mutableCopy];
    [self.navigationController pushViewController:PendingPersonsVC animated:YES];
}

#pragma mark - 用于占位的透明label
-(TouchView *)clearView{
    if (!_clearView) {
        _clearView = [[TouchView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ButtonWidth - 10, ButtonHeight - 10)];
        imageView.image = [UIImage imageNamed:@"lanmu2"];
        [_clearView addSubview:imageView];
        _clearView.backgroundColor = [UIColor clearColor];
        [_clearView.contentLabel removeFromSuperview];
    }
    return _clearView;
}
#pragma mark - 用于占位的model, 由于计算位置有问题
-(ChannelUnitModel *)placeHolderModel{
    if (!_placeHolderModel) {
        _placeHolderModel = [[ChannelUnitModel alloc] init];
    }
    return _placeHolderModel;
}
#pragma mark - 充当计算属性使用
-(CGFloat)topHeight{
    if (self.topDataSource.count < ButtonCountOneRow) {
        return ButtonHeight;
    }else{
        return ((self.topDataSource.count - 1)/ButtonCountOneRow + 1) * ButtonHeight;
    }
}
-(CGFloat)bottomHeight{
    if (self.bottomDataSource.count < ButtonCountOneRow) {
        return ButtonHeight;
    }else{
        return ((self.bottomDataSource.count - 1)/ButtonCountOneRow + 1) * ButtonHeight;;
    }
}

#pragma mark - 通知事件
- (void)addPersonInCharge:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    TouchView *touchView = (TouchView *)[dic valueForKey:@"touchView"];
    NSInteger index = [self.bottomViewArr indexOfObject:touchView];
    ChannelUnitModel *model = self.bottomDataSource[index];
    
    [touchView.tap removeTarget:self action:@selector(bottomTapAct:)];
    [touchView.tap addTarget:self action:@selector(topTapAct:)];
    
    touchView.warningLabel.hidden = YES;
    [self.scrollView bringSubviewToFront:touchView];
    [self.topViewArr addObject:touchView];
    [self.bottomViewArr removeObject:touchView];
    //为了安全, 加判断
    if (index < self.bottomDataSource.count) {
        
        model.name = [NSString stringWithFormat:@"%@(%@)",model.name,[dic valueForKey:@"name"]];
        touchView.contentLabel.text = model.name;
        
        [self.topDataSource addObject:model];
        [self.bottomDataSource removeObject:model];
    }
    
    NSInteger i = self.topViewArr.count - 1;
    [UIView animateWithDuration:0.3 animations:^{
        touchView.frame = CGRectMake(EdgeX + i%ButtonCountOneRow * ButtonWidth, TopEdge + 30 + i/ButtonCountOneRow*ButtonHeight, ButtonWidth, ButtonHeight);
        self.bottomLabel.frame = CGRectMake(10, TopEdge + 25 + 30 + self.topHeight, 200, 20);
        [self reconfigBottomView];
    }];
}

#pragma mark - 返利点
/**
 改变返利点UI
 
 */
- (void)ShowchangePersonInChargeOfRebateView
{
    _RebatebgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _RebatebgView.backgroundColor = [UIColor colorWithRed:(149.0f / 255.0f) green:(149.0f / 255.0f) blue:(149.0f / 255.0f) alpha:0.5f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MyhomecancleRebate:)];
    [_RebatebgView addGestureRecognizer:tap];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 250) / 2, (KScreenHeight - 120)/ 2, 250, 120)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 15;
    view.tag = 52111;
    [_RebatebgView addSubview:view];
    
    UIButton *cutBT = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBT.frame = CGRectMake(0, 0, 80, 70);
    cutBT.titleLabel.font = [UIFont systemFontOfSize:24];
    [cutBT setTitle:@"-" forState:UIControlStateNormal];
    cutBT.tag = 53110;
    if (_nowModel.fd < 0.01) {
        cutBT.userInteractionEnabled = NO;
        [cutBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
    } else {
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    }
    [cutBT addTarget:self action:@selector(cutRebate) forControlEvents:UIControlEventTouchUpInside];
    cutBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [view addSubview:cutBT];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 70, 70)];
    _textField.font = [UIFont systemFontOfSize:24];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.text = [self formatFloat:_nowModel.fd];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(MyhometextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:_textField];
    
    UIButton *addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addBT.frame = CGRectMake(170, 0, 80, 70);
    [addBT setTitle:@"+" forState:UIControlStateNormal];
    addBT.titleLabel.font = [UIFont systemFontOfSize:24];
    addBT.tag = 53112;
    if (_nowModel.fd > _UserRebate) {
        addBT.userInteractionEnabled = NO;
        [addBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
    } else {
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    }
    [addBT addTarget:self action:@selector(addRebate) forControlEvents:UIControlEventTouchUpInside];
    addBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [view addSubview:addBT];
    
    UIView *lineVIew = [BasicControls drawLineWithFrame:CGRectMake(0, 69.5, KScreenWidth, .5)];
    [view addSubview:lineVIew];
    
    UIButton *cancleBT = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBT.frame = CGRectMake(0, 70, 124.5, 50);
    [cancleBT setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBT addTarget:self action:@selector(MyhomecancleRebate) forControlEvents:UIControlEventTouchUpInside];
    cancleBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [view addSubview:cancleBT];
    
    UIView *lineVIew1 = [BasicControls drawLineWithFrame:CGRectMake(124.5, 70, .5, 50)];
    [view addSubview:lineVIew1];
    
    UIButton *sureBT = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBT.frame = CGRectMake(125, 70, 125, 50);
    [sureBT setTitle:@"确定" forState:UIControlStateNormal];
    [sureBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBT addTarget:self action:@selector(MyhomesureRebate) forControlEvents:UIControlEventTouchUpInside];
    sureBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [view addSubview:sureBT];
    
    // 设置时间和动画效果
    [[UIApplication sharedApplication].keyWindow addSubview:_RebatebgView];
    
    [self animationAlert:view];
}

-(void)animationAlert:(UIView *)view
{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

#pragma mark - 按钮
/**
 减少
 */
- (void)cutRebate
{
    UIButton *cutBT = (UIButton *)[_RebatebgView viewWithTag:53110];
    UIButton *addBT = (UIButton *)[_RebatebgView viewWithTag:53112];
    if (_myRebate < 0.01) {
        cutBT.userInteractionEnabled = NO;
        addBT.userInteractionEnabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
    } else {
        cutBT.userInteractionEnabled = YES;
        addBT.userInteractionEnabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    }
    _myRebate -= 0.01;
    _textField.text = [self formatFloat:_myRebate];
    
}

/**
 增加
 */
- (void)addRebate
{
    UIButton *cutBT = (UIButton *)[_RebatebgView viewWithTag:53100];
    UIButton *addBT = (UIButton *)[_RebatebgView viewWithTag:53102];
    if (_myRebate == _UserRebate) {
        cutBT.userInteractionEnabled = YES;
        addBT.userInteractionEnabled = NO;
        [addBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    } else {
        cutBT.userInteractionEnabled = YES;
        addBT.userInteractionEnabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    }
    
    _myRebate += 0.01;
    _textField.text = [self formatFloat:_myRebate];
}


/**
 确定返利比
 */
- (void)MyhomesureRebate
{
    if (![self isPureFloat:_textField.text]) {
        NSString *warningText = [NSString stringWithFormat:@"请输入0-%.1f数字",_UserRebate];
        [BasicControls showAlertWithMsg:warningText addTarget:self];
        _myRebate = _UserRebate;
        _textField.text = [self formatFloat:_myRebate];
        return;
    }
    if ([_textField.text doubleValue] > _UserRebate || [_textField.text doubleValue] < 0) {
        NSString *warningText = [NSString stringWithFormat:@"请输入0-%.1f数字",_UserRebate];
        [BasicControls showAlertWithMsg:warningText addTarget:self];
        _myRebate = _UserRebate;
        _textField.text = [self formatFloat:_myRebate];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%@",_nowModel.personid] forKey:@"id"];
    [param setObject:_textField.text forKey:@"fd"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_MyhomeChangeFD params:param Token:YES success:^(id responseObject) {
        [BasicControls showMessageWithText:@"设置成功" Duration:2];
        NSInteger index = [self.topDataSource indexOfObject:_nowModel];
        _nowModel.fd = [_textField.text doubleValue];
        NSLog(@"%f",_nowModel.fd);
        [self.topDataSource replaceObjectAtIndex:index withObject:_nowModel];
        
        [_RebatebgView removeFromSuperview];

    } failure:^(NSError *error) {
        
    } Target:self];

}


/**
 点击消失设置返利点
 
 @param tap 对象
 */
- (void)MyhomecancleRebate:(UITapGestureRecognizer *)tap
{
    UIView *view = [_RebatebgView viewWithTag:52111];
    if(!CGRectContainsPoint(_RebatebgView.frame, [tap locationInView:view])) {
        [self MyhomecancleRebate];;
    };
}

/**
 取消设置返利比
 */
- (void)MyhomecancleRebate
{
    [_RebatebgView removeFromSuperview];
}

/**
 确定是浮点型
 
 @param string 字符
 @return 是/否
 */
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


/**
 保留存在的小数点
 */
- (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length > 0) {
        unichar single0 = [string characterAtIndex:0];//当前输入第1个字符
        if ((single0 >='0' && single0 <='9') || single0=='.') {
            if (textField.text.length == 0) {
                unichar single0 = [string characterAtIndex:0];//当前输入第1个字符
                if (single0 == '0') {
                    if (string.length > 1) {
                        unichar single1=[string characterAtIndex:1];//当前输入第2个字符
                        if (single1 == '.') {
                            if (string.length > 4) {
                                [BasicControls showAlertWithMsg:@"只能精确到小数点两位" addTarget:self];
                                return NO;
                            } else {
                                return YES;
                            }
                        } else {
                            [BasicControls showAlertWithMsg:@"请输入正确的返利点" addTarget:self];
                            return NO;
                        }
                    } else {
                        return YES;
                    }
                } else {
                    [BasicControls showAlertWithMsg:@"请输入正确的返利点" addTarget:self];
                    return NO;
                }
            } else {
                if (textField.text.length == 4) {
                    if (string.length > 0) {
                        [BasicControls showAlertWithMsg:@"只能精确到小数点两位" addTarget:self];
                        return NO;
                    } else {
                        return YES;
                    }
                } else {
                    return YES;
                }
            }
            
        } else {
            [BasicControls showAlertWithMsg:@"只能输入数字" addTarget:self];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    
    return YES;
}

- (void)MyhometextFieldTextChange:(id)sender{
    UITextField *target=(UITextField*)sender;
    _myRebate = [target.text doubleValue];
    UIButton *cutBT = (UIButton *)[_RebatebgView viewWithTag:53110];
    UIButton *addBT = (UIButton *)[_RebatebgView viewWithTag:53112];
    if (_myRebate > _UserRebate) {
        NSString *warningText = [NSString stringWithFormat:@"您可指定的最大返利点为%.2f",_UserRebate];
        [BasicControls showAlertWithMsg:warningText addTarget:self];
        _myRebate = _UserRebate;
        _textField.text = [self formatFloat:_myRebate];
        
        cutBT.enabled = YES;
        addBT.enabled = NO;
        [addBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    } else if (_myRebate == _UserRebate) {
        
        cutBT.enabled = YES;
        addBT.enabled = NO;
        [addBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    } else if (_myRebate < 0.01) {
        cutBT.enabled = NO;
        addBT.enabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
    } else {
        cutBT.enabled = YES;
        addBT.enabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    }
    
}



@end
