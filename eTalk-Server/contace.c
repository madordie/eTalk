#include "contace.h"

type_contace* contace_creat(type_contace *cont, char *id, char *pw, char *name, char *mm, char *ip) {
	if (id)
		strcpy(cont->c_id, id);
	if (pw)
		strcpy(cont->c_pw, pw);
	if (name)
		strcpy(cont->c_name, name);
	if (mm)
		strcpy(cont->c_mm, mm);
	if (ip)
		strcpy(cont->c_ip, ip);
	strcpy(cont->c_headImage, "");
	return cont;
}
int contace_cmp(type_contace *acont, type_contace *bcont, int defcmp) {
	switch (defcmp) {
		case CMP_CONT_IDPW:
			if ((!strcmp(acont->c_id, bcont->c_id)) && (!strcmp(acont->c_pw, bcont->c_pw))) {
				return return_IDPW_OK;
			} else {
				return return_IDPW_NO;
			}
			break;
	}
	return return_OPERERROR;
}

/*************************** creat table ************************************/

char *sql_statement_creat_all_contaces(char *sql) {
	sprintf(sql, "create table \"%s\" (\"ID\" char(10) not null PRIMARY KEY, \
            \"pw\" char(20),\"name\" char(10),\"headImage\" char(10))", db_tablename_AllContaces);
	return sql;
}
char *sql_statement_creat_contaces(type_contace *cont, char *sql) {
	sprintf(sql, "create table \"%s\" (\"ID\" char(10) not null PRIMARY KEY)", cont->c_id);
    printf("===sql:%s\n", sql);
	return sql;
}
char *sql_statement_creat_loginfo(char *sql) {
	sprintf(sql, "create table \"%s\" (\"MM\" char(10) not null PRIMARY KEY, \
            \"ID\" char(10),\"ip\" char(30))", db_tablename_loginfo);
	return sql;
}

/************************ login info *****************************/
char *sql_statement_add_loginfo(type_contace *cont, char *sql) {
	sprintf(sql, "insert into \"%s\" (\"MM\",\"ID\",\"ip\") values (\"%s\",\"%s\",\"%s\")",
            db_tablename_loginfo, cont->c_mm, cont->c_id, cont->c_ip);
	return sql;
}
char *sql_statement_del_loginfo(type_contace *cont, char *sql) {
	sprintf(sql, "delete from \"%s\" where \"MM\"like\"%s\"",
            db_tablename_loginfo, cont->c_mm);
	return sql;
}
char *sql_statement_selmm_loginfo(type_contace *cont, char *sql) {
	sprintf(sql, "select * from \"%s\" where \"MM\"like\"%s\"",
            db_tablename_loginfo, cont->c_mm);
    printf("sql语句中组装MM:=%s=\n",cont->c_mm );
	return sql;
}
char *sql_statement_selid_loginfo(type_contace *cont, char *sql) {
	sprintf(sql, "select * from \"%s\" where \"ID\"like\"%s\"",
            db_tablename_loginfo, cont->c_id);
	return sql;
}

char *sql_statement_del_all_loginfo(char *sql) {
	sprintf(sql, "delete from \"%s\" ", db_tablename_loginfo);
	return sql;
}

/*************************** AllContaces ************************************/

char *sql_statement_count_all_contaces(){
    char sql[100];
    sprintf(sql, "select count(*) from \"%s\"", db_tablename_AllContaces);
    return sql;
}

char *sql_statement_add_all_contaces(type_contace *cont, char *sql) {
	sprintf(sql, "insert into \"%s\" (\"ID\",\"pw\",\"name\",\"headImage\") values (\"%s\",\"%s\",\"%s\",\"%s\")",
            db_tablename_AllContaces, cont->c_id, cont->c_pw, cont->c_name, cont->c_headImage);
	return sql;
}
char *sql_statement_del_all_contaces(type_contace *cont, char *sql) {
	sprintf(sql, "delete from \"%s\" where \"ID\"like\"%s\"",
            db_tablename_AllContaces, cont->c_id);
	return sql;
}
char *sql_statement_sel_all_contaces(type_contace *cont, char *sql) {
	sprintf(sql, "select * from \"%s\" where \"ID\"like\"%s\"",
            db_tablename_AllContaces, cont->c_id);
	return sql;
}

char *sql_statement_sel_all_contacesinfo(char *sql) {
	sprintf(sql, "select * from \"%s\"",
            db_tablename_AllContaces);
	return sql;
}
/**************************** tablename ID ***********************************/

char *sql_statement_add_table_id(type_contace *from, type_contace *cont, char *sql) {
	sprintf(sql, "insert into \"%s\" (ID) values (\"%s\")",
            from->c_id, cont->c_id);
	return sql;
}
char *sql_statement_del_table_id(type_contace *from, type_contace *cont, char *sql) {
	sprintf(sql, "delete from \"%s\" where \"ID\"like\"%s\"",
            from->c_id, cont->c_id);
	return sql;
}
char *sql_statement_sel_table_id(type_contace *from, type_contace *cont, char *sql) {
	sprintf(sql, "select * from \"%s\" where \"ID\"like\"%s\"",
            from->c_id, cont->c_id);
	return sql;
}

char *sql_statement_alltable_id(type_contace *from, char *sql) {
	sprintf(sql, "select * from \"%s\"", from->c_id);
	return sql;
}
/************************ show all ***************************************/

char *sql_statement_sel_all(char *table_name, char *sql) {
	sprintf(sql, "select * from \"%s\" ",
            table_name);
	return sql;
}

