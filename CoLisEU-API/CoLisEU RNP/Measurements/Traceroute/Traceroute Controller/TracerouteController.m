//
//  TracerouteController.m
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 08/07/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import "TracerouteController.h"

@implementation TracerouteController

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}
-(void)viewDidLoad{
    NetworkInfo *net = [[NetworkInfo alloc]init];
    MPoint *mp = [MPoint sharedMPoint];
    
    self.lbSSIDtoMpoint.text = [NSString stringWithFormat:@"%@ to %@",[net getL3address],[mp address]];
    
    [super viewDidLoad];
    
    traceroutes = [[NSMutableArray alloc]init];

    [_activityIndicator setColor:[UIColor blueColor]];
    [_activityIndicator setHidden:FALSE];
    [_activityIndicator setHidesWhenStopped:TRUE];
    NSInteger ttl = TRACEROUTE_MAX_TTL;
    NSInteger timeout = TRACEROUTE_TIMEOUT;
    NSInteger port = TRACEROUTE_PORT;
    NSInteger maxAttempts = TRACEROUTE_ATTEMPTS;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    traceRoute = [[TraceRoute alloc] initWithMaxTTL:(int)ttl timeout:(int)timeout maxAttempts:(int)maxAttempts port:(int)port];
    
    
    [traceRoute setDelegate:self];

    [self StartTraceroute];
}
-(void)StartTraceroute{
    MPoint *mp = [MPoint sharedMPoint];
    NSString *hostDest = [mp address];
    [NSThread detachNewThreadSelector:@selector(doTraceRoute:) toTarget:traceRoute withObject:hostDest];
}
- (void)newHop:(Hop *)hop
{
    [_tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TraceRoute hopsCount];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetworkInfo *net = [[NetworkInfo alloc]init];
    static NSString *CellIdentifier = @"HopCell";
    HopCell *cell = (HopCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell == nil) {
        cell = [[HopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Hop *hop = [Hop getHopAt:0];
    hop = [Hop getHopAt:(int)indexPath.row];
    if(hop != nil) {
        cell.lbhostAddress.text = hop.hostAddress;
        if(hop.time == -50)
            cell.lbTime.text = [net getL3address];
        else
            cell.lbTime.text = [NSString stringWithFormat:@"%i ms",hop.time];
        if(![traceroutes containsObject:hop.hostAddress])
            [traceroutes addObject:hop.hostAddress];
        [cell setNeedsDisplay];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
