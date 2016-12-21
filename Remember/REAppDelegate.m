//
//  REAppDelegate.m
//  Remember
//
//  Created by Lelouch on 2016/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REAppDelegate.h"
#import "REMainViewController.h"
#import "REMDefine.h"
#import <UserNotifications/UserNotifications.h>
#import "REPersistanceManager.h"

@interface REAppDelegate ()

@property (strong, nonatomic) UINavigationController *mainNavi;

@end

@implementation REAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 1
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    REMainViewController *mainVC = [[REMainViewController alloc] init];
    
    _mainNavi = [[UINavigationController alloc] initWithRootViewController:mainVC];
    _mainNavi.navigationBarHidden = NO;
    _mainNavi.navigationBar.translucent = NO;
    
    _mainNavi.navigationBar.barTintColor = ThemeColor;
    [_mainNavi.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    _mainNavi.navigationBar.tintColor = [UIColor whiteColor];
    self.window.rootViewController = _mainNavi;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    //修改图标上的数字标记
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[REPersistanceManager objectForKey:ISICONMARKON] isEqualToString:@"1"]?[[REPersistanceManager objectForKey:DAYS] integerValue]:0;
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
