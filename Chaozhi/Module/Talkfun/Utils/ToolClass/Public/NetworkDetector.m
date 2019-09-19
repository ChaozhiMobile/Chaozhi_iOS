//
//  NetworkDetector.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/8/4.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "NetworkDetector.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>
//#import "UIView+Toast.h"

@interface NetworkDetector ()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation NetworkDetector

- (Reachability *)hostReachability
{
    if (!_hostReachability) {
        _hostReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [_hostReachability startNotifier];
    }
    return _hostReachability;
}

- (Reachability *)internetReachability
{
    if (!_internetReachability) {
        _internetReachability = [Reachability reachabilityForInternetConnection];
        [_internetReachability startNotifier];
    }
    return _internetReachability;
}

- (NetworkStatus)networkStatus
{
    return [self.hostReachability currentReachabilityStatus];
}

- (void)networkcheck
{
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
//    NSString *remoteHostName = @"www.baidu.com";
//    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
//    self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
//    self.internetReachability = [Reachability reachabilityForInternetConnection];
//    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self configureTextField:nil imageView:nil reachability:reachability];
//        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
//        self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
//        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
//            NSLog(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established");
//            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
//            NSLog(@"Cellular data network is active.\nInternet traffic will be routed through it");
//            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
//        self.summaryLabel.text = baseLabelText;
    }
    
    if (reachability == self.internetReachability)
    {
        [self configureTextField:nil imageView:nil reachability:reachability];
    }
    
}


- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
//    NSString* statusString = @"";
    
    [self callback:netStatus];
    switch (netStatus)
    {
        case NotReachable:        {
//            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
//            imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
//            NSLog(@"NotReachable");
            break;
        }
            
        case ReachableViaWWAN:        {
            
//            NSLog(@"WWAN");
//            statusString = NSLocalizedString(@"Reachable WWAN", @"");
//            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            
//            NSLog(@"wifi状态 %ld",[self networkStatus]);
//            statusString= NSLocalizedString(@"Reachable WiFi", @"");
//            imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
    if (connectionRequired)
    {
//        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
//        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
//    textField.text= statusString;
}

- (void)callback:(NetworkStatus)networkStatus
{
    if (self.networkChangeBlock) {
        self.networkChangeBlock(networkStatus);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
