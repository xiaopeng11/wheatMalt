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
#define wheatMalt_RefreshUserMessage @"/api/person/getUserInfor.do"      //获取个人数据
#define wheatMalt_changePersonURL @""                                    //头像上传
#define wheatMalt_changePersonMessage @"/api/person/saveUserInfor.do"    //个人信息修改
#define wheatMalt_upLoadUserPic @"/api/person/upLoadUserPic.do"          //头像上传
#define wheatMalt_saveUserPic @"/api/person/saveUserPic.do"              //头像修改
#define wheatMalt_V @"/api/pub/getLevel.do"                              //V等级


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
#define wheatMalt_ResetPassword @"/api/person/setPwd.do"

//意见反馈
#define wheatMalt_AdviceLoad @"/api/person/addQuestion.do"
#define wheatMalt_Advices @"/api/person/getMyQuestionList.do"  //意见反馈列表

//隐藏金额
#define wheatMalt_HiddenJE @"/api/person/enableCb.do"

//最近搜索关键字
#define wheatMalt_KeyWords @"/api/person/getKeyWords.do"

//全局搜索（情报/客户接口）
#define wheatMalt_OverallSearchData @"/api/client/getClientAndQbList.do"




#define customerState @[@"(未注册)",@"(低频)",@"(未付款)",@"(体验中)",@"(未开启)",@"(已失效)"]
#define customerState1 @[@"未注册",@"低频",@"未付款",@"体验中",@"未开启",@"已失效"]

#define intelligenceState @[@"",@"(未续费已停用)"]
#define customerStateColor @[RedStateColor,RedStateColor,RedStateColor,GreenStateColor,GraytextColor,[UIColor blackColor]]
#define intelligenceStateColor @[[UIColor blackColor],RedStateColor]



#endif /* MaltAPI_h */
