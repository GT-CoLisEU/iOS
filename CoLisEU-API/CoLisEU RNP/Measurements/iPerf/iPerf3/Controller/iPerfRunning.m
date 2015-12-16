//
//  iPerfRunning.m
//  CoLisEU RNP
//
//  Created by GT-CoLisEU on 08/05/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import "iPerfRunning.h"

@implementation iPerfRunning

/**
 
 RESPONSÁVEL POR INICIAR CONEXÃO COM IPERF
 
 */
-(void)IniciaTesteiPerf{
    MPoint *mp = [MPoint sharedMPoint];
    
    NSLog(@"entrou inicia teste iperf");
    struct iperf_test *test;
    // int limite = type == 1 ? 9 : 10;
    int limite;
    int argc;
    
    switch (typeTest) {
        case 1:
            limite = 9;
            break;
        case 2:
            limite = 10;
            break;
        case 3:
            limite = 10;
            break;
        case 4:
            limite = 11;
            break;
        default:
            break;
    }
    limite += 2;
    argc = limite;
    char *argv[limite];
    
    switch (typeTest) {
        case 2:
            argv[9] = "-R";
            break;
        case 3:
            argv[9] = "-u";
            break;
        case 4:
            argv[9] = "-u";
            argv[10] = "-R";
            break;
        default:
            break;
    }
    
    
    // if (limite == 10)
    //    argv[9] = "-u";
    argv[0] = "iperf3";
    argv[1] = "-i";
    argv[2] = "1";
    argv[3] = "-t";
    argv[4] = "10";
    argv[5] = "-f";
    argv[6] = "m";
    argv[7] = "-c";
    // argv[8] = (char *)[Server_Measurement UTF8String];
    argv[8] = (char *)[mp.address UTF8String];
    
    argv[limite-2] = "-p";
    //argv[limite-1] = (char *)[Port_Connection UTF8String];
    argv[limite-1] = (char *)[mp.port UTF8String];
    
    for(int x = 0 ; x < limite ; x++)
        NSLog(@"%d %s",limite,argv[x]);
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
    
    if ([self run:test] < 0)
        iperf_errexit(test, "error - %s", iperf_strerror(i_errno));
    
    iperf_free_test(test);
    
    
}


-(int)run:(struct iperf_test *)test{
    int consecutive_errors;
    printf("\n\n ENTROU RUN TEST \n\n");
    
    MeassurementResults *mr = [MeassurementResults getInstance];
    ;
    
    NSString *tempFileTemplate =
    [NSTemporaryDirectory() stringByAppendingPathComponent:@"iperf3.XXXXXX"];
    const char *tempFileTemplateCString =
    [tempFileTemplate fileSystemRepresentation];
    char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
    strcpy(tempFileNameCString, tempFileTemplateCString);
    int fileDescriptor = mkstemp(tempFileNameCString);
    mktemp_read = fileDescriptor;
    NSLog(@"\n\n file %d \n\n",fileDescriptor);
    NSLog(@"\n\n unlink %d \n\n",unlink("iperf3.XXXXXX"));
    
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
                        fprintf(stderr, "too many errors, exiting\n");
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
            NSLog(@"iniciou execucao");
            iperf_run_client(test); //< 0)
            //iperf_errexit(test, "error2 - %s", iperf_strerror(i_errno));
            printf("\n\n");
            int i = 0;
            for(int x = 0 ; x < 10 ; x++)
                NSLog(@"v %d: %f",x,LarguraDeBanda[x]);
            for(int x = 0 ; x < 10 ; x+=2){
                // printf("transfer %f bandwidth %f \n",LarguraDeBanda[x],LarguraDeBanda[x+1]);
                if(typeTest == 1){
                    [mr.TCPDownload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda[x]]];
                    [mr.BTCPDownload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda[x+1]]];
                }
                else if(typeTest == 2){
                    [mr.TCPUpload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UPLOAD[x]]];
                    [mr.BTCPUpload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UPLOAD[x+1]]];
                }
                else if(typeTest == 3){
                    [mr.UDPDownload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UDP[x]]];
                    [mr.BUDPDownload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UDP[x+1]]];
                }
                else if(typeTest == 4){
                    [mr.UDPUpload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UDP_UPLOAD[x]]];
                    [mr.BUDPUpload addObject:[NSString stringWithFormat:@"%f",LarguraDeBanda_UDP_UPLOAD[x+1]]];
                }
                i++;
            }
            printf("\n cont %d \n",cont);
            NSLog(@"terminou execucao");
            break;
        default:
            usage();
            break;
    }
    /*  NSLog(@"tcp down %@",TcpDown);
     NSLog(@"tcp up %@",TcpUp);
     NSLog(@"udp down %@",UdpDown);
     NSLog(@"udp up%@",UdpUp);
     */
    return 0;
}
- (IBAction)reviewDone:(UITextField *)sender {
    NSLog(@"User entered some text");
    
}


/*
 
 TERMINOU EXECUÇÃO IPERF
 
 */
@end
