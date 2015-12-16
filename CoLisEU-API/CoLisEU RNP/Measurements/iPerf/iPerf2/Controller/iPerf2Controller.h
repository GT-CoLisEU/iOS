//
//  iPerf2Controller.h
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 27/10/15.
//  Copyright © 2015 GT-CoLisEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInfo.h"
#import "MPoint.h"
#import "User.h"
#import "RoundTripTime.h"
#import "DeviceInfo.h"
#import "ReviewList.h"
#import "NetworkTestList.h"
#import "Gateway.h"
@interface iPerf2Controller : UIViewController{
    BOOL testError;
    BOOL running;
    BOOL ready;
    BOOL TestComplete;
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
    NSString *nameTest;
    #pragma Implementing Bean/Observer
    NSMutableDictionary *observers;
    NSThread *thread;
    BOOL TypeTestReview;
    BOOL SentJson;
}
@property (retain, nonatomic) NSMutableDictionary *observers;
@property (retain, nonatomic) NSMutableArray *JitterDown, *JitterUp, *RTT, *TcpDown, *TcpUp, *UdpDown, *UdpUp,*Jitter;
@property (retain, nonatomic) NSString *LostPacketPercent,*nameTest;
@property (nonatomic,assign) BOOL TypeTestReview,running,SentJson,TestComplete;

-(void) startTCP;
-(void) startUDP;
+(iPerf2Controller*)getInstance;
-(BOOL) isRunning;
-(BOOL) isReady;
-(BOOL) error;
+(void) addObserver:(NSString *)key obj:(NSObject *)obj;
+(void) removeObserver:(NSString *)key;
@end
