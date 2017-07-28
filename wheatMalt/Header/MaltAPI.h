//
//  MaltAPI.h
//  wheatMalt
//
//  Created by Apple on 2017/6/30.
//  Copyri ght © 2017年 Apple. All rights reserved.
//

#ifndef MaltAPI_h
#define MaltAPI_h




#define wheatMalt_load @"/crm/api/pub/login.do"  //登录

#define wheatMalt_forgetPS_getCode @"/crm/api/pub/sentPwdMsg.do" //忘记密码--获取验证码
#define wheatMalt_forgetPS_resetPS @"/crm/api/pub/setPwd.do"     //忘记密码--重置密码
#define wheatMalt_Register_getCode @"/crm/api/pub/sentRegistYzm.do" //注册--获取验证码
#define wheatMalt_Register @"/crm/api/pub/regist.do"                //注册


//情报
#define wheatMalt_Customer @"/crm/api/qb/getMyQbList.do"                //情报列表
#define wheatMalt_AddCustomer @"/crm/api/qb/addQb.do"                   //情报新增
#define wheatMalt_SaveCustomer @"/crm/api/qb/updateQb.do"               //情报保存
#define wheatMalt_DeleteCustomer @"/crm/api/qb/deleteQb.do"             //情报删除
#define wheatMalt_InvalidORRecoveryCustomer @"/crm/api/qb/enableQb.do"  //情失效/恢复
#define wheatMalt_CustomerWarningTime @"/crm/api/qb/updateTxrq.do"      //情报--设置提醒日期
#define wheatMalt_CustomerChargePerson @"/crm/api/qb/updateFzr.do"      //情报--设置负责人




#define wheatMalt_V @"/crm/api/pub/getLevel.do"  //V等级






//公共的接口
#define wheatMalt_LargeArea @"/crm/api/pub/getDqList.do"  //大区
#define wheatMalt_Province @"/crm/api/pub/getProvinceList.do"  //省


#define wheatMalt_chragePerson @"/crm/api/pub/getPersonList.do"  //负责人




#define personData @[@{@"id":@"1",@"name":@"肖鹏"},@{@"id":@"2",@"name":@"李刚"},@{@"id":@"3",@"name":@"刘希"},@{@"id":@"4",@"name":@"龙达"},@{@"id":@"5",@"name":@"李明"},@{@"id":@"6",@"name":@"肖1鹏"},@{@"id":@"7",@"name":@"李1刚"},@{@"id":@"8",@"name":@"刘1希"},@{@"id":@"9",@"name":@"龙达"},@{@"id":@"10",@"name":@"李1明"}]
#define areaData @[@{@"name":@"常州"},@{@"name":@"苏州"},@{@"name":@"南京"}]

#define cropData @[@{@"name":@"李科",@"lxr":@"王五",@"phone":@"18013574100",@"lx":1,@"comment":@"展示了产品反响很好"}]

#define myhomeprinceData @[@{@"name":@"江苏省(张三)"},@{@"name":@"西藏(李四)"},@{@"name":@"四川(五六)"},@{@"name":@"黑龙江(赵六)"},@{@"name":@"北京市(小明)"}]

#define myhomeunprinceData @[@{@"name":@"江西省"},@{@"name":@"新疆"},@{@"name":@"四川"},@{@"name":@"黑龙江"},@{@"name":@"北京市"}]

#define PendingPersonsData @[@{@"name":@"李刚",@"phone":@"18013574010",@"comments":@"工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力努力工作中也遇到了一些困难，但是在公司万众一心售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力努力工作中也遇到了一些困难，但是在公司万众一心售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力工作中也遇到了一些困难，但是在公司万众一心的气氛感染下，没有气馁,使得今年的销售任务圆满完成,虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力"},@{@"name":@"赵六",@"phone":@"18013571334",@"comments":@"虽然取得了一定的成绩，但距领导的要求和同事们的期望，还有一定的距离，我将更加努力大爷"}]

#define IntelligenceData  @[@{@"msid":@"0",@"id":@(0),@"lx":@(6),@"date":@"2017-07-10",@"name":@"天宇天宇天宇天宇天宇天宇天宇天宇天宇",@"lxr":@"李明",@"phone":@"18013674010",@"je":@(1300000),@"fl":@(780000)},@{@"msid":@"0",@"id":@(1),@"lx":@(6),@"date":@"2017-06-19",@"name":@"天麦",@"lxr":@"小明",@"phone":@"18013674010",@"je":@(130000),@"fl":@(78000)},@{@"msid":@"0",@"id":@(2),@"lx":@(6),@"date":@"2017-06-29",@"name":@"国网",@"lxr":@"李大明大",@"phone":@"18013674010",@"je":@(130000),@"fl":@(78000)},@{@"msid":@"0",@"id":@(3),@"lx":@(7),@"date":@"2017-06-09",@"name":@"张家港蜂星",@"lxr":@"李明",@"phone":@"18013674010",@"je":@(1300000),@"fl":@(780000)}]


#define PaymentRecordData @[@{@"date":@"2017-06-01",@"je":@(16800),@"fl":@(8000)},@{@"date":@"2017-06-11",@"je":@(17800),@"fl":@(8800)},@{@"date":@"2017-07-21",@"je":@(36800),@"fl":@(18000)}]


#define IntelligenceMessageData @{@"name":@"天宇",@"lxr":@"李明",@"phone":@"13625284194",@"Edition":@"专业版",@"nums":@(10),@"date":@"2018-06-20",@"chargeid":@"1",@"chargePerson":@"肖鹏",@"comments":@"挨打大多大展示了产品反响很好展示了产品反响很好展示了产品反响很好展示了产品反响很好"}

#define ProfitData @[@{@"lx":@(0),@"id":@"1",@"name":@"无锡国网",@"money":@(90000)},@{@"lx":@(0),@"id":@"2",@"name":@"张家港蜂星",@"money":@(200000)},@{@"lx":@(1),@"id":@"3",@"name":@"VIVO",@"money":@(120000)}]

#define ProfitsectionData @[@{@"lx":@(1),@"date":@"2017-06-01",@"money":@(20000)},@{@"lx":@(0),@"date":@"2017-01-01",@"money":@(30000)},@{@"lx":@(0),@"date":@"2016-06-01",@"money":@(40000)}]


#define CustomerData @[@{@"msid":@"1",@"name":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"lx":@"0",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"commens":@"展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5"},@{@"msid":@"1",@"name":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"lx":@"0",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"commens":@"展示了产品,反响很好,预计有10个用户展示了产品,反响很好,预计有10个用户展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5"},@{@"msid":@"1",@"name":@"昆山龙腾",@"lx":@"1",@"usedlx":@"1",@"lxr":@"李四",@"phone":@"18013574011",@"commens":@"展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5",@"userTime":@[@{@"2017-06-01":@"1.5"},@{@"2017-06-02":@"0"},@{@"2017-06-03":@"4"},@{@"2017-06-01":@"0"},@{@"2017-06-01":@"0"}]},@{@"msid":@"1",@"name":@"乐冠",@"lx":@"2",@"usedlx":@"2",@"lxr":@"赵三",@"phone":@"18013574023",@"commens":@"展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5",@"userTime":@[@{@"2017-06-01":@"1.5"},@{@"2017-06-02":@"0"},@{@"2017-06-03":@"4"},@{@"2017-06-01":@"0"},@{@"2017-06-01":@"0"}]},@{@"msid":@"1",@"name":@"苑腾龙",@"lx":@"3",@"usedlx":@"3",@"lxr":@"王五王五王五",@"phone":@"18013574343",@"commens":@"展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"userTime":@[@{@"2017-06-01":@"1.5"},@{@"2017-06-02":@"0"},@{@"2017-06-03":@"4"},@{@"2017-06-01":@"0"},@{@"2017-06-01":@"0"}]},@{@"msid":@"1",@"name":@"常州旺达",@"lx":@"4",@"usedlx":@"4",@"lxr":@"王五",@"phone":@"18013572310",@"commens":@"展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5",@"userTime":@[@{@"2017-06-01":@"1.5"},@{@"2017-06-02":@"0"},@{@"2017-06-03":@"4"},@{@"2017-06-01":@"0"},@{@"2017-06-01":@"0"}]},@{@"msid":@"1",@"name":@"乐语",@"lx":@"5",@"usedlx":@"2",@"lxr":@"王五",@"phone":@"18013574010",@"commens":@"展示了产品,反响很好,预计有10个用户展示了产品,反响很好,预计有10个用户,预计有10个用户展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5",@"userTime":@[@{@"2017-06-01":@"1.5"},@{@"2017-06-02":@"0"},@{@"2017-06-03":@"4"},@{@"2017-06-01":@"0"},@{@"2017-06-01":@"0"}]}]


#define HomeRecentSearchData @[@{@"msid":@"0",@"id":@(0),@"lx":@(0),@"date":@"2017-07-10",@"name":@"天宇天宇天宇天宇天宇天宇天宇天宇天宇",@"lxr":@"李明",@"phone":@"18013674010",@"je":@(1300000),@"fl":@(780000)},@{@"msid":@"0",@"id":@(1),@"lx":@(0),@"date":@"2017-06-19",@"name":@"天麦",@"lxr":@"小明",@"phone":@"18013674010",@"je":@(130000),@"fl":@(78000)},@{@"msid":@"1",@"name":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"lx":@"0",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"commens":@"展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5"},@{@"msid":@"1",@"name":@"乐冠乐冠乐冠乐冠乐冠乐冠乐冠",@"lx":@"0",@"lxr":@"王五",@"usedlx":@"0",@"phone":@"18013574010",@"commens":@"展示了产品,反响很好,预计有10个用户展示了产品,反响很好,预计有10个用户展示了产品,反响很好,预计有10个用户",@"address":@"南京市东方大道10号",@"warningTime":@"2017-07-20",@"registerTime":@"2017-07-02",@"ChargePerson":@"李明",@"chargeid":@"5"}]

#define recentSearchKey @[@"肖鹏",@"无锡国网",@"苏州",@"李明",@"2017-06-01/2017-07-01",@"李明",@"江苏移动总公司",@"南京",@"2017-06-01/2017-07-01",@"李东",@"啦啦啦",@"无锡"]


#define AdviceHistoryData @[@{@"advice":@"拉拉阿拉大萨达加大",@"time":@"2017-07-10 12:23",@"lx":@"0"},@{@"advice":@"拉拉阿拉大萨达加大拉拉阿拉大萨达加大拉拉阿拉大萨达加大",@"time":@"2017-07-10 12:23",@"lx":@"1"},@{@"advice":@"拉拉阿拉大萨达加大",@"time":@"2017-07-10 12:23",@"lx":@"0"}]

#define customerState @[@"未注册",@"低频",@"未付款",@"体验中",@"未开启",@"已失效",@"未续费已停用",@""]
#define customerStateColor @[RedStateColor,RedStateColor,RedStateColor,GreenStateColor,GraytextColor,[UIColor blackColor],RedStateColor,[UIColor whiteColor]]

#define myRebate 0.6

#endif /* MaltAPI_h */
