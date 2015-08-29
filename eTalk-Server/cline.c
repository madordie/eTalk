
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <error.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <signal.h>
#include "sqlite3.h"


int net_send(char *msg) {
	struct sockaddr_in yousockaddr;
	yousockaddr.sin_family = AF_INET;
	yousockaddr.sin_port = htons(8998);
	yousockaddr.sin_addr.s_addr = inet_addr("192.168.1.10");
	bzero(&yousockaddr.sin_zero, 8);
	
	int mysockfd;
	if((mysockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket");
		exit(1);
	} 

	struct sockaddr_in mysockaddr;
	mysockaddr.sin_family	= AF_INET;
	mysockaddr.sin_port	= htons(8080);
	mysockaddr.sin_addr.s_addr = INADDR_ANY;
	bzero(&mysockaddr.sin_zero, 8);
	
	
	
	if(connect(mysockfd, (struct sockaddr *)&yousockaddr, sizeof(struct sockaddr)) == -1){
		perror("connect");
		exit(1);
	}
	if(send(mysockfd, msg, strlen(msg), 0) == -1){
		perror("send");
		exit(1);
	}
	close(mysockfd);
	
	return 1;
}

int main () {int rc;  
	char *zErrMsg = 0;  

sqlite3 *db; 
	rc = sqlite3_open("eTalk.db", &db); //打开指定的数据库文件,如果不存在将创建一个同名的数据库文件  
	if( rc ) {  
		fprintf(stderr, "Can't open database: %s/n", sqlite3_errmsg(db));  
  		sqlite3_close(db);  
  		exit(1);  
	} 
		//创建 AllContaces 表,如果该表存在，则不创建，并给出提示信息，存储在 zErrMsg 中  
	char sql[100];
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
       	printf("%s\n",zErrMsg);
       	
	sqlite3_exec( db , sql , 0 , 0 , &zErrMsg );
       	printf("%s\n",zErrMsg);
       	
	return 1;	
}
