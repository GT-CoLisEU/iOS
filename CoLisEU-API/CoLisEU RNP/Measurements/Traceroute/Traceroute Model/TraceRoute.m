///  CoLisEU RNP
//  TraceRoute.m
//  Traceroute
//
//  Created by Cassiano Padilha on 19/11/14.
//  Copyright (c) 2014 cassiano Padilha. All rights reserved.
//

#import "TraceRoute.h"
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/time.h>
#import "BDHost.h"
#import <net/if.h>
#import <net/if_dl.h>
#import <resolv.h>
@implementation TraceRoute

- (TraceRoute *)initWithMaxTTL:(int)ttl timeout:(int)timeout maxAttempts:(int)attempts port:(int)port
{
    [Hop HopsManager];
    maxTTL = ttl;
    udpPort = port;
    readTimeout = timeout;
    maxAttempts = attempts;
    
    return self;
}
-(Boolean)doTraceRouteToHost:(NSString *)host{

    return true;
}
- (Boolean)doTraceRouteToHost:(NSString *)host maxTTL:(int)ttl timeout:(int)timeout maxAttempts:(int)attempts port:(int)port
{
    maxTTL = ttl;
    udpPort = port;
    readTimeout = timeout;
    maxAttempts = attempts;
    return [self doTraceRoute:host];
}
//Executa TraceRoute
- (Boolean)doTraceRoute:(NSString *)host{
    struct hostent *host_entry = gethostbyname(host.UTF8String);
    char *ip_addr;
    ip_addr = inet_ntoa(*((struct in_addr *)host_entry->h_addr_list[0]));
    struct sockaddr_in destination,fromAddr;
    int recv_sock;
    int send_sock;
    Boolean error = false;
    
    isrunning = true;
    [Hop clear];
    
    if ((recv_sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP)) < 0) {
        if(_delegate != nil) {
            [_delegate error:@"Could not create recv socket"];
        }
        return false;
    }
    if((send_sock = socket(AF_INET , SOCK_DGRAM,0))<0){
        if(_delegate != nil) {
            [_delegate error:@"Could not create xmit socket"];
        }
        return false;
    }
    memset(&destination, 0, sizeof(destination));
    destination.sin_family = AF_INET;
    destination.sin_addr.s_addr = inet_addr(ip_addr);
    destination.sin_port = htons(udpPort);
    struct timeval tv;

    
    
    tv.tv_sec = 0;
    tv.tv_usec = readTimeout;
    setsockopt(recv_sock, SOL_SOCKET, SO_RCVTIMEO, (char *)&tv,sizeof(struct timeval));
    char *cmsg = "GET / HTTP/1.1\r\n\r\n";
    socklen_t n= sizeof(fromAddr);
    char buf[100];
    
    int ttl = 1;
    
    bool icmp = false;
    Hop *routeHop;
    long startTime;
    int delta;
    
    routeHop = [[Hop alloc]init];
    
    while(ttl <= maxTTL) {
        memset(&fromAddr, 0, sizeof(fromAddr));
        if(setsockopt(send_sock, IPPROTO_IP, IP_TTL, &ttl, sizeof(ttl)) < 0) {
            error = true;
            if(_delegate != nil) {
                [_delegate error:@"setsockopt failled"];
            }
        }
        icmp = false;
        for(int try = 0;try < maxAttempts;try++) {
            delta = -1;
            startTime = [TraceRoute getMicroSeconds];
            if (sendto(send_sock,cmsg,sizeof(cmsg),0,(struct sockaddr *) &destination,sizeof(destination)) != sizeof(cmsg) ) {
                error = true;
            }
            int res = 0;
            if( (res = recvfrom(recv_sock, buf, 100, 0, (struct sockaddr *)&fromAddr,&n))<0) {
                error = true;
            } else {
                delta = [TraceRoute computeDurationSince:startTime];
                char display[16]={0};
                icmp = true;
                inet_ntop(AF_INET, &fromAddr.sin_addr.s_addr, display, sizeof (display));
                char hn[254];

                gethostname(hn, 254);
                struct hostent *hp;
                hp = gethostbyname(hn);
                //char *dn = strchr(hp->h_name, '.');
                //if ( dn != NULL ) {
                 //   NSLog(@"host %s",++dn);
                //}
        
                NSString *hostAddress = [NSString stringWithFormat:@"%s",display];
                NSString *hostName = [BDHost hostnameForAddress:hostAddress];
                routeHop = [[Hop alloc] initWithHostAddress:hostAddress hostName:hostName ttl:ttl time:delta];
                [Hop addHop:routeHop];
                break;
            }
        }
        //Quando o tempo excede 3 segundos para encontrar algum hop (adiciona asterisco)
        if(!icmp) {
            routeHop = [[Hop alloc] initWithHostAddress:@"*" hostName:@"*" ttl:ttl time:-1];
            ttl = maxTTL; //Parar procura, apenas para não ter mais de um "asterisco", mas não significa que é o fim da rota
            [Hop addHop:routeHop];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_delegate != nil) {
                [_delegate newHop:routeHop];
            }
        });
        ttl++;
    }
    isrunning = false;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate end];
    });
    return error;
}
- (void)stopTrace
{
    @synchronized(running) {
        isrunning = false;
    }
}
+ (int)hopsCount
{
    return [Hop hopsCount];
}
- (bool)isRunning
{
    return isrunning;
}
+ (long)getMicroSeconds
{
    struct timeval time;
    gettimeofday(&time, NULL);
    return time.tv_usec;
}
//Calcular tempo em microsegundos
+ (long)computeDurationSince:(long)uTime
{
    long now = [TraceRoute getMicroSeconds];
    if(now < uTime) {
        return (1000000 - uTime + now)/1000;
    }
    return (now - uTime)/1000;
}

@end
