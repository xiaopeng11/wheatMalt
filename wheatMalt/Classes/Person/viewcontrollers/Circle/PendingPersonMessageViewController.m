//
//  PendingPersonMessageViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PendingPersonMessageViewController.h"
#import "MyhomeViewController.h"

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface PendingPersonMessageViewController ()<UITextFieldDelegate>
{
    UIView *_RebatebgView;
    UITextField *_textField;
    
    double _myRebate; //我的返利点
    
    double _UserRebate;  //登陆者的返利点
}

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;
@end

@implementation PendingPersonMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefalut objectForKey:wheatMalt_UserMessage];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc ]init];
    [nf setMaximumIntegerDigits:1];
    NSNumber *number = [nf numberFromString:[NSString stringWithFormat:@"%@",[userMessage valueForKey:@"fd"]]];
    _myRebate = [number doubleValue];
    _UserRebate = [number doubleValue];
    
    [self NavTitleWithText:@"审核"];
    
    [self drawPendingPersonMessageUI];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawPendingPersonMessageUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = BaseBgColor;
    [scrollView addSubview:bgView];
    
    UIView *MessageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 80)];
    MessageBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:MessageBgView];
    
    UILabel *nameView = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 170) / 2, 20, 40, 40)];
    nameView.backgroundColor = HeaderBgColorArray[[[self.personMessage valueForKey:@"id"] intValue] % 10];
    nameView.textColor = [UIColor whiteColor];
    nameView.clipsToBounds = YES;
    nameView.layer.cornerRadius = 20;
    nameView.font = [UIFont systemFontOfSize:13];
    nameView.textAlignment = NSTextAlignmentCenter;
    nameView.text = [BasicControls returnLastNameWithNameString:[self.personMessage valueForKey:@"name"]];
    [MessageBgView addSubview:nameView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(((KScreenWidth - 170) / 2) + 50, 25, 120, 30)];
    phoneLabel.text = [self.personMessage valueForKey:@"phone"];
    [MessageBgView addSubview:phoneLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 50);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [MessageBgView addSubview:button];
    
    
    UIView *secondBgView = [[UIView alloc] init];
    secondBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:secondBgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 25)];
    titleLabel.text = @"自我评价";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [secondBgView addSubview:titleLabel];
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.numberOfLines = 0;
    [secondBgView addSubview:commentLabel];
    
    UIButton *checkBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBT setTitle:@"审核" forState:UIControlStateNormal];
    [checkBT setBackgroundColor:[UIColor greenColor]];
    [checkBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkBT addTarget:self action:@selector(ShowchangePersonInChargeOfRebateView) forControlEvents:UIControlEventTouchUpInside];
    checkBT.layer.cornerRadius = 35;
    [bgView addSubview:checkBT];
    
    
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小16号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = [UIFont systemFontOfSize:16].pointSize * 2;
    paraStyle01.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 5.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[self.personMessage valueForKey:@"comments"] attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    commentLabel.attributedText = attrText;
    
    CGFloat height = [commentLabel sizeThatFits:CGSizeMake(KScreenWidth - 20,0)].height;
    
    commentLabel.frame = CGRectMake(10, 25, KScreenWidth - 20, height);

    secondBgView.frame = CGRectMake(0, 100, KScreenWidth, 25 + height + 50);
    
    checkBT.frame = CGRectMake((KScreenWidth - 70) / 2, 100 + 25 + height + 50 + 30, 70, 70);
    
    bgView.frame = CGRectMake(0, 0, KScreenWidth, 100 + 25 + height + 50 + 30 + 70 + 20);
    scrollView.contentSize = bgView.height > KScreenHeight - 64 ? CGSizeMake(KScreenWidth, bgView.height) : CGSizeMake(KScreenWidth, KScreenHeight - 64);
}

#pragma mark - 拨打电话
- (void)call
{
    //判断是否有电话
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",[self.personMessage valueForKey:@"phone"]];
    if (phone.length == 4) {
        [BasicControls showAlertWithMsg:@"当前用户没有手机号码" addTarget:nil];
    } else {
        //打电话
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:^(BOOL success) {
            }];
        }

    }
}

#pragma mark - 返利点
/**
 改变返利点UI
 
 */
- (void)ShowchangePersonInChargeOfRebateView
{
    _RebatebgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _RebatebgView.backgroundColor = [UIColor colorWithRed:(149.0f / 255.0f) green:(149.0f / 255.0f) blue:(149.0f / 255.0f) alpha:0.5f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancleRebate:)];
    [_RebatebgView addGestureRecognizer:tap];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 250) / 2, (KScreenHeight - 120)/ 2, 250, 120)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 15;
    view.tag = 52101;
    [_RebatebgView addSubview:view];
    
    UIButton *cutBT = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBT.frame = CGRectMake(0, 0, 80, 70);
    cutBT.titleLabel.font = [UIFont systemFontOfSize:35];
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
    [_textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:_textField];
    
    UIButton *addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addBT.frame = CGRectMake(170, 0, 80, 70);
    [addBT setTitle:@"+" forState:UIControlStateNormal];
    addBT.titleLabel.font = [UIFont systemFontOfSize:35];
    addBT.tag = 53102;
    if (_myRebate == _UserRebate) {
        addBT.enabled = NO;
        [addBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
    } else {
        addBT.enabled = YES;
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
    [cancleBT addTarget:self action:@selector(cancleRebate) forControlEvents:UIControlEventTouchUpInside];
    cancleBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [view addSubview:cancleBT];
    
    UIView *lineVIew1 = [BasicControls drawLineWithFrame:CGRectMake(124.5, 70, .5, 50)];
    [view addSubview:lineVIew1];
    
    UIButton *sureBT = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBT.frame = CGRectMake(125, 70, 125, 50);
    [sureBT setTitle:@"确定" forState:UIControlStateNormal];
    [sureBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBT addTarget:self action:@selector(sureRebate) forControlEvents:UIControlEventTouchUpInside];
    sureBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [view addSubview:sureBT];
    
    // 设置时间和动画效果
    [[UIApplication sharedApplication].keyWindow addSubview:_RebatebgView];

    [self animationAlert:view];
}

#pragma mark - 按钮
/**
 减少
 */
- (void)cutRebate
{
    UIButton *cutBT = (UIButton *)[_RebatebgView viewWithTag:53100];
    UIButton *addBT = (UIButton *)[_RebatebgView viewWithTag:53102];
    if (_myRebate < 0.01) {
        cutBT.enabled = NO;
        addBT.enabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
    } else {
        cutBT.enabled = YES;
        addBT.enabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        _myRebate -= 0.01;
        _textField.text = [self formatFloat:_myRebate];
    }
}

/**
 增加
 */
- (void)addRebate
{
    UIButton *cutBT = (UIButton *)[_RebatebgView viewWithTag:53100];
    UIButton *addBT = (UIButton *)[_RebatebgView viewWithTag:53102];
    if (_myRebate == _UserRebate) {
        cutBT.enabled = YES;
        addBT.enabled = NO;
        [addBT setTitleColor:ButtonLColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
    } else {
        cutBT.enabled = YES;
        addBT.enabled = YES;
        [addBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        [cutBT setTitleColor:ButtonHColor forState:UIControlStateNormal];
        _myRebate += 0.01;
        _textField.text = [self formatFloat:_myRebate];
    }
}


/**
 确定返利比
 */
- (void)sureRebate
{
    if (![self isPureFloat:_textField.text]) {
        NSString *warningText = [NSString stringWithFormat:@"请输入0-%.2f数字",_UserRebate];
        [BasicControls showAlertWithMsg:warningText addTarget:self];
        _myRebate = _UserRebate;
        _textField.text = [self formatFloat:_myRebate];
        return;
    }
    if ([_textField.text doubleValue] > _UserRebate || [_textField.text doubleValue] < 0) {
        NSString *warningText = [NSString stringWithFormat:@"请输入0-%.2f数字",_UserRebate];
        [BasicControls showAlertWithMsg:warningText addTarget:self];
        _myRebate = _UserRebate;
        _textField.text = [self formatFloat:_myRebate];
        return;
    }
    [_RebatebgView removeFromSuperview];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%@",[self.personMessage valueForKey:@"id"]] forKey:@"id"];
    [param setObject:_textField.text forKey:@"fd"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_MyhomeCheck params:param Token:YES success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"touchView":self.touchView,@"name":[self.personMessage valueForKey:@"name"]}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addPersonInCharge" object:dic];
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MyhomeViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    } failure:^(NSError *error) {
        
    } Target:self];
    
    
}

/**
 取消设置返利比
 */
- (void)cancleRebate
{
    [_RebatebgView removeFromSuperview];
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


#pragma mark - util
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


/**
 添加动画

 @param view 试图
 */
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

/**
 点击消失设置返利点
 
 @param tap 对象
 */
- (void)clickCancleRebate:(UITapGestureRecognizer *)tap
{
    UIView *view = [_RebatebgView viewWithTag:52101];
    if(!CGRectContainsPoint(_RebatebgView.frame, [tap locationInView:view])) {
        [self cancleRebate];;
    };
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
@end
