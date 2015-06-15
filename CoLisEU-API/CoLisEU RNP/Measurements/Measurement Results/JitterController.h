//
//  JitterViewController.h
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 08/06/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "SlideNavigationController.h"
#import "DeviceInfo.h"
#import "NetworkInfo.h"
#import "IPerfController.h"
#import "MBProgressHUD.h"
#import "CPDScatterPlotViewController.h"
#import "ScreenLoadController.h"
#import "Translate.h"
#import "NetworkTestList.h"

@interface JitterViewController : UIViewController<CPTPlotDataSource>{
    
@private
    MBProgressHUD *hud;
    CPTGraph *graph;
    CPTScatterPlot *aaplPlot;
    CPTScatterPlot *googPlot;
    CPTScatterPlot *msftPlot;
    int TestSelected;
    NSString  *NameTestSelected;
    NSNumber *AverageJitter;
    NSInteger majorIncrement;
    NSInteger minorIncrement;    ///Incromentos entre as linhas
    BOOL Ploted;
@private
    int contador;
@private
    double acumulador;
@private
    UIAlertView *StartTest;
    
    NSMutableArray *graphJitter;
    NSMutableArray *plotJitter;
}
@property (weak, nonatomic) IBOutlet UIView *JitterView;

@property (weak, nonatomic) IBOutlet UILabel *lbSSID;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbIP;
@property (weak, nonatomic) IBOutlet UILabel *lbAverage;
- (IBAction)btnShowTests:(id)sender;

@property (strong,nonatomic) NSDate *start;
@property (nonatomic, strong, readwrite) SimplePing *   pinger;
@property (nonatomic, strong, readwrite) NSTimer *      sendTimer;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;
-(void) ConfigureTest:(NSString *)nametest testSelected:(int)testselect testView:(UIView *)view;
-(void) ConfigureLegends;

@end
