//
//  RTTViewController.h
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 08/06/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "MPoint.h"
#import "DeviceInfo.h"
#import "NetworkInfo.h"
#import "PingController.h"
#import "MBProgressHUD.h"
#import "RoundTripTime.h"
#import "CPDScatterPlotViewController.h"
#import "RunPing.h"
#import "ScreenLoadController.h"
#import "SlideNavigationController.h"
#import "Translate.h"
#import "NetworkTestList.h"
@interface RTTViewController : UIViewController <CPTPlotDataSource>{
@private
    MBProgressHUD *hud;
    CPTGraph *graph;
    CPTScatterPlot *aaplPlot;
    CPTScatterPlot *googPlot;
    CPTScatterPlot *msftPlot;
    int TestSelected;
    NSString  *NameTestSelected;
    NSNumber *AverageRTT;
    NSInteger majorIncrement;
    NSInteger minorIncrement;    ///Incromentos entre as linhas
    PingController *ping;
    BOOL Ploted;
    @private
        int contador;
    @private
        double acumulador;
    @private
        double rtt;
    NSMutableArray *valorRTT;
    UIAlertView *StartTest;
    
    NSMutableArray *graphRTT;
    NSMutableArray *plotRTT;
}
@property (weak, nonatomic) IBOutlet UIView *RTTView;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbSSID;
@property (weak, nonatomic) IBOutlet UILabel *lbIP;


@property (strong,nonatomic) NSDate *start;
@property (nonatomic, strong, readwrite) SimplePing *   pinger;
@property (nonatomic, strong, readwrite) NSTimer *      sendTimer;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;
-(void) ConfigureTest:(NSString *)nametest testSelected:(int)testselect testView:(UIView *)view;
-(void) ConfigureLegends;
- (IBAction)btnNextTest:(id)sender;

//Labels
@property (weak, nonatomic) IBOutlet UILabel *lbAverage;
@property (weak, nonatomic) IBOutlet UILabel *lbLatency;
@property (weak, nonatomic) IBOutlet UILabel *lbAverageLatency;

@end
