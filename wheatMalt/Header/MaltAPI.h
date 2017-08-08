//
//  MaltAPI.h
//  wheatMalt
//
//  Created by Apple on 2017/6/30.
//  Copyri ght © 2017年 Apple. All rights reserved.
//

#ifndef MaltAPI_h
#define MaltAPI_h

//appstore中的代码
#define APP_URL @"http://itunes.apple.com/lookup?id=1103122494"

#define wheatMalt_ResetEdition @""       //刷新版本

#define wheatMalt_load @"/api/pub/login.do"  //登录

#define wheatMalt_forgetPS_getCode @"/api/pub/sentPwdMsg.do" //忘记密码--获取验证码
#define wheatMalt_forgetPS_resetPS @"/api/pub/setPwd.do"     //忘记密码--重置密码
#define wheatMalt_Register_getCode @"/api/pub/sentRegistYzm.do" //注册--获取验证码
#define wheatMalt_Register @"/api/pub/regist.do"                //注册--验证码
#define wheatMalt_Register_PerfertMessage @"/api/pub/userConsummate.do"     //注册--完善个人信息

//公共的接口
#define wheatMalt_LargeArea @"/api/pub/getDqList.do"  //大区
#define wheatMalt_Province @"/api/pub/getProvinceList.do"  //省
#define wheatMalt_City @"/api/pub/getCityList.do"  //市
#define wheatMalt_Town @"/api/pub/getTownList.do"  //区


#define wheatMalt_chragePerson @"/api/pub/getPersonList.do"  //负责人



//情报
#define wheatMalt_Customer @"/api/qb/getMyQbList.do"                               //情报列表
#define wheatMalt_CustomerByids @"/api/qb/getQbListByFzdIds.do"                    //情报列表--负责人/区域
#define wheatMalt_CustomerUndistribution @"/api/qb/getNoFzrQbList.do"           //情报列表--未分配

#define wheatMalt_AddCustomer @"/api/qb/addQb.do"                   //情报新增
#define wheatMalt_SaveCustomer @"/api/qb/updateQb.do"               //情报保存
#define wheatMalt_InvalidORRecoveryCustomer @"/api/qb/enableQb.do"  //情失效/恢复
#define wheatMalt_CustomerWarningTime @"/api/qb/updateTxrq.do"      //情报--设置提醒日期
#define wheatMalt_CustomerChargePerson @"/api/qb/updateFzr.do"      //情报--设置负责人

//客户
#define wheatMalt_Intelligence @"/api/client/getMyKhList.do"                             //客户列表
#define wheatMalt_IntelligenceByids @"/api/client/getClientListByFzdIds.do"              //客户列表--负责人/区域
#define wheatMalt_IntelligenceUndistribution @"/api/client/getMyNoFzrKhList.do"          //客户列表--未分配
#define wheatMalt_IntelligenceMessage @"/api/client/getDetail.do"                        //客户详情
#define wheatMalt_SaveIntelligenceMessage @"/api/client/updateClient.do"                 //保存客户详情
#define wheatMalt_IntelligenceChargePerson @"/api/client/updateFzr.do"                   //客户--设置负责人
#define wheatMalt_IntelligencePaymentRecordData @"/api/client/getClientFkjl.do"          //客户--付款记录


//个人信息
#define wheatMalt_changePersonURL @""                                    //头像上传
#define wheatMalt_changePersonMessage @"/api/person/saveUserInfor.do"    //个人信息修改
#define wheatMalt_changePersonPic @"/api/person/saveUserPic.do"          //头像上传修改


//麦圈
#define wheatMalt_Myhome @"/api/person/getMyQuyu.do"                    //麦圈数据
#define wheatMalt_MyhomerRemovePendingData @"/api/person/removeSqr.do"  //移除申请记录
#define wheatMalt_MyhomeCheck @"/api/person/checkSqr.do"                //通过审核
#define wheatMalt_MyhomeRemovePerson @"/api/person/removeFzr.do"        //移除负责人
#define wheatMalt_MyhomeChangeFD @"/api/person/setFzrFd.do"             //改变返利点

//通知
#define wheatMalt_Totalnotice @"/api/person/enableTx.do"                //通知总开关
#define wheatMalt_TotalnoticeDetail @"/api/person/setTx.do"             //详细通知开关

//修改密码
#define wheatMalt_ResetPassword @""   


#define wheatMalt_RefreshUserMessage @"/api/person/getUserInfor.do"     //获取个人数据






#define wheatMalt_V @"/api/pub/getLevel.do"  //V等级












#define myhomeprinceData @[@{@"name":@"江苏省(张三)"},@{@"name":@"西藏(李四)"},@{@"name":@"四川(五六)"},@{@"name":@"黑龙江(赵六)"},@{@"name":@"北京市(小明)"}]

#define myhomeunprinceData @[@{@"name":@"江西省"},@{@"name":@"新疆"},@{@"name":@"四川"},@{@"name":@"黑龙江"},@{@"name":@"北京市"}]

#define PendingPersonsData @[@{@"name":@"李刚",@"phone":@"18013574010",@"comments":@"工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力努力工作中也遇到了一些困难，但是在公司万众一心售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力努力工作中也遇到了一些困难，但是在公司万众一心售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力"},@{@"name":@"赵六",@"phone":@"18013571334",@"comments":@"虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力大爷"}]

#define IntelligenceData  @[@{@"msid":@"0",@"id":@(0),@"lx":@(6),@"date":@"2017-07-10",@"name":@"天宇天宇天宇天宇天宇天宇天宇天宇天宇",@"lxr":@"吴宗安",@"phone":@"18013674010",@"je":@(1300000),@"fl":@(780000)},@{@"msid":@"0",@"id":@(1),@"lx":@(6),@"date":@"2017-06-19",@"name":@"天麦",@"lxr":@"小明",@"phone":@"18013674010",@"je":@(130000),@"fl":@(78000)},@{@"msid":@"0",@"id":@(2),@"lx":@(6),@"date":@"2017-06-29",@"name":@"国网",@"lxr":@"李大明大",@"phone":@"18013674010",@"je":@(130000),@"fl":@(78000)},@{@"msid":@"0",@"id":@(3),@"lx":@(7),@"date":@"2017-06-09",@"name":@"张家港蜂星",@"lxr":@"吴宗安",@"phone":@"18013674010",@"je":@(1300000),@"fl":@(780000)}]


#define PaymentRecordData @[@{@"date":@"2017-06-01",@"je":@(16800),@"fl":@(8000)},@{@"date":@"2017-06-11",@"je":@(17800),@"fl":@(8800)},@{@"date":@"2017-07-21",@"je":@(36800),@"fl":@(18000)}]


#define IntelligenceMessageData @{@"name":@"天宇",@"lxr":@"吴宗安",@"phone":@"13625284194",@"Edition":@"专业版",@"nums":@(10),@"date":@"2018-06-20",@"chargeid":@"1",@"chargePerson":@"肖鹏",@"comments":@"挨打大多大展示了产品反响很好展示了产品反响很好展示了产品反响很好展示了产品反响很好"}

#define ProfitData @[@{@"lx":@(0),@"id":@"1",@"name":@"无锡国网",@"money":@(90000)},@{@"lx":@(0),@"id":@"2",@"name":@"张家港蜂星",@"money":@(200000)},@{@"lx":@(1),@"id":@"3",@"name":@"VIVO",@"money":@(120000)}]

#define ProfitsectionData @[@{@"lx":@(1),@"date":@"2017-06-01",@"money":@(20000)},@{@"lx":@(0),@"date":@"2017-01-01",@"money":@(30000)},@{@"lx":@(0),@"date":@"2016-06-01",@"money":@(40000)}]


//#define CustomerData @[@{@"id":@"1",@"gsname":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"status":@"0",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"comments":@"展示了产品,反响很好,预计有10个用户",@"dz":@"南京市东方大道10号",@"txdate":@"2017-08-20",@"txflag":@"1",@"usrname":@"吴宗安",@"usrid":@"1",@"mdgs":@"10",@"zcrq":@"",@"zdrq":@"2017-07-28 18:24:03",@"yxbz":@"0"},@{@"id":@"1",@"gsname":@"121111111",@"status":@"1",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"comments":@"展示了产品,反响很好,预计有10个用户",@"dz":@"南京市东方大道10号",@"txdate":@"2017-08-20",@"txflag":@"1",@"usrname":@"吴宗安",@"usrid":@"1",@"mdgs":@"10",@"zcrq":@"2017-07-29 18:24:03",@"zdrq":@"2017-07-28 18:24:03",@"yxbz":@"0"},@{@"id":@"1",@"gsname":@"2222222222",@"status":@"2",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"comments":@"展示了产品,反响很好,预计有10个用户",@"dz":@"南京市东方大道10号",@"txdate":@"2017-07-20",@"txflag":@"1",@"usrname":@"吴宗安",@"usrid":@"1",@"mdgs":@"10",@"zcrq":@"2017-07-29 18:24:03",@"zdrq":@"2017-07-28 18:24:03",@"yxbz":@"0"},@{@"id":@"1",@"gsname":@"3333333333333",@"status":@"3",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"comments":@"展示了产品,反响很好,预计有10个用户",@"dz":@"南京市东方大道10号",@"txdate":@"2017-07-20",@"txflag":@"1",@"usrname":@"吴宗安",@"usrid":@"1",@"mdgs":@"10",@"zcrq":@"2017-07-29 18:24:03",@"zdrq":@"2017-07-28 18:24:03",@"yxbz":@"0"},@{@"id":@"1",@"gsname":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"status":@"3",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"comments":@"展示了产品,反响很好,预计有10个用户",@"dz":@"南京市东方大道10号",@"txdate":@"",@"txflag":@"0",@"usrname":@"吴宗安",@"usrid":@"1",@"mdgs":@"10",@"zcrq":@"2017-07-29 18:24:03",@"zdrq":@"2017-07-28 18:24:03",@"yxbz":@"0"},@{@"id":@"1",@"gsname":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"status":@"3",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"comments":@"展示了产品,反响很好,预计有10个用户",@"dz":@"南京市东方大道10号",@"txdate":@"2017-07-20",@"txflag":@"1",@"usrname":@"吴宗安",@"usrid":@"1",@"mdgs":@"10",@"zcrq":@"",@"zdrq":@"2017-07-28 18:24:03",@"yxbz":@"1"}]


#define HomeRecentSearchData @[@{@"msid":@"0",@"id":@(0),@"lx":@(0),@"date":@"2017-07-10",@"name":@"天宇天宇天宇天宇天宇天宇天宇天宇天宇",@"lxr":@"吴宗安",@"phone":@"18013674010",@"je":@(1300000),@"fl":@(780000)},@{@"msid":@"0",@"id":@(1),@"lx":@(0),@"date":@"2017-06-19",@"name":@"天麦",@"lxr":@"小明",@"phone":@"18013674010",@"je":@(130000),@"fl":@(78000)},@{@"msid":@"1",@"name":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"lx":@"0",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"commens":@"展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"吴宗安",@"chargeid":@"5"},@{@"msid":@"1",@"name":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"lx":@"0",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"commens":@"展示了产品,反响很好,预计有10个用户展示了产品,反响很好,预计有10个用户展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"吴宗安",@"chargeid":@"5"}]

#define recentSearchKey @[@"肖鹏",@"无锡国网",@"苏州",@"吴宗安",@"2017-06-01/2017-07-01",@"吴宗安",@"江苏移动总公司",@"南京",@"2017-06-01/2017-07-01",@"李东",@"啦啦啦",@"无锡"]


#define AdviceHistoryData @[@{@"advice":@"拉拉阿拉大萨达加大",@"time":@"2017-07-10 12:23",@"lx":@"0"},@{@"advice":@"拉拉阿拉大萨达加大拉拉阿拉大萨达加大拉拉阿拉大萨达加大",@"time":@"2017-07-10 12:23",@"lx":@"1"},@{@"advice":@"拉拉阿拉大萨达加大",@"time":@"2017-07-10 12:23",@"lx":@"0"}]

#define customerState @[@"(未注册)",@"(低频)",@"(未付款)",@"(体验中)",@"(未开启)",@"(已失效)"]
#define intelligenceState @[@"",@"(未续费已停用)"]
#define customerStateColor @[RedStateColor,RedStateColor,RedStateColor,GreenStateColor,GraytextColor,[UIColor blackColor]]
#define intelligenceStateColor @[[UIColor blackColor],RedStateColor]
#define myRebate 0.6



#endif /* MaltAPI_h */
