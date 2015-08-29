//
//
//	newwork.h
//		网络操作函数
//
//
//
//

#ifndef NETWORK_H
#define NETWORK_H
#include <stdio.h>
#include <string.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <arpa/inet.h>
//#include <error.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <signal.h>

#include "eTalk.h"
#include "contace.h"
#include "database.h"
/*
	由于在来联系人中需要数据库中需要使用这个类型用来传递参数，那么我就把该声明放在了contace.h中。。
	
	最好搞个文件专业放类型。。。
	
typedef struct {
	char m_mm[MSG_SMM];	//mm
	char m_fromid[30];	//发出ID
	char m_toid[30];	//目的ID
	char m_tp;		//type		10 - 16	int
	char m_tped;		//ed type	10 - 16 int
	char m_tpbl;		//bool		10 - 11 int
	char m_msg[MSG_SMS];	//msg
	char m_fromip[30];	//发送消息IP (只有在注册使用)
} type_msg;
*/
/************************************* msg + - *********************************************/
			//消息组成：（m_mm长度）（m_mm）...
type_msg *msg_init(type_msg *tpmsg, char *mm, char *fid, char *tid, char tp, char tped, char tpbl, char *msg);
	// +
type_msg *tymsg_strmsg(type_msg *tymsg, char *chmsg);
	// - 
char *strmsg_tymsg(char *chmsg, type_msg *tymsg);

	//消息截断，两段式  --> 组成格式:sprintf(s, "%c%s%c%s",strlen(a), a, strlen(b), b);
int catmsg_two(char *msg, char *one, char *two);
int catmsg_three(char *msg, char *one, char *two, char *three);
int mergemsg_two(char *msg, char *one, char *two);
int msg_to_contace(type_contace *cont, type_msg *smg);
int msg_to_tocontace( type_contace *cont, type_msg *msg);
int msg_to_fromcontace( type_contace *cont, type_msg *msg);
/***********************************************************************************/
 

/************************************* 通讯 **********************************************/
int init_net();
int net_listen();
int net_send(char *ip, char *msg);
void *thread_fun(void *args);
char *my_inet_ntoa(long int ip);
/***********************************************************************************/

/************************************* 消息分析 **********************************************/
	// 消息处理函数
int recv_msg_strmsg(char *msg, char *ip);
int recv_msg_mmbl(type_msg msg);

	// TP:验证
int recv_msg_verf(type_msg msg);
	//TP:搜索列表
int recv_msg_listInfo (type_msg msg);
void sendAllContace(type_contace cont,  type_msg *msg) ;//搜索全部联系人列表
	// TP:消息
int recv_msg_news(type_msg msg);
	// TP:列表更新
int recv_msg_ltim(type_msg msg);
int recv_msg_ltim_all(type_msg msg);//更新全部列表
void sendcontace(type_contace contace);
	// TP:联系人添加
int recv_msg_addct(type_msg msg);
int recv_msg_contaceInfo (type_msg msg) ;
	//TPED 登入
int recv_msg_verf_logi(type_msg msg);
char *creatmm(char *mm);
	//TPED 未读
int recv_msg_verf_unread(type_msg msg);
//void sendUnreadMsg(type_contace toContace, type_contace fromContace, char *msg)
	//TPED 登出
int recv_msg_verg_logo(type_msg msg);
	//TPED 注册
int recv_msg_verg_regist(type_msg msg);
char *creatID();

	// 发送消息   直接传入需要发送的消息
int send_msg(type_msg msg);
	


/***********************************************************************************/


#endif

