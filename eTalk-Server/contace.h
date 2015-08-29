

//
//
//
//	联系人信息
//
//
#ifndef CONTACE_H
#define CONTACE_H
#include <stdio.h>
#include <string.h>
#include "eTalk.h"

typedef struct contace {
	char c_id[MSG_SID];
	char c_name[MSG_SNAME];
	char c_pw[MSG_SPW];
	char c_mm[MSG_SMM];
	char c_ip[30];
	char c_headImage[10];
} type_contace;

//联系人信息赋值
type_contace* contace_creat(type_contace *cont, char *id, char *pw, char *name, char *mm, char *ip);
//联系人比较
int contace_cmp(type_contace *acont, type_contace *bcont, int defcmp);

//显示表所有信息
char *sql_statement_sel_all(char *table_name, char *sql);
//创建表
char *sql_statement_creat_all_contaces(char *sql);
char *sql_statement_creat_contaces(type_contace *cont, char *sql);
char *sql_statement_creat_loginfo(char *sql);
//char *sql_statement_creat_unread_msg(char *sql);
//AllContaces
//char *sql_statement_add_all_contaces(type_contace *cont, char *sql);
char *sql_statement_del_all_contaces(type_contace *cont, char *sql);
char *sql_statement_count_all_contaces();
char *sql_statement_sel_all_contaces(type_contace *cont, char *sql);
char *sql_statement_sel_all_contacesinfo(char *sql);
//tablename ID
char *sql_statement_add_table_id(type_contace *from, type_contace *cont, char *sql);
char *sql_statement_del_table_id(type_contace *from, type_contace *cont, char *sql);
char *sql_statement_sel_table_id(type_contace *from, type_contace *cont, char *sql);
char *sql_statement_alltable_id(type_contace *from, char *sql);
/************************ login info *****************************/
char *sql_statement_add_loginfo(type_contace *cont, char *sql);
char *sql_statement_del_loginfo(type_contace *cont, char *sql);
char *sql_statement_del_all_loginfo(char *sql);
char *sql_statement_selmm_loginfo(type_contace *cont, char *sql);
char *sql_statement_selid_loginfo(type_contace *cont, char *sql);
/******************************************************************/



typedef struct {
	char m_mm[MSG_SMM];	//mm
	char m_fromid[MSG_SID];	//发出ID
	char m_toid[MSG_SID];	//目的ID
	char m_tp;		//type		10 - 16	int
	char m_tped;		//ed type	10 - 16 int
	char m_tpbl;		//bool		10 - 11 int
	char m_msg[MSG_SMS];	//msg
	char m_fromip[30];	//发送消息IP (只有在注册使用)
} type_msg;



#endif

