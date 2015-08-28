//
//  ReachabilityCheck.m
//  sunny
//
//  Created by MacNote on 2014/07/04.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "ReachabilityCheck.h"
#import "Reachability.h"

@implementation ReachabilityCheck

+ (BOOL)getNetworkInfo
{
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            NSLog(@"インターネット接続出来ません");
            return NO;
            break;
        case ReachableViaWWAN:
            NSLog(@"3G接続中");
            return YES;
            break;
        case ReachableViaWiFi:
            NSLog(@"WiFi接続中");
            return YES;
            break;
        default:
            NSLog(@"？？[%ld]", (long)status);
            return NO;
            break;
    }
}

@end
