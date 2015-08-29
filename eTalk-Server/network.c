
#include "network.h"

/************************************* 通讯 **********************************************/
int init_net() {
	init_DB();
	srand((unsigned)time(NULL));
    return 1;
}

int net_listen() {
	int ssockfd;
	if((ssockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket");
		exit(1);
	}

	struct sockaddr_in ssockaddr;
	ssockaddr.sin_family	= AF_INET;
	ssockaddr.sin_port	= htons(IP_SERVERPORT);
	ssockaddr.sin_addr.s_addr = INADDR_ANY;
	bzero(&ssockaddr.sin_zero, 8);
	
	int i = 1;
	setsockopt(ssockfd, SOL_SOCKET, SO_REUSEADDR, &i, sizeof(i));
	
	if(bind(ssockfd, (struct sockaddr *)&ssockaddr, sizeof(struct sockaddr)) == -1){
		perror("bind");
		exit(1);
	}
	
	if(listen(ssockfd, 253) == -1){
		perror("listen");
		exit(1);
	}
	
	struct sockaddr_in csockaddr;
	int csockfd;
	unsigned int sin_size;
		//同意接入并接受处理信息
	while(1){
		if((csockfd = accept(ssockfd, (struct sockaddr*)&csockaddr, &sin_size)) == -1){
			perror("TCP 40 accept");
			exit(1);
		}
		pthread_t thread;
		//char *fromip = my_inet_ntoa(csockaddr.sin_addr.s_addr);//inet_ntoa(csockaddr.sin_addr);
        //char fim[50]={'\0'};
        //char *fim = (char *)malloc(30);
        //printf("have len:%s\n", fromip);
        //printf("have new ip:\n%s!!\n", fromip);
		
        int ip = csockaddr.sin_addr.s_addr;
        int dcba[4];
        int i=0;
        for (i=0; i<4; i++) {
            dcba[i] = ip%256;
            ip = ip/256;
         }
    
       //sprintf(fim, "%d.%d.%d.%d", dcba[0], dcba[1], dcba[2], dcba[3]);
        //printf("%s\n", fim);

        //strcpy(fim, fromip);
		int ss[5] = {csockfd, dcba[0], dcba[1], dcba[2], dcba[3]};
		pthread_create(&thread, NULL, thread_fun, (void *)ss);

	}
}

char *my_inet_ntoa(long int ip) {
    char ips[50]={'\0'};

    int dcba[4];
    int i=0;
    for (i=0; i<4; i++) {
        dcba[i] = ip%256;
        ip = ip/256;
    }
    
    printf("%s\n", ips);
    return ips;
}

void *thread_fun(void *args){
	int *ss = (int *)args;
	int yousockfd = ss[0];
	char fromip[30];
	char buf[1040];
	int recv_size;

	if((recv_size = recv(yousockfd, buf, 1040, 0)) < 0){
		perror("recv");
		exit(1);
	}
	
    sprintf(fromip, "%d.%d.%d.%d", ss[1], ss[2], ss[3], ss[4]);

	printf("\tthread:%s\n", fromip);
	recv_msg_strmsg(buf, fromip);
	
	//free(fromip);
	pthread_exit(0);
    return NULL;
}
int net_send(char *ip, char *msg) {
	struct sockaddr_in yousockaddr;
	yousockaddr.sin_family = AF_INET;
	yousockaddr.sin_port = htons(8999);
printf("line 110 ");
    yousockaddr.sin_addr.s_addr = inet_addr(ip);
printf("line 112");
    bzero(&yousockaddr.sin_zero, 8);
	
	int mysockfd;
	if((mysockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket");
        return 0;
        //	exit(1);
	} 

	struct sockaddr_in mysockaddr;
	mysockaddr.sin_family	= AF_INET;
	mysockaddr.sin_port	= htons(8080);
	mysockaddr.sin_addr.s_addr = INADDR_ANY;
	bzero(&mysockaddr.sin_zero, 8);
	
	
	printf("\t<net send ip:%s>\n", ip);
	if(connect(mysockfd, (struct sockaddr *)&yousockaddr, sizeof(struct sockaddr)) == -1){
		perror("connect");
		exit(1);
        close(mysockfd);
		return 0;
	}
	 if (send(mysockfd, msg, strlen(msg), 0) == -1){
		perror("send");
		//exit(1);
        close(mysockfd);
		return 0;
	}
	close(mysockfd);
	printf("\t<net send OK!>\n");
	return 1;
}
/***********************************************************************************/
/************************************* 消息分析 **********************************************/

int msg_to_contace(type_contace *cont, type_msg *msg) {
	strcpy(cont->c_mm, msg->m_mm);
    return 1;
}
int msg_to_tocontace( type_contace *cont, type_msg *msg) {
	strcpy(cont->c_mm, msg->m_mm);
	strcpy(cont->c_id, msg->m_toid);
    return 1;
}
int msg_to_fromcontace( type_contace *cont, type_msg *msg) {
	strcpy(cont->c_mm, msg->m_mm);
	strcpy(cont->c_id, msg->m_fromid);
	strcpy(cont->c_ip, msg->m_fromip);
    return 1;
}
	// 消息处理函数
int recv_msg_strmsg(char *chmsg, char *fromip) {
	type_msg tpmsg;
	
	tymsg_strmsg(&tpmsg, chmsg);
	strcpy(tpmsg.m_fromip, fromip);
	
	printf("switch mm:%s, fromid:%s, toid:%s, tp:%d, tped:%d, tpbl:%d, msg:%s, ip:%s\n", tpmsg.m_mm, tpmsg.m_fromid, tpmsg.m_toid, tpmsg.m_tp, tpmsg.m_tped, tpmsg.m_tpbl, tpmsg.m_msg, tpmsg.m_fromip);
	
	if (recv_msg_mmbl(tpmsg)) {
        printf("%d---", tpmsg.m_tp);
		switch (tpmsg.m_tp) {
			case MSG_VERF:	//10 验证
				recv_msg_verf(tpmsg);
				break;
			case MSG_LIST:	//12 搜索列表
				recv_msg_listInfo(tpmsg);
				break;
			case MSG_NEWS:	//13 消息
				recv_msg_news(tpmsg);
				break;
			case MSG_LTIM:	//15 列表更新序列
				recv_msg_ltim(tpmsg);
				break;
			case MSG_ADDCT:	//16 添加联系人
				recv_msg_addct(tpmsg);
				break;
				
			/*case MSG_UNREAD:	//17 请求接收未读消息
				recv_msg_unread(tpmsg);
				break;
			*/	
			case MSG_CTINFO:	//19 联系人信息传递
				recv_msg_contaceInfo (tpmsg);
				break;
				
			case MSG_NONE:
				printf("\tmsg is none\n");
				break;
				
			default:
				printf("****消息无对应处理函数*****\n");
				break;
		}
	} else {
        printf("207 %d:%d\n", tpmsg.m_tp, tpmsg.m_tped);
		if (tpmsg.m_tp == MSG_VERF) {
			switch (tpmsg.m_tped) {
				case MSG_REGIST:
					recv_msg_verg_regist(tpmsg);
					break;
				case MSG_LOGI:
					recv_msg_verf_logi(tpmsg);
					break;
				case MSG_TEST:
					recv_msg_verf_test(tpmsg);
					break;
				default:
					printf("****消息无＃验证*****\n");
					break;
			}
		}
	}
    return 1;
}

/*
int recv_msg_unread(type_msg msg) {
	printf("#请求未读消息\n");
	if (msg.m_tped == MSG_VERF) {
		printf("#请求接收未读消息、\n");
		type_contace cont;
		contace_creat(&cont, NULL, NULL, NULL, msg.m_mm, msg.m_fromip);
		
		sql_find_UnreadMsg(cont, sendUnreadMsg); 
		
	}
}

void sendUnreadMsg(type_contace toContace, type_contace fromContace, char *msg){
	type_msg msg;
	msg_init(&msg, toContace.c_mm, NULL, NULL, MSG_UNREAD, MSG_UNREAD, MSG_BLYES, msg);
	strcpy(msg.m_fromip,toContace.c_ip);
	send_msg(msg);
}
*/
int recv_msg_contaceInfo (type_msg msg) {
	printf("#请求联系人信息消息");
    return 1;
}

int recv_msg_listInfo (type_msg msg) {
	printf("----搜索ID：%s-----\n", msg.m_msg);
	type_contace cont, *c;
	type_msg endMsg;
	strcpy(cont.c_id, msg.m_msg);
	c = sql_find_all_contaces(cont, &msg, sendAllContace);
	if (c == NULL) {
		printf("查无此人\n");
		msg_init(&endMsg, msg.m_mm, NULL, NULL, MSG_LIST, MSG_NONE, MSG_BLNOID, NULL);
		strcpy(endMsg.m_fromip,msg.m_fromip);
		send_msg(endMsg);
	}
	/* else {
		printf("此人信息：ID:%s,Name:%s\n", c->c_id, c->c_name);
		char buf[50];
		sprintf(buf, "%s`%s", c->c_id, c->c_name);
		msg_init(&endMsg, msg.m_mm, NULL, NULL, MSG_CTINFO, MSG_NONE, MSG_BLYES, buf);
		free(c);
	}
	*/
	return 1;
}

void sendAllContace(type_contace cont, type_msg *msg) {
	printf("此人信息：ID:%s,Name:%s\n", cont.c_id, cont.c_name);
	char buf[50];
	type_msg endMsg;
	sprintf(buf, "%s`%s`%s", cont.c_id, cont.c_name, cont.c_headImage);
	msg_init(&endMsg, msg->m_mm, NULL, NULL, MSG_CTINFO, MSG_NONE, MSG_BLYES, buf);
	strcpy(endMsg.m_fromip,msg->m_fromip);
	send_msg(endMsg);
}

int recv_msg_mmbl(type_msg msg) {
	//****************验证mm是否正确如果不正确返回0，正确返回1****** OK ***********
	type_contace cont;
	type_contace *c;
	msg_to_contace(&cont, &msg);
	c = sql_find_loginfo(cont, SQL_LOGI_MM);
	if (c != NULL) {
		free(c);
		return 1;
	}
	return 0;
}
	// TP:验证
int recv_msg_verf(type_msg msg) {
	switch (msg.m_tped) {
		case MSG_UNREAD:
			recv_msg_verf_unread(msg);
			break;
		case MSG_LOGO:
			recv_msg_verg_logo(msg);
			break;
		default:
			printf("****验证消息无对应处理函数*****\n");
			break;
	}
    return 1;
}
	// TP:消息
int recv_msg_news(type_msg msg) {
	char ID[MSG_SID], strmsg[MSG_SMS];
	type_contace tocont;
	type_contace fromcont;
	type_contace *c;
	
	//****************查找登录的ID，不在则查找全部联系人，存在则保存之未读消息下，如果在则直接转发******************
	//取出msg中的两个id 和 mm 
	msg_to_tocontace(&tocont, &msg);
	msg_to_fromcontace(&fromcont, &msg);
	c = sql_find_loginfo(tocont, SQL_LOGI_ID);
	if (c == NULL) {
		c = sql_find_all_contaces(tocont, NULL, NULL);
		
			printf("*****%s\n",tocont.c_id);
		if (c == NULL) {
			printf("****error：消息ID不存在\n");
			return return_NOCONTACE;
		} else {
			//当前联系人不在线保存消息
			printf("ID%s不在线保存之数据库中\n", msg.m_toid);
			sql_add_UnreadMsg(fromcont, tocont, msg.m_msg);
			
		}
	} else {
		printf("ID%s存在发送消息%s\n", msg.m_toid, msg.m_msg);
		
		strcpy(msg.m_fromip, c->c_ip);
		strcpy(msg.m_mm, c->c_mm);
		send_msg(msg);
	}
	free(c);
	return return_OK;
}
	// TP:列表更新
int recv_msg_ltim(type_msg msg) {
	printf("---->列表更新:%s\n",msg.m_msg);
	//**************检测是否需要更新，如果需要则按照更新方式发送，如果不需要则直接发送更新完毕********************
	/******************* 如何存储那个更新序号???????????????***********************/
	
	recv_msg_ltim_all(msg);
	
    return 1;
}

//更新全部列表
int recv_msg_ltim_all(type_msg msg) {
	printf("更新全部联系人\n");
	/*逐个发送数据给该联系人，但是需根据＃找出ID 然后才能进行相关联系人搜索*/
	type_contace cont, *findEnd;
	msg_to_contace(&cont, &msg);
	findEnd = sql_find_loginfo(cont, SQL_LOGI_MM);
	strcpy(findEnd->c_ip, msg.m_fromip);
		//使用回调函数进行发送数据 回调函数为sendcontace
	sql_all_tablename_id(*findEnd, sendcontace);
	msg_init(&msg, findEnd->c_mm, NULL, NULL, MSG_VERF, MSG_LIST, MSG_BLYES, NULL);
	send_msg(msg);
    return 1;
}
void sendcontace(type_contace contace) {
	type_msg msg;
	char chmsg[50];
	
		//从联系人列表中获得ID 之后，在全部联系人中获得联系人信息
	type_contace *findend = sql_find_all_contaces(contace, NULL, NULL);
	mergemsg_two(chmsg, contace.c_id, findend->c_name);
	mergemsg_two(chmsg, chmsg, findend->c_headImage);
	msg_init(&msg, contace.c_mm, NULL, NULL, MSG_LIST, MSG_NONE, MSG_BLYES, chmsg);
	strcpy(msg.m_fromip, contace.c_ip);
	send_msg(msg);
	
	free(findend);
}
	// TP:联系人添加
int recv_msg_addct(type_msg msg) {
	printf("---->添加联系人ID:%s\n", msg.m_msg);
	//*************检测联系人是否存在，存在则添加之列表并更新联系人列表，不存在则直接返回添加失败****************
	
	type_contace cont;
	type_contace fromcont;
	type_contace *cp, *fcp;
	msg_to_fromcontace( &fromcont, &msg);
	contace_creat(&cont, msg.m_msg, NULL, NULL, NULL, NULL);
		//下方可添加是否同意加入
	cp = sql_find_all_contaces(cont, NULL, NULL);
	if (cp == NULL) {
		printf("****ID%s不存在\n", cont.c_id);
		return return_NOCONTACE;
	}
		//查找添加者IDDB
	fcp = sql_find_loginfo(fromcont, SQL_LOGI_MM);
	contace_creat(&fromcont, fcp->c_id, NULL, fcp->c_name, NULL, NULL);
	
		//IDDB数据库操作
	sql_add_tablename_id(fromcont, cont);
	/************************ 没有存储更新序号 检测是否需要全部更新*************************/
	type_msg replymsg;
	char chmsg[100] ;
	mergemsg_two(chmsg, cp->c_id, cp->c_name);
	msg_init(&replymsg, msg.m_mm, NULL, NULL,MSG_ADDCT , MSG_NONE, MSG_BLYES, chmsg);
	
	strcpy(replymsg.m_fromip, msg.m_fromip);
	
	printf("send msg ip:%s, msg :%s\n", replymsg.m_fromip, replymsg.m_msg);
	send_msg(replymsg);
	
	free(cp);
	free(fcp);
	
	return return_OK;
}
	//测试服务器是否可用
int recv_msg_verf_test(type_msg msg) {
	
	type_msg replymsg;
	msg_init(&replymsg, NULL, NULL, NULL, MSG_VERF, MSG_TEST, MSG_BLYES, NULL);
	strcpy(replymsg.m_fromip, msg.m_fromip);
	send_msg(replymsg);
    return 1;
}

	//TPED 登入
int recv_msg_verf_logi(type_msg msg) {
	char ID[MSG_SID], PW[MSG_SPW], MM[MSG_SMM];
	catmsg_two(msg.m_msg, ID, PW);
	printf("---->登入ID:%s\tPW:%s\tIP:%s\n", ID, PW, msg.m_fromip);
	//************检测是否属实 然后发送是否登录成功*********
	type_contace *cp;
	type_contace cont;
	type_msg replymsg;
	contace_creat(&cont, ID, PW, NULL, NULL, msg.m_fromid);
	cp = sql_find_all_contaces(cont, NULL, NULL);
	
	if (cp == NULL) {
		msg_init(&replymsg, msg.m_mm, NULL, NULL, MSG_VERF, MSG_LOGI, MSG_BLNOID, NULL);
	} else {
		
		if ( return_IDPW_OK == contace_cmp(cp, &cont, CMP_CONT_IDPW)) {
				//检测是否已经登录
			type_contace *findend = sql_find_loginfo(cont, SQL_LOGI_ID);
				//ID已经登录
			if (findend) {
				printf("该ID(%s)已经登录。。。\n", cont.c_id);
					//挤下线
				sql_del_loginfo(*findend);
				msg_init(&replymsg, findend->c_mm, NULL, NULL, MSG_LOGO, MSG_NONE, MSG_BLCOM, "");
				strcpy(replymsg.m_fromip, findend->c_ip);
				send_msg(replymsg);
				printf("已经被挤下线。。。\n");
					
				
                free(findend);
                sleep(1);
			}
			{
					//ID 没有登录，正常登录
				char chmsg[50] ;
				creatmm(MM);
				//printf("NAME:%s,ID:%s\n", cp->c_name, cp->c_id);
//				mergemsg_two(chmsg, cp->c_id, cp->c_name);
				mergemsg_three(chmsg, cp->c_id, cp->c_name, cp->c_headImage);
				msg_init(&replymsg, MM, NULL, NULL, MSG_VERF, MSG_LOGI, MSG_BLYES, chmsg);
				contace_creat(&cont, NULL, NULL, NULL, MM, msg.m_fromip);
				sql_add_loginfo(cont);
			}
			
		} else {
			msg_init(&replymsg, msg.m_mm, NULL, NULL, MSG_VERF, MSG_LOGI, MSG_BLNO, NULL);
		}
		
		free(cp);
	}	
	
	strcpy(replymsg.m_fromip, msg.m_fromip);
	send_msg(replymsg);
	
    return 1;
}

void reply_unreadmsg(type_contace fromcont, type_contace cont, char *msg) {
	char strmsg[MSG_SMS];
	type_msg tpmsg;
	mergemsg_two(strmsg, cont.c_id, msg);
	printf("--------%s-----未读消息为：%s\n", fromcont.c_ip,msg);
	msg_init(&tpmsg, fromcont.c_mm, NULL, NULL, MSG_UNREAD, 0, 0, strmsg);
	strcpy(tpmsg.m_fromip, fromcont.c_ip);
	send_msg(tpmsg);
}
	//TPED 未读
int recv_msg_verf_unread(type_msg msg) {
	printf("---->未读消息\n");
	//*************检测是否有未读消息，并发送****************
	type_contace fromcont;
	msg_to_fromcontace( &fromcont, &msg);
	printf("448:%s----%s\n", fromcont.c_ip, msg.m_fromip);
	
	sql_find_UnreadMsg(fromcont, reply_unreadmsg);
/*		未读发送结束	
	type_msg tpmsg;
	msg_init(tpmsg, msg.m_mm, MSG_VERF, MSG_UNREAD, MSG_BLYES, NULL);
	send_msg(tymsg);
*/
    return 1;
}
	//TPED 登出
int recv_msg_verg_logo(type_msg msg) {
	printf("---->登出%c\n", msg.m_tpbl);
	//**************登出操作，并发送登出成功**************
	type_contace cont;
	type_msg tpmsg;
	contace_creat(&cont, NULL, NULL, NULL, msg.m_mm, NULL);
	sql_del_loginfo(cont);
	msg_init(&tpmsg, msg.m_mm, NULL, NULL, MSG_LOGO, MSG_NONE, MSG_BLYES, NULL);
	strcpy(tpmsg.m_fromip, msg.m_fromip);
	send_msg(tpmsg);
	return 1;
}
	//TPED 注册
int recv_msg_verg_regist(type_msg msg) {
	char NAME[MSG_SNAME], PW[MSG_SPW], HIMAGE[MSG_SPW];
//	catmsg_two(msg.m_msg, NAME, PW);
	catmsg_three(msg.m_msg, NAME, PW, HIMAGE);
	printf("---->注册name:%s\tpw:%s\n", NAME, PW);
	//***************生成ID，并发送******************
	
	
	
	char ID[MSG_SID];
	creatID(ID);
	type_contace cont;
	contace_creat(&cont, ID, PW, NAME, NULL, NULL);
	strcpy(cont.c_headImage, HIMAGE);
	
	type_msg tpmsg;
	msg_init(&tpmsg, NULL, NULL, NULL, MSG_VERF, MSG_REGIST, MSG_BLYES, ID);
	strcpy(tpmsg.m_fromip, msg.m_fromip);
	
	sql_add_all_contaces(cont);
	
	send_msg(tpmsg);
	
    return 1;
}

char *creatID(char *id) {
	char tt[10];
	static int i=0;
	i = show_all(db_tablename_AllContaces);
    sprintf(tt, "%d", i++);
	strcpy(id, tt);
	return id;
	
    
    
    /*char tt[10];
	int i;
	for(i=0; i<9; i++) {
		tt[i] = rand()%10 + '0';
	}
	tt[i] = '\0';
	strcpy(id, tt);
	return id;*/
}
char *creatmm(char *mm) {

	char tt[10];
	int i;
	for(i=0; i<9; i++) {
		tt[i] = rand()%26 + 'a';
	}
	tt[i] = '\0';
	

	strcpy(mm, tt);
	return mm;
}


int send_msg(type_msg msg) {
	printf("hha\n");
	printf("---->send mm:%s,fromid:%s,toif:%s,tp:%d,tped:%d,tpbl:%c,msg:%s,fromIP:%s\n", msg.m_mm, msg.m_fromid, msg.m_toid, msg.m_tp, msg.m_tped, msg.m_tpbl, msg.m_msg, msg.m_fromip);
	printf("hha\n");
	char strmsg[1024];
	strmsg_tymsg(strmsg, &msg);
	net_send(msg.m_fromip, strmsg);
    return 1;
}

/***********************************************************************************/

/************************************* msg + - *********************************************/


	//消息截断，两段式
int catmsg_two(char *msg, char *one, char *two) {
	int i, j=0, len = strlen(msg);
	for (i=0; i<len; j++, i++) {
		if(msg[i] == '`') {
			break;
		}
		one[j] = msg[i];
	}
	one[j] = '\0';
	i++;
	for (j=0; i<len; j++, i++) {
		if(msg[i] == '\0') {
			break;
		}
		two[j] = msg[i];
	}
	two[j] = '\0';
    return 1;	
}
int catmsg_three(char *msg, char *one, char *two, char *three) {
	sscanf(msg, "%[^`]`%[^`]`%[^`]", one, two, three);
    return 1;
}
int mergemsg_two(char *msg, char *one, char *two) {
	sprintf(msg, "%s`%s", one, two);
    return 1;
}
int mergemsg_three(char *msg, char *one, char *two, char *three) {
	sprintf(msg, "%s`%s`%s", one, two, three);
    return 1;
}

type_msg *msg_init(type_msg *tpmsg, char *mm, char *fid, char *tid, char tp, char tped, char tpbl, char *msg) {
	if (mm == NULL) {
		strcpy(tpmsg->m_mm, "");
	} else {
		strcpy(tpmsg->m_mm, mm);
	}
	if (fid == NULL) {
		strcpy(tpmsg->m_fromid, "");
	} else {
		strcpy(tpmsg->m_fromid, fid);
	}
	if (tid == NULL) {
		strcpy(tpmsg->m_toid, "");
	} else {
		strcpy(tpmsg->m_toid, tid);
	}
	
	if (tp == 0) {
		tpmsg->m_tp = MSG_NONE;
	} else {
		tpmsg->m_tp = tp;
	}
	
	if (tped == 0) {
		tpmsg->m_tped = MSG_NONE;
	} else {
		tpmsg->m_tped = tped;
	}
	
	if (tpbl == 0) {
		tpmsg->m_tpbl = MSG_BLNO;
	} else {
		tpmsg->m_tpbl = tpbl;
	}
	
	if (msg == NULL) {
		strcpy(tpmsg->m_msg, "");
	} else {
		strcpy(tpmsg->m_msg, msg);
	}
    return tpmsg;
}
/************************************ 消息中缺少ID分割 ******************************************/
	// +
type_msg *tymsg_strmsg(type_msg *tymsg, char *chmsg) {
	int i,j = 0;
	
	for (i=0; i<MSG_SMM; i++) {
		if (chmsg[j] == '#') {
			break;
		}
		tymsg->m_mm[i] = chmsg[j++];
	}
	tymsg->m_mm[i] = '\0';
	j++;
	
	for (i=0; i<MSG_SID; i++) {
		if (chmsg[j] == '#') {
			break;
		}
		tymsg->m_fromid[i] = chmsg[j++];
	}
	tymsg->m_fromid[i] = '\0';
	j++;
	
	for (i=0; i<MSG_SID; i++) {
		if (chmsg[j] == '#') {
			break;
		}
		tymsg->m_toid[i] = chmsg[j++];
	}
	tymsg->m_toid[i] = '\0';
	j++;
	
	tymsg->m_tp = chmsg[j++];
	j++;
	tymsg->m_tped = chmsg[j++];
	j++;
	tymsg->m_tpbl = chmsg[j++];
	j++;
	
	for (i=0; i<MSG_SMS; i++) {
		if (chmsg[j] == '\0') {
			break;
		}
		tymsg->m_msg[i] = chmsg[j++];
	}
	tymsg->m_msg[i] = '\0';
    return tymsg;
}
	// - 
char* strmsg_tymsg(char *chmsg, type_msg *tymsg) {
	int i, j = 0; 
	for (i=0; i<MSG_SMM; i++) {
		if (tymsg->m_mm[i] == '\0') {
			break;
		}
		chmsg[j++] = tymsg->m_mm[i];
	}
	chmsg[j++] = '#';
	
	for (i=0; i<MSG_SMM; i++) {
		if (tymsg->m_fromid[i] == '\0') {
			break;
		}
		chmsg[j++] = tymsg->m_fromid[i];
	}
	chmsg[j++] = '#';
	
	for (i=0; i<MSG_SMM; i++) {
		if (tymsg->m_toid[i] == '\0') {
			break;
		}
		chmsg[j++] = tymsg->m_toid[i];
	}
	chmsg[j++] = '#';
	
	chmsg[j++] = tymsg->m_tp;
	chmsg[j++] = '#';
	chmsg[j++] = tymsg->m_tped;
	chmsg[j++] = '#';
	chmsg[j++] = tymsg->m_tpbl;
	chmsg[j++] = '#';
	
	for (i=0; i<MSG_SMS; i++) {
		if (tymsg->m_msg[i] == '\0') {
			break;
		}
		chmsg[j++] = tymsg->m_msg[i];
	}	
	chmsg[j] = '\0';
	
	return chmsg;
}

