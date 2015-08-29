//
//  eTalk.h
//  eTalk
//
//  Created by Keith on 14-5-26.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//
//
#ifndef ETALK_4_0_DEFINE_H
#define ETALK_4_0_DEFINE_H

#define zz	printf("\n\t..BUG..\n");

//IP宏
//#define  IP_SERVERIP            "192.168.1.110"
//#define  IP_SERVERPORT          8998
#define  IP_CELIENLISTENPORT    8999

//系统类型
#define  SYSTYPE_IOS		1
#define  SYSTYPE_AND		2


#define db_tablename_AllContaces	"AllContaces"
#define db_tablename_loginfo		"LogInfo"

//消息长度宏msg:mm#fromeid#toid#msg`123456
//消息最大长度
#define   MSG_SMAX			2048
//用户获取的随机通行口令长度（只有正确才处理）
#define  MSG_SMM			10
//操作类型长度
#define  MSG_STP			1
//验证操作所占长度
#define  MSG_SBL			1
//消息列表（字符）
#define  MSG_SMS			1024

//**************联系人中未使用此标志******************
//用户ID长度（只有可见字符）
#define  MSG_SID			10
//用户密码长度（只有可见字符）
#define  MSG_SPW			20
//用户名字长度
#define MSG_SNAME			30

//消息类型宏
#define  MSG_NONE			9
#define  MSG_VERF			10	//：验证操作
#define  MSG_LOGI			11	//：登录
#define  MSG_LIST			12	//：列表
#define  MSG_NEWS			13	//：消息
#define  MSG_LOGO			14	//：注销
#define  MSG_LTIM			15	//：列表更新时间
#define  MSG_ADDCT			16	//：添加联系人
#define  MSG_UNREAD			17	//：未读消息
#define  MSG_REGIST			18	//：注册
#define  MSG_CTINFO         19  //：传递联系人信息
#define  MSG_TEST           20  //：测试服务器是否能够响应

#define  MSG_BLNO			'-'	//：失败
#define  MSG_BLYES			'+'	//：成功
#define  MSG_BLNOID			'!'	//：帐户不存在
#define  MSG_BLCOM			'0'	//：被挤下线


//返回值
#define return_OK               0
#define return_NOCONTACE		1
#define return_OPERERROR		-1

#define CMP_CONT_IDPW			1
#define return_IDPW_OK			1
#define return_IDPW_NO			0
#define SQL_LOGI_ID			0
#define SQL_LOGI_MM			1



#define sockHaveNewMsg  @"sockHaveNewMsg"

#endif
/*
#ifndef eTalk_eTalk_h
#define eTalk_eTalk_h

　　//IP宏
#define　　IP_SERVERIP        ip
#define　　IP_SERVERPORT      8998
　　//系统类型
#define　　SYSTYPE_IOS        1
#define　　SYSTYPE_AND        2
　　//消息长度宏msg:[TP:char1][BL:char2][ID:char10][PW:char20][TIME:int1][MS:char1024][IMG]
#define　　MSG_STP            1
#define　　MSG_SBL            2
#define　　MSG_SID            10
#define　　MSG_SPW            20
#define　　MSG_STM            1
#define　　MSG_SMS            1024
//消息类型宏
#define　　MSG_VERF           0	//：验证操作 TP BL
#define　　MSG_LOGI           1	//：登录	TP ID PW
#define　　MSG_LIST           2	//：列表 TP ID MS
#define　　MSG_NEWS           3	//：消息 TP ID MS
#define　　MSG_LOGO           4	//：注销	TP ID
#define　　MSG_LTIM           5	//：列表更新时间 TP ID  TIME
　　//信息保存文件名字
#define　　FILE_CONTACT       contact.dat //联系人
#define　　FILE_NEWS          news.dat	//消息


#endif*/
