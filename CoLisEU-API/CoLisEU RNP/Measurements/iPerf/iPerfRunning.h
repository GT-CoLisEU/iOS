//
//  iPerfRunning.h
//  CoLisEU RNP
//
//  Created by GT-CoLisEU on 08/05/15.
//  Copyright (c) 2015 GT-CoLisEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "iperf_config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <errno.h>
#include <signal.h>
#include <unistd.h>
#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif
#include <netinet/tcp.h>

#include "iperf.h"
#include "utilVariables.h" // largura da banda UPLOAD para UDP e TCP
#include "iperf_api.h"
#include "units.h"
#include "iperf_locale.h"
#include "net.h"


#import "SimplePing.h"
#include <sys/socket.h>
#include <netdb.h>
#include <time.h>
#include <sys/time.h>
#import "MPoint.h"
#include "Variables.h"
#import "MeassurementResults.h"
@interface iPerfRunning : NSObject

@end
