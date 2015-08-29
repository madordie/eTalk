
#include "database.h"

extern sqlite3 *db; 
void clean_every_thing() {
	sqlite3_close(db);
}
	//创建需要的数据库，
int init_DB() {
	int rc;  
	char *zErrMsg = 0;  

	rc = sqlite3_open("eTalk.db", &db); //打开指定的数据库文件,如果不存在将创建一个同名的数据库文件  
	if( rc ) {  
		fprintf(stderr, "Can't open database: %s/n", sqlite3_errmsg(db));  
  		sqlite3_close(db);  
  		exit(1);  
	} 
	atexit(clean_every_thing);
		//创建 AllContaces 表,如果该表存在，则不创建，并给出提示信息，存储在 zErrMsg 中  
	char sql[200];
	sql_statement_creat_all_contaces(sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	if (zErrMsg)
       	printf("%s\n",zErrMsg);
       	
     	zErrMsg = 0;
      sql_statement_creat_loginfo(sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	if (zErrMsg)
       	printf("%s\n",zErrMsg);
       	
	return 1;
}
int sql_creat_tablename_id(type_contace cont) {
	char sql[100];
	char *zErrMsg = 0;
	sql_statement_creat_contaces(&cont, sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	if (zErrMsg)
       	printf("%s\n",zErrMsg);
}


/***************** 伪 数据库 实现 UnreadMsg ********************************/
int sql_add_UnreadMsg(type_contace from, type_contace cont, char *msg) {

	char path[50];
	sprintf(path, "%s_UnreadMsg", cont.c_id);
	
	FILE *file = fopen(path,"a");
	if(file == NULL) 
		return 0;
	if (msg != NULL)
		fprintf(file, "%s#%s\n", from.c_id, msg);
	fclose(file);
	return 1;	
}
int sql_find_UnreadMsg(type_contace cont, void (*fun)(type_contace, type_contace, char *)) {

	char path[50];
	sprintf(path, "%s_UnreadMsg", cont.c_id);
	
	FILE *file = fopen(path, "r");
	int read_t;
	char end[MSG_SMAX+11] = {0};
	char id[10];
	int end_size = MSG_SMAX+11;
	//printf("57:%s\n", cont.c_id);
	if (file == NULL)
		return 0;
	type_contace c;
	while (!feof(file)) {		// \n防止多读。。最后一个\n不加，系统会多读出一行消息出来，与实际存储不符
		fscanf(file, "\n%[^#]#%s\n", id, end);
		printf("\t\tunread:%s\n", id);
		contace_creat(&c, id, NULL, NULL, NULL, NULL);
		fun(cont, c, end);
    	}
	remove(path);
	return 1;
}
/********************************* LogInfo ***********************************************/
int sql_add_loginfo(type_contace cont) {
	char sql[100];
	char *zErrMsg = 0;
	sql_statement_add_loginfo(&cont, sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	if (zErrMsg != NULL) {
		printf("DB:add loginfo error:%s\n", zErrMsg);
        return 0;
    }
	return 1;
}
	//删除
int sql_del_loginfo(type_contace cont) {
	char sql[100];
	char *zErrMsg = 0;
	sql_statement_del_loginfo(&cont, sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	return 1;
}

int sql_del_all_loginfo() {
	char sql[100];
	char *zErrMsg = 0;
	sql_statement_del_all_loginfo(sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	return 1;
}
	//查找，根据cont.c_mm查找返回
type_contace *sql_find_loginfo(type_contace cont, int deftp) {
	char sql[100];
	int nrow = 0, ncolumn = 0;
	int i = 0 ;
	char **azResult; //二维数组存放结果
	char *zErrMsg = 0;
	type_contace *cp;
	
	if (deftp == SQL_LOGI_MM) {
		printf("查找登录信息的MM==%s==\n", cont.c_mm);
		sql_statement_selmm_loginfo(&cont, sql);
	} else if (deftp == SQL_LOGI_ID)
		sql_statement_selid_loginfo(&cont, sql);
	else 
		return NULL;
		
	  
 	sqlite3_get_table( db , sql , &azResult , &nrow , &ncolumn , &zErrMsg );  
   
 //	printf( "row:%d column=%d \n" , nrow , ncolumn );  
   	if (nrow == 0) {
   		printf("=sql:%s=%s==未检索到该用户！！\n", sql ,zErrMsg);
   		return NULL;//****************未检索到该用户************************
   	}
   	printf("正常的sql:%s\n", sql);
 	i=ncolumn;
	cp = (type_contace *)malloc(sizeof(type_contace));
	contace_creat(cp, azResult[i+1], NULL, NULL, azResult[i], azResult[i+2]);
	// printf("%s\n", cp->c_id);
 		//释放掉  azResult 的内存空间  
	sqlite3_free_table( azResult ); 
	return cp;
}


/**************************** AllContaces ***********************************************/
	//插入cont联系人到所有联系人DB中

int sql_add_all_contaces(type_contace cont) {
	sql_del_all_contaces(cont);
	
	char sql[100];
	char *zErrMsg=0;
	sql_statement_add_all_contaces(&cont, sql);
	sqlite3_exec( db , sql , 0 , 0 ,NULL);// &zErrMsg );
//	if (zErrMsg != NULL) {
//		printf("(DB 添加全部联系人失败):%s\n", zErrMsg);
//	}
	return 1;
}
	//删除
int sql_del_all_contaces(type_contace cont) {
	char sql[100];
	char *zErrMsg=0;
	sql_statement_del_all_contaces(&cont, sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	return 1;
}
    //统计用户数
int sql_count_all_contaces () {
    char *sql = sql_statement_count_all_contaces();
    int nrow = 0, ncolumn = 0;
    int i = 0;

    char **azResult;
    char *zErrMsg = 0;
    sqlite3_get_table(db, sql, &azResult, &nrow, &ncolumn, &zErrMsg);
    return 1;

}
	//查找，根据cont.c_id查找返回
type_contace* sql_find_all_contaces(type_contace cont, type_msg *msg, void (*fun)(type_contace , type_msg*)) {
	char sql[100];
	int nrow = 0, ncolumn = 0;
	int i = 0 ;
	char **azResult; //二维数组存放结果
	char *zErrMsg = 0;
	
	type_contace *cp;
	if (strlen(cont.c_id) == 0) {
   		
		sql_statement_sel_all_contacesinfo(sql);
 		sqlite3_get_table( db , sql , &azResult , &nrow , &ncolumn , &zErrMsg );  
 		for( i=ncolumn ; i<( nrow + 1 ) * ncolumn ; i +=ncolumn ) {
 			type_contace c;
 			contace_creat(&c,  azResult[i], azResult[i+1], azResult[i+2], NULL, NULL);
 			strcpy(c.c_headImage, azResult[i+3]);
 			fun(c, msg);
 		} 
   	}  else {
   	
		sql_statement_sel_all_contaces(&cont, sql);
 		sqlite3_get_table( db , sql , &azResult , &nrow , &ncolumn , &zErrMsg );  
 		printf( "row:%d column=%d \n" , nrow , ncolumn );  
   		if (nrow == 0) {
   			return NULL;//****************未检索到该用户************************
   		}
 		cp = (type_contace *)malloc(sizeof(type_contace));
 		i=ncolumn;
 		contace_creat(cp, azResult[i], azResult[i+1], azResult[i+2], NULL, NULL);
 			strcpy(cp->c_headImage, azResult[i+3]);
 		printf("ID:%s\tPW:%s\tname:%s\n", cp->c_id, cp->c_pw, cp->c_name);
 		if (fun != NULL)
 			fun(*cp, msg);
   	}
 		//释放掉  azResult 的内存空间  
	sqlite3_free_table( azResult ); 
	return cp;
}


/*********************** tablename id **********************************/

int sql_add_tablename_id(type_contace from, type_contace cont) {
	char sql[100];
	char *zErrMsg = 0;
	sql_creat_tablename_id(from);
	sql_statement_add_table_id(&from, &cont, sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	printf("sql:%s", sql);
	printf("error:%s\n",zErrMsg);
	return 1;
}
int sql_del_tablename_id(type_contace from, type_contace cont) {
	char sql[100];
	char *zErrMsg = 0;
	sql_statement_del_table_id(&from, &cont, sql);
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
	return 1;
}
int sql_find_tablename_id(type_contace from, type_contace cont, void (*fun)(type_contace )) {
	char sql[100];
	int nrow = 0, ncolumn = 0;
	int i = 0 ;
	char **azResult; //二维数组存放结果
	char *zErrMsg = 0;
	
	sql_statement_sel_table_id(&from, &cont, sql);
	  
 	sqlite3_get_table( db , sql , &azResult , &nrow , &ncolumn , &zErrMsg );  
   
 	printf( "row:%d column=%d \n" , nrow , ncolumn );  
 	
 	for( i=ncolumn ; i<( nrow + 1 ) * ncolumn ; i ++ ) {
 		type_contace c;
 		contace_creat(&c, azResult[i], NULL, NULL, NULL, NULL);
 		fun(c);
 	} 
 		//释放掉  azResult 的内存空间  
	sqlite3_free_table( azResult ); 
}


int sql_all_tablename_id(type_contace from,  void (*fun)(type_contace )) {
	char sql[100];
	int nrow = 0, ncolumn = 0;
	int i = 0 ;
	char **azResult; //二维数组存放结果
	char *zErrMsg = 0;
	
	sql_statement_alltable_id(&from,  sql);
	  
 	sqlite3_get_table( db , sql , &azResult , &nrow , &ncolumn , &zErrMsg );  
   
 	printf( "row:%d column=%d \n" , nrow , ncolumn );  
 	
 	for( i=ncolumn ; i<( nrow + 1 ) * ncolumn ; i ++ ) {
 		type_contace c;
 		strcpy(c.c_ip, from.c_ip);
 		strcpy(c.c_mm, from.c_mm);
 		contace_creat(&c, azResult[i], NULL, NULL, NULL, NULL);
 		fun(c);
 	} 
 		//释放掉  azResult 的内存空间  
	sqlite3_free_table( azResult ); 
}

/*************************** show all ********************************************/


int show_all(char *table_name) {
	char sql[100];
	int nrow = 0, ncolumn = 0;
	int i = 0 ;
	char **azResult; //二维数组存放结果
	char *zErrMsg = 0;
	
	sql_statement_sel_all(table_name, sql);
	  
  
 	sqlite3_get_table( db , sql , &azResult , &nrow , &ncolumn , &zErrMsg );  
   
 	printf( "row:%d column=%d \n" , nrow , ncolumn );  
 	printf( "The result of querying is : \n" );  
   
 	for( i=0 ; i<( nrow + 1 ) * ncolumn ; i++ )  
  	printf( "azResult[%d] = %s\n", i , azResult[i] );  
 		//释放掉  azResult 的内存空间  
	sqlite3_free_table( azResult );  
   	printf( "The result of querying end\n\n" );  
    ncolumn = ncolumn==0?1:ncolumn;
   return nrow;
    return i/(ncolumn+1);
/*
The result of querying is : 
azResult[0] = ID
azResult[1] = pw
azResult[2] = name
azResult[3] = 123456
azResult[4] = 789

*/
}

