
#include "database.h"
#include "eTalk.h"
#include "network.h"


int main() {

	
	type_msg msg;
	char strmsg[500];
	char namepw[100];
	
	init_net();
#define z
#ifdef	a
		//注册
	mergemsg_two(namepw, "name2", "pw2");
	msg_init(&msg, NULL, NULL, NULL, MSG_VERF, MSG_REGIST, NULL, namepw);
#endif
#ifdef	a
		//登入
	mergemsg_two(namepw, "230049260", "pw2");
	msg_init(&msg, NULL, "192.168.1", NULL,  MSG_VERF, MSG_LOGI, NULL, namepw);
#endif
#ifdef	a
		//登出
	msg_init(&msg, "nwlrbbmqb", NULL, NULL,  MSG_VERF, MSG_LOGO, NULL, NULL);
#endif
#ifdef	a
		//添加	
	msg_init(&msg, "ababc", NULL, NULL,  MSG_ADDCT, MSG_LOGO, NULL, "1212");
#endif
#ifdef	a
		//列表更新
		
#endif
#ifdef	a
		//消息
	mergemsg_two(namepw, "1212", "msgmsg");
	msg_init(&msg, "ewgknmnmo", "286757701", "230049260",  MSG_NEWS, NULL, NULL, "msgmsg");
		
#endif
#ifdef	a
		//未读消息
		
#endif
#ifdef	a
	strmsg_tymsg(strmsg, &msg);
	recv_msg_strmsg(strmsg);
		//
#endif	
	char c = 'a';// getchar();
	if (c == 'd') {
		sql_del_all_loginfo() ;
	}
	
	
	printf("\n***********************%s***************************\n", db_tablename_AllContaces);
	show_all(db_tablename_AllContaces);
	printf("\n***********************%s***************************\n", db_tablename_loginfo);
	show_all(db_tablename_loginfo);
//	printf("\n***********************%s***************************\n", "0");
//	show_all("0");
	
	
	net_listen();
	
	
}

