//  CoLisEU RNP
//  TraceRoute.h
//  Traceroute
//
//  Created by Cassiano Padilha on 19/11/14.
//  Copyright (c) 2014 cassiano Padilha. All rights reserved.
//


#import <Foundation/Foundation.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#import "Hop.h"

static const int TRACEROUTE_PORT     = 80;
static const int TRACEROUTE_MAX_TTL  = 20;
static const int TRACEROUTE_ATTEMPTS = 2;
static const int TRACEROUTE_TIMEOUT  = 5000000;

@protocol TraceRouteDelegate

- (void)newHop:(Hop *)hop;
- (void)end;
- (void)error:(NSString *)errorDesc;

@end

@interface TraceRoute : NSObject{
    
    int udpPort;
    int maxTTL;
    int readTimeout;
    int maxAttempts;
    NSString *running;
    bool isrunning;
}

@property (nonatomic, weak) id<TraceRouteDelegate> delegate;

- (TraceRoute *)initWithMaxTTL:(int)ttl timeout:(int)timeout maxAttempts:(int)attempts port:(int)port;
- (Boolean)doTraceRouteToHost:(NSString *)host maxTTL:(int)ttl timeout:(int)timeout maxAttempts:(int)attempts port:(int)port;
- (Boolean)doTraceRouteToHost:(NSString *)host;
- (void)stopTrace;
+ (int)hopsCount;
@property (NS_NONATOMIC_IOSONLY, getter=isRunning, readonly) bool running;
+ (long)getMicroSeconds;
+ (long)computeDurationSince:(long)uTime;

@end
