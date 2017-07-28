//
//  MyhomeViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyhomeViewController.h"
#import "PendingPersonsViewController.h"
#import "TouchView.h"
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPersonInCharge:) name:@"addPersonInCharge" object:nil];
    
    self.topViewArr = [NSMutableArray array];
    self.bottomViewArr = [NSMutableArray array];
    
    self.topDataSource = [NSMutableArray array];
    self.bottomDataSource = [NSMutableArray array];
    

    for (int i = 0; i < myhomeprinceData.count; i++) {
        NSDictionary *dic = myhomeprinceData[i];
        ChannelUnitModel *channelModel = [[ChannelUnitModel alloc] init];
        channelModel.name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
        channelModel.cid = [NSString stringWithFormat:@"%d", i];
        channelModel.isTop = 0;
        channelModel.Rebate = 0.6;
        [_topDataSource addObject:channelModel];
    }
    for (int i = 0; i < myhomeunprinceData.count; i++) {
        NSDictionary *dic = myhomeunprinceData[i];
        ChannelUnitModel *channelModel = [[ChannelUnitModel alloc] init];
        channelModel.name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
        channelModel.cid = [NSString stringWithFormat:@"%d", i];
        channelModel.isTop = i + 2;
        [_bottomDataSource addObject:channelModel];
    }

    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configUI{
    [self NavTitleWithText:@"麦圈"];
    
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
- (void) reconfigTopView
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
        [self.scrollView bringSubviewToFront:touchView];
        
        //获取点击view的位置
        [self.bottomViewArr insertObject:touchView atIndex:0];
        [self.topViewArr removeObject:touchView];
        //为了安全, 加判断
        if (index < self.topDataSource.count) {
            ChannelUnitModel *cModel = self.topDataSource[index];
            touchView.warningLabel.hidden = NO;
            //标记
            cModel.isTop = 1;
            touchView.warningLabel.text = [NSString stringWithFormat:@"%ld",(long)cModel.isTop];
            
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
    }];
    UIAlertAction *changerateAction = [UIAlertAction actionWithTitle:@"改变返利点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _myRebate = [[self.topDataSource[index] valueForKey:@"Rebate"] doubleValue];
        
        [self ShowchangePersonInChargeOfRebateView];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:changerateAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 从下到上
-(void)bottomTapAct:(UITapGestureRecognizer *)tap{
    TouchView *touchView = (TouchView *)tap.view;
    NSInteger index = [self.bottomViewArr indexOfObject:touchView];

    PendingPersonsViewController *PendingPersonsVC = [[PendingPersonsViewController alloc] init];
    PendingPersonsVC.touchView = touchView;
    PendingPersonsVC.prince = self.bottomDataSource[index].name;

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
        
        model.isTop = 0;
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleRebate)];
    [_RebatebgView addGestureRecognizer:tap];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 250) / 2, (KScreenHeight - 120)/ 2, 250, 120)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 15;
    [_RebatebgView addSubview:view];
    
    UIButton *cutBT = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBT.frame = CGRectMake(0, 0, 80, 70);
    cutBT.titleLabel.font = [UIFont systemFontOfSize:24];
    [cutBT setTitle:@"-" forState:UIControlStateNormal];
    cutBT.tag = 53100;
    [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    [cutBT addTarget:self action:@selector(cutRebate) forControlEvents:UIControlEventTouchUpInside];
    cutBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [view addSubview:cutBT];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 70, 70)];
    _textField.font = [UIFont systemFontOfSize:24];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.text = [self formatFloat:_myRebate];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.tag = 53101;
    _textField.delegate = self;
    [view addSubview:_textField];
    
    UIButton *addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addBT.frame = CGRectMake(170, 0, 80, 70);
    [addBT setTitle:@"+" forState:UIControlStateNormal];
    addBT.titleLabel.font = [UIFont systemFontOfSize:24];
    addBT.tag = 53102;
    addBT.userInteractionEnabled = NO;
    [addBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
    [addBT addTarget:self action:@selector(addRebate) forControlEvents:UIControlEventTouchUpInside];
    addBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [view addSubview:addBT];
    
    UIView *lineVIew = [BasicControls drawLineWithFrame:CGRectMake(0, 69.5, KScreenWidth, .5)];
    [view addSubview:lineVIew];
    
    UIButton *cancleBT = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBT.frame = CGRectMake(0, 70, 124.5, 50);
    [cancleBT setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBT addTarget:self action:@selector(cancleRebate) forControlEvents:UIControlEventTouchUpInside];
    cancleBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [view addSubview:cancleBT];
    
    UIView *lineVIew1 = [BasicControls drawLineWithFrame:CGRectMake(124.5, 70, KScreenWidth, 50)];
    [view addSubview:lineVIew1];
    
    UIButton *sureBT = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBT.frame = CGRectMake(125, 70, 125, 50);
    [sureBT setBackgroundColor:[UIColor whiteColor]];
    [sureBT setTitle:@"确定" forState:UIControlStateNormal];
    [sureBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBT addTarget:self action:@selector(sureRebate) forControlEvents:UIControlEventTouchUpInside];
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
    UIButton *cutBT = (UIButton *)[_RebatebgView viewWithTag:53100];
    UIButton *addBT = (UIButton *)[_RebatebgView viewWithTag:53102];
    if (_myRebate == 0) {
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
    if (_myRebate == myRebate) {
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
- (void)sureRebate
{
    if (![self isPureFloat:_textField.text]) {
        NSString *warningText = [NSString stringWithFormat:@"请输入0-%.1f数字",myRebate];
        [BasicControls showAlertWithMsg:warningText addTarget:self];
        _myRebate = 0.6;
        _textField.text = [self formatFloat:_myRebate];
        return;
    }
    if ([_textField.text doubleValue] > myRebate || [_textField.text doubleValue] < 0) {
        NSString *warningText = [NSString stringWithFormat:@"请输入0-%.1f数字",myRebate];
        [BasicControls showAlertWithMsg:warningText addTarget:self];
        _myRebate = 0.6;
        _textField.text = [self formatFloat:_myRebate];
        return;
    }
    
    [_RebatebgView removeFromSuperview];
    
    [BasicControls showMessageWithText:@"设置成功" Duration:2];
    
}

/**
 取消设置返利比
 */
- (void)cancleRebate
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



@end
