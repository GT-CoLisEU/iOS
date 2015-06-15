// CoLisEU RNP
//  Hop.m
//
//  Created by Cassiano Padilha on 19/11/14.
//  Copyright (c) 2014 cassiano Padilha. All rights reserved.
//

#import "Hop.h"

@implementation Hop
//Variaveis staticas para facil acesso
static Hop *HopsManager;
static NSMutableArray *hops;

@synthesize hostAddress = _hostAddress;
@synthesize hostName = _hostName;
@synthesize ttl = _ttl;
@synthesize time = _time;

- (Hop *)initWithHostAddress:(NSString *)hostAddress hostName:(NSString *)hostName ttl:(int)ttl time:(int)time
{
    _hostAddress = hostAddress;
    _hostName = hostName;
    _ttl = ttl;
    _time = time;
    
    NSLog(@"Hop[%d]=%@ %@ %dms",ttl,hostAddress,hostName,time);
  //  NSLog(@"");
    return self;
}

+ (Hop *)HopsManager
{
    if(!HopsManager) {
        HopsManager = [[self allocWithZone:NULL] init];
        hops = [[NSMutableArray alloc] init];
    }
    
    return HopsManager;
}

+ (Hop *)getHopAt:(int)pos
{
    //NSLog(@"getHopAt:%d",pos);
    if(pos >= [hops count]) {
        return hops[0];
    }
    return hops[pos];
}
//Adiciona hop
+ (void)addHop:(Hop *)hop{
    if (hop != nil)
        [hops addObject:hop];
}

//Retorna quantidade de hops encontrados (caminhos)
+ (int)hopsCount
{
    return [hops count];
}
+ (void)clear
{
    [hops removeAllObjects];
}

@end
