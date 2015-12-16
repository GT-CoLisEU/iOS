//
//  IPerfController.m
//  CoLisEU RNP
//
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import "IPerfController.h"


@implementation IPerfController

//Syntesizing methods
@synthesize JitterDown, JitterUp, RTT, TcpDown, TcpUp, UdpDown, UdpUp, observers,Jitter,LostPacketPercent;
+ (IPerfController*)getInstance {
    //Implementing singleton directives
    static IPerfController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init {
    //To-do pom auto choose according to pom list from gateway
    if (self = [super init]) {
        testError = false;
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



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma Using observer and enum
-(void)startIperf:(TestType)type{
    MPoint *mp = [MPoint sharedMPoint];
    struct iperf_test *test;
    int argc=30;
    
    char *argv[argc];
    int count = 0;
    
    argv[count++] = "iperf3";
    argv[count++] = "-i";
    argv[count++] = "1";
    argv[count++] = "-t";
    argv[count++] = "5";
    argv[count++] = "-f";
    argv[count++] = "m";
    argv[count++] = "-c";
    argv[count++] = (char *)[mp.address UTF8String];
    argv[count++] = "-p";
    argv[count++] = (char *)[mp.port UTF8String];
    
    switch (type) {
        case TCPUP:
            argv[count++] = "-R";
            break;
        case UDPDW:
            argv[count++] = "-u";
            argv[count++] = "-b";
            argv[count++] = "100m";
            break;
        case UDPUP:
            argv[count++] = "-u";
            argv[count++] = "-R";
            break;
        default:
            break;
    }
    argc = count;
    //Printing args
//    NSString *args = @"";
//    for(int x = 0 ; x < argc ; x++)
//        args=[[NSString alloc] initWithFormat:@"%@ %s", args, argv[x] ];
//    NSLog(@"%@", args);
    
    // XXX: Setting the process affinity requires root on most systems.
    //      Is this a feature we really need?
#ifdef TEST_PROC_AFFINITY
    /* didnt seem to work.... */
    /*
     * increasing the priority of the process to minimise packet generation
     * delay
     */
    int rc = setpriority(PRIO_PROCESS, 0, -15);
    
    if (rc < 0) {
        perror("setpriority:");
        fprintf(stderr, "setting priority to valid level\n");
        rc = setpriority(PRIO_PROCESS, 0, 0);
    }
    
    /* setting the affinity of the process  */
    cpu_set_t cpu_set;
    int affinity = -1;
    int ncores = 1;
    
    sched_getaffinity(0, sizeof(cpu_set_t), &cpu_set);
    if (errno)
        perror("couldn't get affinity:");
    
    if ((ncores = sysconf(_SC_NPROCESSORS_CONF)) <= 0)
        err("sysconf: couldn't get _SC_NPROCESSORS_CONF");
    
    CPU_ZERO(&cpu_set);
    CPU_SET(affinity, &cpu_set);
    if (sched_setaffinity(0, sizeof(cpu_set_t), &cpu_set) != 0)
        err("couldn't change CPU affinity");
#endif
    
    test = iperf_new_test();
    if (!test)
        iperf_errexit(NULL, "create new test error - %s", iperf_strerror(i_errno));
        iperf_defaults(test);	/* sets defaults */
    
    if (iperf_parse_arguments(test, argc, argv) < 0) {
        iperf_err(test, "parameter error - %s", iperf_strerror(i_errno));
        fprintf(stderr, "\n");
        usage_long();
        exit(1);
    }
    if([self run:test:type] < 0){
        testError = true;
    }
    [self notifyAll:type];
    
}
-(int)run:(struct iperf_test *)test :(TestType)type{
    int consecutive_errors;
    @try{
        NSString *tempFileTemplate =
        [NSTemporaryDirectory() stringByAppendingPathComponent:@"iperf3.XXXXXX"];
        const char *tempFileTemplateCString =
        [tempFileTemplate fileSystemRepresentation];
        char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
        strcpy(tempFileNameCString, tempFileTemplateCString);
        int fileDescriptor = mkstemp(tempFileNameCString);
        mktemp_read = fileDescriptor;
        NSLog(@"[IPerfController]\n\n file %d \n\n",fileDescriptor);
        NSLog(@"[IPerfController]\n\n unlink %d \n\n",unlink("iperf3.XXXXXX"));
        
        switch (test->role) {
            case 's':
                if (test->daemon) {
                    int rc = daemon(0, 0);
                    if (rc < 0) {
                        i_errno = IEDAEMON;
                        iperf_errexit(test, "error - %s", iperf_strerror(i_errno));
                    }
                }
                consecutive_errors = 0;
                if (iperf_create_pidfile(test) < 0) {
                    i_errno = IEPIDFILE;
                    iperf_errexit(test, "error - %s", iperf_strerror(i_errno));
                }
                for (;;) {
                    if (iperf_run_server(test) < 0) {
                        iperf_err(test, "error - %s", iperf_strerror(i_errno));
                        fprintf(stderr, "\n");
                        ++consecutive_errors;
                        if (consecutive_errors >= 5) {
                            fprintf(stderr, "[IPerfController]too many errors, exiting\n");
                            break;
                        }
                    } else
                        consecutive_errors = 0;
                    iperf_reset_test(test);
                    if (iperf_get_test_one_off(test))
                        break;
                }
                iperf_delete_pidfile(test);
                break;
            case 'c':
                NSLog(@"[IPerfController]iniciou execucao");
                if (iperf_run_client(test) < 0){
                    NSLog(@"[IPerfController]servidor nao iniciado");
                    return -1;
                }
                int y = 0;
                for(int x = 0 ; x < 20 ; x+=2){
                    switch (type) {
                        case TCPDW:
                            NSLog(@"%@",[NSString stringWithFormat:@"Tipo assim %f",LarguraDeBanda[x]]);
                            [[IPerfController getInstance].TcpDown addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda[x]]];
                            break;
                        case TCPUP:
                            [[IPerfController getInstance].TcpUp addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UPLOAD[x]]];
                            break;
                        case UDPDW:
                            NSLog(@"%@",[NSString stringWithFormat:@"Tipo assim %f",LarguraDeBanda_UDP[x]]);                            
                            [[IPerfController getInstance].UdpDown addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UDP[x]]];
                            break;
                        case UDPUP:
                            [[IPerfController getInstance].Jitter addObject:[NSString stringWithFormat:@"%f",JitterUpload[y]]];
                            [IPerfController getInstance].LostPacketPercent = [NSString stringWithFormat:@"%.2f",lost_packet_percent];
                            NSLog(@"Jitter %f",JitterUpload[y]);
                            NSLog(@"%@",[NSString stringWithFormat:@"Tipo assim %f",LarguraDeBanda_UDP_UPLOAD[y]]);
                            [[IPerfController getInstance].UdpUp addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UDP_UPLOAD[x]]];
                            y++;
                            break;
                        default:
                            NSLog(@"[IPerfController]run: Invalid option");
                            break;                            
                    }
                }
                break;
            default:
                return -1;
                break;
        }
    }
    @catch(NSException *e){
        return -1;
    }
    return 0;
}
-(void) runTests{
    NSLog(@"[IPerfController]Started tests");
    NSLog(@"[IPerfController]TCP test start");
    cont=0;
    contJitter = 0;
    typeTest = TCPDW;
    [self startIperf:TCPDW]; ///TCPDW
    
    cont=0;
    contJitter = 0;
    typeTest = TCPUP;
    [self startIperf:TCPUP]; ///TCPUP
    
    [self notifyAll:TCP];//TCP OVER
    
    NSLog(@"[IPerfController]UDP test start");
    cont=0;
    contJitter = 0;
    typeTest = UDPDW;
    [self startIperf:UDPDW]; ///UDP
    
    cont=0;
    contJitter = 0;
    typeTest = UDPUP;
    [self startIperf:UDPUP]; ///UDP
    
    [self notifyAll:UDP];
    
    
    if(!testError)
        ready = true;
    running = false;
    [self notifyAll:QOSEND];
    
    NSLog(@"[IPerfController]Ended tests");
}
-(BOOL) isRunning{
    return running;
}
-(BOOL) isReady{
    return ready;
}
-(BOOL) error{
    return testError;
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
        [self notifyAll:QOSSTART];
        [thread start];
    }
}
-(void)clearLists{
 ///   TcpDown = [[NSMutableArray alloc]init];
 //   TcpUp = [[NSMutableArray alloc]init];
 //   UdpDown = [[NSMutableArray alloc]init];
 //   UdpUp = [[NSMutableArray alloc]init];
 //   Jitter = [[NSMutableArray alloc]init];
}
-(void) startTCP{
    if(!running){
        ready = false;
        TcpDown = [[NSMutableArray alloc]init];
        TcpUp = [[NSMutableArray alloc]init];
        testError = false;
        thread = nil;
        thread = [[NSThread alloc] initWithTarget:self
                                         selector:@selector(runTestsTCP) object:nil];
        running = true;
        [self notifyAll:QOSSTART];
        [thread start];
    }
}
-(void) startUDP{
    if(!running){
        ready = false;
        UdpDown = [[NSMutableArray alloc]init];
        UdpUp = [[NSMutableArray alloc]init];
        Jitter = [[NSMutableArray alloc]init];
        testError = false;
        thread = nil;
        thread = [[NSThread alloc] initWithTarget:self
                                         selector:@selector(runTestsUDP) object:nil];
        running = true;
        [self notifyAll:QOSSTART];
        [thread start];
    }
}
-(void) runTestsUDP{
    NSLog(@"[IPerfController]Started tests");
    NSLog(@"[IPerfController]UDP test start");
    cont=0;
    contJitter = 0;
    typeTest = UDPDW;
    [self startIperf:UDPDW]; ///UDP
    
    cont=0;
    contJitter = 0;
    typeTest = UDPUP;
    [self startIperf:UDPUP]; ///UDP
    
    [self notifyAll:UDP];
    
    
    if(!testError)
        ready = true;
    running = false;
    [self notifyAll:QOSEND];
    
    NSLog(@"[IPerfController]Ended tests");
}

-(void) runTestsTCP{
    NSLog(@"[IPerfController]Started tests");
    NSLog(@"[IPerfController]TCP test start");
    cont=0;
    typeTest = TCPDW;
    [self startIperf:TCPDW]; ///TCPDW
    
    cont=0;
    typeTest = TCPUP;
    [self startIperf:TCPUP]; ///TCPUP
    
    [self notifyAll:TCP];//TCP OVER
    
    if(!testError)
        ready = true;
    running = false;
    [self notifyAll:QOSEND];
    
    NSLog(@"[IPerfController]Ended tests");
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
-(void) notifyAll: (TestType) msg{
    for (id <QoSObserver> obj  in observers.allValues) {
        [obj update:msg];
    }
}

+(void) addObserver:(NSString *)key obj:(NSObject *)obj{
    NSLog(@"add observer %@ %@",key,obj);
    IPerfController *sc = [IPerfController getInstance];
    sc.observers[key] = obj;
}
+(void) removeObserver:(NSString *)key{
    IPerfController *sc = [IPerfController getInstance];
    [sc.observers removeObjectForKey:key];
}

@end
