//
//  AppDelegate.m
//  RabbitMQDemo
//
//  Created by misrobot on 2017/6/27.
//  Copyright © 2017年 misrobot. All rights reserved.
//

#import "AppDelegate.h"

#import <AFNetworking/AFNetworking.h>

#import "LXRabbitMQManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"%s",__func__);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%s",__func__);
    
    LXRabbitMQManager * lxRabbitMQManager = [LXRabbitMQManager sharedInstance];
    [lxRabbitMQManager Stop];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%s",__func__);

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterForeground" object:self];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s",__func__);
    
    LXRabbitMQManager * lxRabbitMQManager = [LXRabbitMQManager sharedInstance];
    [lxRabbitMQManager Restart];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s",__func__);
}

/**
 开启网络监测
 */
-(void)startReachability {
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        LXRabbitMQManager * lxRabbitMQManager = [LXRabbitMQManager sharedInstance];
        [lxRabbitMQManager Restart];
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未连接网络！");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"请检测网络状态");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G/4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
            default:
                break;
        }
        
    }];
    //开启监测
    [manager startMonitoring];
}


@end
