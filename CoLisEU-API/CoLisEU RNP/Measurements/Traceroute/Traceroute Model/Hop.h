///  CoLisEU RNP
//  Hop.h
//
//  Created by Cassiano Padilha on 19/11/14.
//  Copyright (c) 2014 cassiano Padilha. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Hop : NSObject {
}

@property NSString *hostAddress;
@property NSString *hostName;
@property int ttl;
@property int time;

- (Hop *)initWithHostAddress:(NSString *)hostAddress hostName:(NSString *)hostName ttl:(int)ttl time:(int)time;
+ (Hop *)HopsManager;
+ (Hop *)getHopAt:(int)pos;
+ (void)addHop:(Hop *)hop;
+ (int)hopsCount;
+ (void)clear;
@end
