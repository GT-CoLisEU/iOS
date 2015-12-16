//
//  TracerouteController.h
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 08/07/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPoint.h"
#import "BDHost.h"
#import "TraceRoute.h"
#import "HopCell.h"
#import "NetworkInfo.h"

@interface TracerouteController : UIViewController<UITableViewDelegate,UITableViewDataSource,TraceRouteDelegate,UITextFieldDelegate> {
    
    TraceRoute *traceRoute;
    NSUserDefaults *prefs;
    NSString *hopCellNibName;
    NSMutableArray *traceroutes;
}

@property (nonatomic, assign) BOOL slideOutAnimationEnabled;
@property (weak, nonatomic) IBOutlet UILabel *lbSSIDtoMpoint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
