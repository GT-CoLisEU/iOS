//
//  RunPing.m
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 25/05/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import "RunPing.h"
#import "MPoint.h"
@implementation RunPing
@synthesize observers;
@synthesize isReady;
+(RunPing *)sharedInstance{
    NSLog(@"shared instance rtt");
    static RunPing *sharedMPoint = nil;
    static dispatch_once_t onceToken;
    RoundTripTime *roud = [RoundTripTime getInstance];
    roud.rttlist = [[NSMutableArray alloc]init];
    dispatch_once(&onceToken, ^{
        sharedMPoint = [[self alloc] init];
    });
    return sharedMPoint;
}
-(instancetype)init{
    NSLog(@"init runping");
    observers = [[NSMutableDictionary alloc]init];
    ping = [[PingController alloc]init];
    [self runping];
    return self;
}
-(void) start{
    RoundTripTime *roud = [RoundTripTime getInstance];
    roud.rttlist = [[NSMutableArray alloc]init];
    [self runping];
}
-(void)runping{
    NSLog(@"run ping");
    MPoint *mp = [MPoint sharedMPoint];
    NSLog(@"addressss %@",mp.address);
    if(!isReady)
        [ping runWithHostName:mp.address];
    else{
        NSLog(@"start pinger");
        [ping startPinger:mp.address];
    }
    [NSThread detachNewThreadSelector:@selector(LoadPing) toTarget:self withObject:nil];
}

-(void)LoadPing{
    RoundTripTime *rttt = [RoundTripTime getInstance];
    NSLog(@"Tamanho lista %lu",(unsigned long)[rttt.rttlist count]);
    while ([rttt.rttlist count] < 5) 
        ;;
    [ping stopPinging];
    [self notifyAll:RTT];
    isReady = true;

    NSLog(@"pings %@",rttt.rttlist);
}

-(void) notifyAll: (TestType) msg{
    NSLog(@"msg %u",msg);
    NSLog(@"all values %@",observers.allValues);
    for (id <QoSObserver> obj  in observers.allValues){
        NSLog(@"obj %@",obj);
        [obj update:msg];
    }
}
+(void) addObserver:(NSString *)key obj:(NSObject *)obj{
    NSLog(@"add observer pig %@, %@",key,obj);
    RunPing *sc = [RunPing sharedInstance];
    sc.observers[key] = obj;
}
+(void) removeObserver:(NSString *)key{
    RunPing *sc = [RunPing sharedInstance];
    [sc.observers removeObjectForKey:key];
}
@end
