//
//  JGSockte.m
//  eTalk-4.1
//
//  Created by madordie on 14-8-19.
//  Copyright (c) 2014年 Madordie. All rights reserved.
//

#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import "JGSocket.h"

@interface JGSocket ()
{
    int _listenSockfd;
}
@end
@implementation JGSocket

- (void)stopListen {
    _isListing = NO;
}
- (void)startListenPort:(NSInteger)port {
    _isListing = YES;
    dispatch_queue_t queue = dispatch_queue_create("listenMsg", NULL);
    dispatch_async(queue, ^{
    });
    
        //监听已经存在，激活监听。
    if (_listenSockfd) {
        int ssockfd = _listenSockfd;
        if(listen(ssockfd, 253) == -1){
            perror("listen");
            JGSocketError(JGSocketErrorTypeListen);
            close(ssockfd);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self listenSocketWithPort:port];
    });
}

- (void)listenSocketWithPort:(NSInteger )port {
	int ssockfd;
	if((ssockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket");
        JGSocketError(JGSocketErrorTypeCreat);
	}
    
    _listenSockfd = ssockfd;
    
	struct sockaddr_in ssockaddr;
	ssockaddr.sin_family	= AF_INET;
	ssockaddr.sin_port	= htons(port);
	ssockaddr.sin_addr.s_addr = INADDR_ANY;
	bzero(&ssockaddr.sin_zero, 8);
    
	int i = 1;
	setsockopt(ssockfd, SOL_SOCKET, SO_REUSEADDR, &i, sizeof(i));
    
	if(bind(ssockfd, (struct sockaddr *)&ssockaddr, sizeof(struct sockaddr)) == -1){
		perror("bind");
        JGSocketError(JGSocketErrorTypeBind);
        close(ssockfd);
	}
    
	if(listen(ssockfd, 253) == -1){
		perror("listen");
        JGSocketError(JGSocketErrorTypeListen);
        close(ssockfd);
	}
    
	struct sockaddr_in csockaddr;
	int csockfd;
	socklen_t sin_size;
    //同意接入并接受处理信息
	while(_isListing){
        NSLog(@"lintening.....");
		if((csockfd = accept(ssockfd, (struct sockaddr*)&csockaddr, &sin_size)) == -1){
			perror("accept");
            JGSocketError(JGSocketErrorTypeAccpet);
		}
        char buf[1040] = {0};
        NSInteger recv_size;
        
        if((recv_size = recv(csockfd, buf, 1040, 0)) < 0){
            perror("recv");
            JGSocketError(JGSocketErrorTypeRecv);
        }
        if ([_delegate respondsToSelector:@selector(socket:receiveNews:)]) {
            NSString *new = [NSString stringWithUTF8String:buf];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate socket:self receiveNews:new];
            });
            continue;
        }
        NSLog(@"代理未设置，无处理消息对象");
        
        //            // goto main thread  recv msg then action
        //        dispatch_sync(dispatch_get_main_queue(), ^{
        //            NSLog(@"main thread is ok ");
        //        });
        
	}
}

- (void)sendMsg:(NSString *)msg ip:(NSString *)ip port:(NSInteger)port {
    if (!ip) {
        return;
    }
    dispatch_queue_t queue = dispatch_queue_create("sendMsg", NULL);
    dispatch_async(queue, ^{
        
        struct sockaddr_in yousockaddr;
        
        yousockaddr.sin_family = AF_INET;
        yousockaddr.sin_port = htons(port);
        yousockaddr.sin_addr.s_addr =  inet_addr([ip cStringUsingEncoding:NSUTF8StringEncoding]);//change_addr(IP_SERVERIP);
        bzero(&yousockaddr.sin_zero, 8);
        
        int mysockfd;
        if((mysockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
            perror("socket");
            JGSocketError(JGSocketErrorTypeCreat);
        }
        
        struct sockaddr_in mysockaddr;
        mysockaddr.sin_family	= AF_INET;
        mysockaddr.sin_port	= htons(8080);
        mysockaddr.sin_addr.s_addr = INADDR_ANY;
        bzero(&mysockaddr.sin_zero, 8);
        
        
        
        if(connect(mysockfd, (struct sockaddr *)&yousockaddr, sizeof(struct sockaddr)) == -1){
            perror("connect");
            JGSocketError(JGSocketErrorTypeCreat);
            close(mysockfd);
        }
        const char *strmsg = [msg UTF8String];
        if(send(mysockfd, strmsg, strlen(strmsg), 0) == -1){
            perror("send");
            JGSocketError(JGSocketErrorTypeBind);
            close(mysockfd);
        }
        close(mysockfd);

    });
    
}


@end
