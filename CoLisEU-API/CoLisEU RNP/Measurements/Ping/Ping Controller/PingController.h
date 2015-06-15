//
//  PingController.h
//  PingOBJc
//
//  Created by Cassiano Padilha on 12/05/15.
//  Copyright (c) 2015 cassiano Padilha. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SimplePing.h"
#include <netdb.h>
#include <sys/socket.h>
#include <time.h>
#include <sys/time.h>
#import "RoundTripTime.h"

@interface PingController : NSObject <SimplePingDelegate>{
    int ContRtt;
    BOOL repeat;
}
-(void)setrepeat;
-(id)init;
- (void)runWithHostName:(NSString *)hostName;
//-(void)startPinger;
-(void)startPinger:(NSString *)address;
-(void)stopPinging;
- (void) stopTimer;
@end
