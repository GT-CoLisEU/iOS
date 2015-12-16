//
//  IPerfController.h
//  CoLisEU RNP
//
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPoint.h"
#import "iperf_api.h"
#import "SlideNavigationController.h"
#import <UIKit/UIKit.h>
#import "DeviceInfo.h"
#import "NetworkInfo.h"

#import "iperf_config.h"

#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <getopt.h>
#import <errno.h>
#import <signal.h>
#import <unistd.h>
#ifdef HAVE_STDINT_H
#import <stdint.h>
#endif
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#ifdef HAVE_STDINT_H
#import <stdint.h>
#endif
#import <netinet/tcp.h>

#import "iperf.h"
#import "utilVariables.h" // largura da banda UPLOAD para UDP e TCP
#import "iperf_api.h"
#import "units.h"
#import "iperf_locale.h"
#import "net.h"


#import "SimplePing.h"
#import <sys/socket.h>
#import <netdb.h>
#import <time.h>
#import <sys/time.h>

#import "Variables.h"
#import "MPoint.h"
#import "QoSObserver.h"




@interface IPerfController : NSObject{
    BOOL testError;
    BOOL running;
    BOOL ready;
    NSString *server;
    NSMutableArray *Jitter;
    NSMutableArray *JitterDown;
    NSMutableArray *JitterUp;
    NSMutableArray *RTT;
    NSMutableArray *TcpDown;
    NSMutableArray *TcpUp;
    NSMutableArray *UdpDown;
    NSMutableArray *UdpUp;
    NSString *LostPacketPercent;
#pragma Implementing Bean/Observer
    NSMutableDictionary *observers;
    NSThread *thread;
}
@property (retain, nonatomic) NSMutableDictionary *observers;
@property (retain, nonatomic) NSMutableArray *JitterDown, *JitterUp, *RTT, *TcpDown, *TcpUp, *UdpDown, *UdpUp,*Jitter;
@property (retain, nonatomic) NSString *LostPacketPercent;

-(void) startUDP;
-(void) startTCP;
-(void) start;
-(void) stop;
-(void)clearLists;
+ (IPerfController*)getInstance;
-(BOOL) isRunning;
-(BOOL) isReady;
-(BOOL) error;
+(void) addObserver:(NSString *)key obj:(NSObject *)obj;
+(void) removeObserver:(NSString *)key;
@end
