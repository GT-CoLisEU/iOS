//
//  RunPing.h
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 25/05/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoundTripTime.h"
#import "SimplePing.h"
#import "PingController.h"
#import "QoSObserver.h"

@interface RunPing : NSObject <SimplePingDelegate>{
    PingController *ping;
    BOOL isReady;
#pragma Implementing Bean/Observer
    NSMutableDictionary *observers;
}
@property (retain, nonatomic) NSMutableDictionary *observers;
@property (nonatomic, assign) BOOL isReady;
+(RunPing *)sharedInstance;
+(void) addObserver:(NSString *)key obj:(NSObject *)obj;
+(void) removeObserver:(NSString *)key;
-(void)runping;
-(void)LoadPing;
-(void) start;
@end
