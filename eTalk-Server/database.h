
//
//	database.h
//	数据库的所有操作函数
//		所有数据均存储于文件中
//	
//	db_xx()
//
//		sqlite 3 数据库
//

#ifndef DATABASE_H
#define DATABASE_H

#include <stdio.h>
#include <stdlib.h>

#include "contace.h"
#include "sqlite3.h"

sqlite3 *db; 
	//清理
void clean_every_thing();
	//创建需要的数据库，
int init_DB();
int sql_creat_tablename_id(type_contace cont);
/********************************** 伪 数据库 实现 UnreadMsg ***********************************************/
int sql_add_UnreadMsg(type_contace from, type_contace cont, char *msg);
					//发送给cont			cont		谁发的        msg
int sql_find_UnreadMsg(type_contace cont, void (*fun)(type_contace, type_contace, char *));

/********************************** AllContaces **************************************************/
    //统计全部联系人
int sql_count_all_contaces();
    //插入cont联系人到所有联系人DB中
int sql_add_all_contaces(type_contace cont);
	//删除
int sql_del_all_contaces(type_contace cont);
	//查找，根据cont.c_id查找返回	//采用回调函数，，一次处理一个
type_contace* sql_find_all_contaces(type_contace cont, type_msg *msg, void (*fun)(type_contace , type_msg*));

/************************ tablename id ********************************************/
int sql_add_tablename_id(type_contace from, type_contace cont);
int sql_del_tablename_id(type_contace from, type_contace cont);
int sql_find_tablename_id(type_contace from, type_contace cont, void (*fun)(type_contace ));
int sql_all_tablename_id(type_contace from,  void (*fun)(type_contace ));

/********************************* LogInfo ***********************************************/
int sql_add_loginfo(type_contace cont);
	//删除
int sql_del_loginfo(type_contace cont);	
int sql_del_all_loginfo();
	//查找，根据deftp返回  deftp:SQL_LOGI_ID     SQL_LOGI_MM
type_contace* sql_find_loginfo(type_contace cont, int deftp);


int show_all(char *table_name);

#endif

