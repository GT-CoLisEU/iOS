//
//  iPerf2Controller.m
//  CoLisEU RNP
//
//  Created by Cassiano Padilha on 27/10/15.
//  Copyright © 2015 GT-CoLisEU. All rights reserved.
//

#import "iPerf2Controller.h"

@interface iPerf2Controller ()

@end

@implementation iPerf2Controller
@synthesize JitterDown, JitterUp, RTT, TcpDown, TcpUp, UdpDown, UdpUp, observers,Jitter,LostPacketPercent,nameTest,TypeTestReview,running,SentJson,TestComplete;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (iPerf2Controller*)getInstance {
    //Implementing singleton directives
    static iPerf2Controller *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init {
    //To-do pom auto choose according to pom list from gateway
    if (self = [super init]) {
        SentJson = false;
        TypeTestReview = false;
        testError = false;
        TestComplete = false;
        TcpDown = [[NSMutableArray alloc]init];
        UdpDown = [[NSMutableArray alloc]init];
        TcpUp = [[NSMutableArray alloc]init];
        UdpUp = [[NSMutableArray alloc]init];
        Jitter= [[NSMutableArray alloc]init];
        JitterDown= [[NSMutableArray alloc]init];
        JitterUp = [[NSMutableArray alloc]init];
        RTT = [[NSMutableArray alloc]init];
        observers = [[NSMutableDictionary alloc]init];
        thread = [[NSThread alloc] initWithTarget:self
                                         selector:@selector(runTests) object:nil];
    }
    return self;
}
-(void) runTests{
    NSLog(@"[IPerfController]Started tests");
    NSLog(@"[IPerfController]TCP test start");
    
    //[self startTraceroute];
 //   cont=0;
  //  contJitter = 0;
   // typeTest = TCPDW;
  //  [self startIperf:TCPDW]; ///TCPDW
    
 //   cont=0;
 //   contJitter = 0;
  //  typeTest = TCPUP;
   // [self startIperf:TCPUP]; ///TCPUP
    
    
  //  [self notifyAll:TCP];//TCP OVER
    
    
    
    NSLog(@"[IPerfController]UDP test start");
   // cont=0;
  //  contJitter = 0;
  //  typeTest = UDPDW;
 //   [self startIperf:UDPDW]; ///UDP
  ///
  ///  cont=0;
  //  contJitter = 0;
  //  typeTest = UDPUP;
  ////  [self startIperf:UDPUP]; ///UDP
    
  //  [self notifyAll:UDP];
    
    
    if(!testError)
        ready = true;
    running = false;
    //  if(TypeTestReview)
    //     [self notifyAll:QOSEND];
    
    NSLog(@"[IPerfController]Ended tests");
}
#pragma implementing observer/bean pattern
-(void) start{
    if(!running){
        ready = false;
        TcpDown = [[NSMutableArray alloc]init];
        UdpDown = [[NSMutableArray alloc]init];
        TcpUp = [[NSMutableArray alloc]init];
        UdpUp = [[NSMutableArray alloc]init];
        testError = false;
        thread = nil;
        thread = [[NSThread alloc] initWithTarget:self
                                         selector:@selector(runTests) object:nil];
        
        running = true;
     //   [self notifyAll:QOSSTART];
        [thread start];
    }
}
-(void)clearLists{
    TcpDown = [[NSMutableArray alloc]init];
    TcpUp = [[NSMutableArray alloc]init];
    UdpDown = [[NSMutableArray alloc]init];
    UdpUp = [[NSMutableArray alloc]init];
    Jitter = [[NSMutableArray alloc]init];
    JitterDown = [[NSMutableArray alloc]init];
}
-(void)waitingReviewTestQoS{
    int contsecond = 0;
    while (contsecond < 100) {
        sleep(1);
        NSLog(@"%i second ",contsecond);
        contsecond++;
    }
    TestComplete = true;
    NSLog(@"chamou notify qosend");
    
    //[self notifyAll:QOSENDREVIEW];
    //SendJson *sendjson = [[SendJson alloc]init];
    // [sendjson CreateMeassurementNew];
  //  [self CreateMeassurementNew];
    
    [self savetest];
    
    
}
-(void)savetest{
  //  [NetworkTestList saveData];
  //  [NetworkTestList sharedNetworkList].TypeExhibition = @"Normal";
}
-(void)waitingtest{ // Waiting test for iperf2
    int contsecond = 0;
    BOOL flag = false;
    while (contsecond < 120) {
        sleep(1);
        NSLog(@"%i second ",contsecond);
        contsecond++;
        if(ready || testError){
            flag = true;
            if (testError)
                ready = NO;
            break;
        }
        flag = false;
    }
    running = false;
    
    if(!ready){
        testError = true;
        running = false;
        if([nameTest isEqualToString:@"TCP"]){
            NSLog(@"matou tcp typetestreview %@ testError %@",TypeTestReview ? @"YES" : @"Nao", testError ? @"YES" : @"NO");
            //if(!TypeTestReview)
              //  [self notifyAll:TCP];//TCP OVER
            /*else if(testError){
             NSLog(@"envia atraves waiting TCP");
             [self notifyAll:QOSEND];
             }*/
        }
        else if([nameTest isEqualToString:@"UDP"]){
            NSLog(@"matou udp");
          //  if(!TypeTestReview)
             //   [self notifyAll:UDP];//UDP OVER
            /*  else if(testError){
             [self notifyAll:QOSEND];
             }*/
        }
        
    }
    [thread cancel];
}
-(void) stop{
    if(running){
        ready = false;
        TcpDown = [[NSMutableArray alloc]init];
        UdpDown = [[NSMutableArray alloc]init];
        TcpUp = [[NSMutableArray alloc]init];
        UdpUp = [[NSMutableArray alloc]init];
        [thread cancel];
        testError = true;
        running = false;
    }
}
-(void)CreateMeassurementNew{
    NetworkInfo *network = [[NetworkInfo alloc]init];
    
    RoundTripTime *rttt = [RoundTripTime getInstance];
    MPoint *mp = [MPoint sharedMPoint];
    NSString *usern;
    NSArray *auxTimestamp = [[NSArray alloc]init];
    NetworkInfo *net = [[NetworkInfo alloc]init];
    
    User *u = [ User getInstance];
    usern = u.username;
    HttpPost *post = [[HttpPost alloc]init];
    DeviceInfo *dev = [[DeviceInfo alloc]init];
    [dev LoadPosition];
    
    NSLog(@"Enviando comentario %f",[dev getLongitude]);
    
    
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
    
    [array addObject:@"br.com.rnp.gt_coliseu"];
    [array addObject:@"com.iOS.phone"];
    
    float latitude = [dev getLatitude];
    float longitude = [dev getLongitude];
    
    json[@"timestamp"] = [net getTimeStamp];
    json[@"position"] = [NSString stringWithFormat:@"%@,%@",u.latitude,u.longitude];
    json[@"source"] = @"application";
    json[@"program_list"] = array;
    
    
    NSMutableDictionary *qoeInfo = [[NSMutableDictionary alloc]init];
    qoeInfo[@"review"] = [ReviewList getInstance].reviewQOE;
    qoeInfo[@"channel_mos"] = [ReviewList getInstance].channelMos;
    // qoeInfo[@"review"] = @"ok";
    // qoeInfo[@"channel_mos"] = @"5";
    json[@"qoeInfo"] = qoeInfo;
    
    
    
    
    NSMutableDictionary *radius = [[NSMutableDictionary alloc]init];
    radius[@"radius"] = @"0";
    
    json[@"radius"] = @"0";
    
    NSMutableDictionary *deviceInfo = [[NSMutableDictionary alloc]init];
    deviceInfo[@"device"] = [NSString stringWithFormat:@"UDID = %@",[net getIdentiforForVendor]];
    deviceInfo[@"brand"] = @"0";
    deviceInfo[@"hash_device"] = @"DEVICE0A8CE30BC8E053C304A0C8D2F2";
    deviceInfo[@"register_id"] = @"0";
    deviceInfo[@"type"] = [dev getTypeDevice];
    deviceInfo[@"l3address"] = [net getIPAddress];
    deviceInfo[@"description"] = [dev deviceName];
    json[@"deviceInfo"] = deviceInfo;
    
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    userInfo[@"user"] = [[User getInstance] username];
    json[@"userInfo"] = userInfo;
    
    NSMutableDictionary *qosInfo = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *tcpupload = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *tcpdownload = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *udpupload = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *udpdownload = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *rtt = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *jitterupload = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *jitterdownload = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *networkinfo = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *traceroute = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *test_result = [[NSMutableDictionary alloc]init];
    NSMutableArray *result1 = [[NSMutableArray alloc]init];
    NSMutableArray *result2 = [[NSMutableArray alloc]init];
    NSMutableArray *result3 = [[NSMutableArray alloc]init];
    NSMutableArray *result4 = [[NSMutableArray alloc]init];
    NSMutableArray *result5 = [[NSMutableArray alloc]init];
    NSMutableArray *result6 = [[NSMutableArray alloc]init];
    NSMutableArray *result7 = [[NSMutableArray alloc]init];
    NSMutableArray *result8 = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *test_result_udp_down = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *test_result_udp_up = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *test_result_tcp_down = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *test_result_tcp_up = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *test_result_latency = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *tracerouteResult = [[NSMutableDictionary alloc]init];
    
    NSArray *init = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    NSMutableArray *tracerouteAddress = [[NSMutableArray alloc]init];
    tracerouteAddress = [NSMutableArray arrayWithArray:init];
    
    
    double totalbandwidth = 0;
    float rttSum = 0;
    float tcpSum = 0;
    float udpSum = 0;
    float tcpUpSum = 0;
    float udpUpSum = 0;
    float jitterDownSum = 0;
    float jitterUpSum = 0;
    
    //if(!([[IPerfController getInstance].TcpUp count] < 4) && !([[IPerfController getInstance].TcpDown count] < 4) && !([[IPerfController getInstance].UdpDown count] < 4) && !([[IPerfController //getInstance].UdpUp count] < 4)){
    
    /* if(([[IPerfController getInstance].TcpUp count] < 10)){
     NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
     [IPerfController getInstance].TcpUp = [NSMutableArray arrayWithArray:values];
     }*/
    
    if(([[iPerf2Controller getInstance].TcpUp count] < 10)){
        NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        [iPerf2Controller getInstance].TcpUp = [NSMutableArray arrayWithArray:values];
    }
    if(([[iPerf2Controller getInstance].TcpDown count] < 10) ){
        NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        [iPerf2Controller getInstance].TcpDown = [NSMutableArray arrayWithArray:values];
    }
    if(([[iPerf2Controller getInstance].UdpDown count] < 10) ){
        NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        [iPerf2Controller getInstance].UdpDown = [NSMutableArray arrayWithArray:values];
    }
    
    if(([[iPerf2Controller getInstance].UdpUp count] < 10)){
        NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        [iPerf2Controller getInstance].UdpUp = [NSMutableArray arrayWithArray:values];
    }
    if(([[iPerf2Controller getInstance].Jitter count] < 10)){
        NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        [iPerf2Controller getInstance].Jitter = [NSMutableArray arrayWithArray:values];
    }
    if(([[iPerf2Controller getInstance].JitterDown count] < 10)){
        NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        [iPerf2Controller getInstance].JitterDown = [NSMutableArray arrayWithArray:values];
    }
    if([rttt.rttlist count] < 10){
        NSArray *values = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        rttt.rttlist = [NSMutableArray arrayWithArray:values];
        
    }
    
    [[NetworkTestList sharedNetworkList].RTTlist addObject:rttt.rttlist];
    
    [[NetworkTestList sharedNetworkList].Date addObject:[network getTimeStamp]];
    [[NetworkTestList sharedNetworkList].SSID addObject:[network getSSID]];
    [[NetworkTestList sharedNetworkList].Server addObject:[mp address]];
    
    [[NetworkTestList sharedNetworkList].TCPdownList addObject:[iPerf2Controller getInstance].TcpDown];
    [[NetworkTestList sharedNetworkList].TCPupList addObject:[iPerf2Controller getInstance].TcpUp];
    
    [[NetworkTestList sharedNetworkList].JitterList addObject:[iPerf2Controller getInstance].Jitter];
    [[NetworkTestList sharedNetworkList].JitterListDownload addObject:[iPerf2Controller getInstance].JitterDown];
    
    [[NetworkTestList sharedNetworkList].UDPdownList addObject:[iPerf2Controller getInstance].UdpDown];
    [[NetworkTestList sharedNetworkList].UDPupList addObject:[iPerf2Controller getInstance].UdpUp];
    
    
    for(int x = 0 ; x < [tracerouteAddress count] ; x++){
        traceroute[@"hostaddress"] = @"0";
        traceroute[@"hostname"] = @"0";
        traceroute[@"response_time"] = @"0";
        [result8 addObject:traceroute];
        traceroute = [[NSMutableDictionary alloc]init];
    }
    json[@"traceroute"] = result8;
    
    
    
    
    test_result_tcp_up[@"bandwidth_average_format"] = @"0";
    test_result_tcp_up[@"bandwidth_average"] = @"0";
    test_result_tcp_up[@"protocol"] = @"TCP";
    test_result_tcp_up[@"local_ip"] = @"0";
    test_result_tcp_up[@"direction"] = @"Upload";
    test_result_tcp_up[@"server_ip"] = mp.address;
    test_result_tcp_up[@"data_transfer"] = @"0";
    test_result_tcp_up[@"data_transfer_format"] = @"0";
    test_result_tcp_up[@"local_port"] = @"0";
    test_result_tcp_up[@"server_port"] = mp.port;
    test_result_tcp_up[@"tcp_window_size"] = @"0";
    
    
    for(int x = 0 ; x < 10 ; x++){
        tcpupload[@"data_transfer_format"] = @"Kbit";
        tcpupload[@"interval"] = [NSString stringWithFormat:@"%d-%dsec",x,x+1];
        tcpupload[@"bandwidth_format"] = @"Kbit/sec";
        tcpupload[@"data_transfer"] = [NSString stringWithFormat:@"%d",[[iPerf2Controller getInstance].TcpUp[x] intValue] *1024];
        tcpupload[@"bandwidth"] = @"0";
        [result1 addObject:tcpupload];
        tcpupload = [[NSMutableDictionary alloc]init];
    }
    test_result_tcp_up[@"list_requests"] = result1;
    
    qosInfo[@"test_result_tcp_up"] = test_result_tcp_up;
    
    
    test_result_tcp_down[@"bandwidth_average_format"] = @"0";
    test_result_tcp_down[@"bandwidth_average"] = @"0";
    test_result_tcp_down[@"protocol"] = @"TCP";
    test_result_tcp_down[@"local_ip"] = @"0";
    test_result_tcp_down[@"direction"] = @"Download";
    test_result_tcp_down[@"server_ip"] = mp.address;
    test_result_tcp_down[@"data_transfer"] = @"0";
    test_result_tcp_down[@"local_port"] = @"0";
    test_result_tcp_down[@"server_port"] = mp.port;
    test_result_tcp_down[@"tcp_window_size"] = @"0";
    test_result_tcp_down[@"data_transfer_format"] = @"0";
    
    for(int x = 0 ; x < 10 ; x++){
        tcpdownload[@"data_transfer_format"] = @"Kbit/sec";
        tcpdownload[@"interval"] = [NSString stringWithFormat:@"%d-%dsec",x,x+1];
        tcpdownload[@"bandwidth_format"] = @"Kbit";
        // tcpdownload[@"data_transfer"] = [NSString stringWithFormat:@"%@",[IPerfController getInstance].TcpDown[x]];
        tcpdownload[@"data_transfer"] = [NSString stringWithFormat:@"%d",[[iPerf2Controller getInstance].TcpDown[x] intValue] *1024];
        tcpdownload[@"bandwidth"] = @"0";
        [result2 addObject:tcpdownload];
        tcpdownload = [[NSMutableDictionary alloc]init];
    }
    test_result_tcp_down[@"list_requests"] = result2;
    
    qosInfo[@"test_result_tcp_down"] = test_result_tcp_down;
    
    test_result_udp_up[@"udp_buffer_size"] = @"";
    test_result_udp_up[@"protocol"] = @"UDP";
    test_result_udp_up[@"local_ip"] = @"";
    test_result_udp_up[@"direction"] = @"Upload";
    test_result_udp_up[@"data_transfer"] = @"";
    test_result_udp_up[@"data_tranfer_format"] = @"";
    test_result_udp_up[@"data_transfer_format"] = @"";
    test_result_udp_up[@"local_port"] = @"";
    test_result_udp_up[@"bandwidth_average_format"] = @"";
    test_result_udp_up[@"udp_sending_datagrams"] = @"";
    test_result_udp_up[@"bandwidth_average"] = @"";
    test_result_udp_up[@"udp_sending_datagrams_format"] = @"";
    test_result_udp_up[@"server_ip"] = mp.address;
    test_result_udp_up[@"server_port"] = mp.port;
    test_result_udp_up[@"udp_sent_datagrams"] = @"";
    
    for(int x = 0 ; x < 10 ; x++){
        udpupload[@"data_transfer_format"] = @"Kbit";
        udpupload[@"interval"] = [NSString stringWithFormat:@"%d-%dsec",x,x+1];
        udpupload[@"bandwidth_format"] = @"Kbit/sec";
        udpupload[@"data_transfer"] = [NSString stringWithFormat:@"%d",[[iPerf2Controller getInstance].UdpUp[x] intValue]*1024];
        udpupload[@"jitter_format"] = @"ms";
        udpupload[@"time"] = [iPerf2Controller getInstance].Jitter[x];
        udpupload[@"bandwidth"] = @"0";
        [result3 addObject:udpupload];
        udpupload = [[NSMutableDictionary alloc]init];
    }
    test_result_udp_up[@"list_requests"] = result3;
    qosInfo[@"test_result_udp_up"] = test_result_udp_up;
    
    
    test_result_udp_down[@"bandwidth_average"] = @"";
    test_result_udp_down[@"bandwidth_average_format"] = @"Mbit/sec";
    test_result_udp_down[@"protocol"] = @"UDP";
    test_result_udp_down[@"local_ip"] = @"";
    test_result_udp_down[@"direction"] = @"Download";
    test_result_udp_down[@"server_ip"] = mp.address;
    test_result_udp_down[@"data_transfer"] = @"";
    test_result_udp_down[@"data_transfer_format"] = @"Mbit";
    test_result_udp_down[@"local_port"] = @"0";
    test_result_udp_down[@"server_port"] = mp.port;
    test_result_udp_down[@"tcp_window_size"] = @"";
    
    
    for(int x = 0 ; x < 10 ; x++){
        udpdownload[@"data_transfer_format"] = @"Kbit";
        udpdownload[@"interval"] = [NSString stringWithFormat:@"%d-%dsec",x,x+1];
        udpdownload[@"bandwidth_format"] = @"Kbit/sec";
        udpdownload[@"data_transfer"] = [NSString stringWithFormat:@"%d",[[iPerf2Controller getInstance].UdpDown[x] intValue]*1024];
        udpdownload[@"jitter_format"] = @"ms";
        udpdownload[@"time"] = [iPerf2Controller getInstance].JitterDown[x];
        udpdownload[@"bandwidth"] = @"0";
        [result4 addObject:udpdownload];
        udpdownload = [[NSMutableDictionary alloc]init];
    }
    test_result_udp_down[@"list_requests"] = result4;
    qosInfo[@"test_result_udp_down"] = test_result_udp_down;
    
    
    test_result_latency[@"latency_avg"] = @"";
    test_result_latency[@"time"] = @"";
    test_result_latency[@"transmitted"] = @"";
    test_result_latency[@"server_ip"] = mp.address;
    test_result_latency[@"latency_max"] = @"0";
    test_result_latency[@"latency_min"] = @"0";
    test_result_latency[@"payload"] = @"0";
    test_result_latency[@"received"] = @"0";
    test_result_latency[@"ttl"] = @"0";
    
    
    
    
    for(int x = 0 ; x < 10 ; x++){
        rtt[@"from_ip"] = @"0";
        rtt[@"time"] = [NSString stringWithFormat:@"%f",[rttt.rttlist[x] floatValue]];
        rtt[@"icmp_seq"] = @"0";
        rtt[@"from"] = @"0";
        rtt[@"bytes"] = @"0";
        rtt[@"ttl"] = @"0";
        [result5 addObject:rtt];
        rtt = [[NSMutableDictionary alloc]init];
    }
    test_result_latency[@"list_requests"] = result5;
    qosInfo[@"test_result_latency"] = test_result_latency;
    
    
    for(int x = 0 ; x < 10 ; x++){
        rttSum += [[NSString stringWithFormat:@"%@",[RoundTripTime getInstance].rttlist[x]] floatValue];;
        tcpSum += [[NSString stringWithFormat:@"%@",[iPerf2Controller getInstance].TcpDown[x]] floatValue];
        tcpUpSum += [[NSString stringWithFormat:@"%@",[iPerf2Controller getInstance].TcpUp[x]] floatValue];
        udpSum += [[NSString stringWithFormat:@"%@",[iPerf2Controller getInstance].UdpDown[x]] floatValue];
        udpUpSum += [[NSString stringWithFormat:@"%@",[iPerf2Controller getInstance].UdpUp[x]] floatValue];
        jitterUpSum += [[NSString stringWithFormat:@"%@",[iPerf2Controller getInstance].Jitter[x]] floatValue];
        jitterDownSum += [[NSString stringWithFormat:@"%@",[iPerf2Controller getInstance].JitterDown[x]] floatValue];
    }
    
    NSString *ssid = [[net getSSID] isEqualToString:@"NONE>>"] ? @"wifi" : [net getSSID];
    NSLog(@"ssid enviado %@",ssid);
    networkinfo[@"ssid"] = ssid;
    networkinfo[@"dns_server"] = @"172.16.0.50";
    networkinfo[@"l2address"] = [net getL2Address];; //Mac address
    networkinfo[@"type"] = @"wifi";
    networkinfo[@"channel"] = @"0";
    networkinfo[@"encryption"] = @"none";
    networkinfo[@"l3address"] = [net getIPAddress]; //IP
    
    
    json[@"networkInfo"] = networkinfo;
    
    qosInfo[@"channel_jitter_down"] = [NSString stringWithFormat:@"%f",jitterDownSum/10];
    qosInfo[@"channel_jitter_up"] = [NSString stringWithFormat:@"%f",jitterUpSum/10];
    qosInfo[@"channel_tcp_down"] = [NSString stringWithFormat:@"%f",tcpSum/10 *1024];
    qosInfo[@"channel_rtt"] = [NSString stringWithFormat:@"%f",rttSum/10];
    qosInfo[@"channel_latency"] = [NSString stringWithFormat:@"%f",rttSum/10];
    qosInfo[@"channel_rssi"] = @"0";
    qosInfo[@"channel_tcp_up"] = [NSString stringWithFormat:@"%f",tcpUpSum/10 *1024];
    qosInfo[@"channel_udp_up"] = [NSString stringWithFormat:@"%f",udpUpSum/10 *1024];
    qosInfo[@"channel_udp_down"] = [NSString stringWithFormat:@"%f",udpSum/10 *1024];
    json[@"qosInfo"] = qosInfo;
    
    
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:nil];
    NSString *jsonString = [@"json=" stringByAppendingString:[[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding]];
    NSLog(@"%@",jsonString);
    
    //url = [NSURL URLWithString:@"https://coliseu.rnp.br/gateway/index.php/measurements/create"];
    url = [Gateway createMeasurement];
    NSLog(@"json enviado %@ ",[post postJson:jsonString URL:url]);
    NSLog(@"enviou");
    
}
@end
