//
//  AppDelegate.m
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize rootVC,loginVC,code,gDeviceToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (isIOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds = YES;
        self.window.frame = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20);
    }
    
    self.rootVC = [[RootViewController alloc] init];
    self.window.rootViewController = rootVC;
    
    self.code = [PersistenceHelper dataForKey:INVITECODE];
    if (code && [code length] > 0) {
        DMLog(@"自动登录成功");
    }else{
        self.loginVC = [[LoginViewController alloc] init];
        loginVC.delegate = self;
        [self.window addSubview:loginVC.view];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送通知"
                                                           message:@"这是通过推送窗口启动的程序，你可以在这里处理推送内容"
                                                          delegate:nil
                                                 cancelButtonTitle:@"知道了"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 注册远程推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * tokenAsString = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    DMLog(@"token : %@", tokenAsString);
    self.gDeviceToken = tokenAsString;
//    // 记录本机设备token，允许服务器端发送通知
//    self.gDeviceToken = tokenAsString;
//    [PersistenceHelper setData:tokenAsString forKey:@"deviceToken"];
//	NSString* sendString = UPLOAD_DEVICETOKEN(tokenAsString);
//	[clientConnection get:sendString withID:kRequestDeviceToken];
}

// Provide a user explanation for when the registration fails
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DMLog(@"!!!!!!!Error in registration. Error: %@", error);
}

#pragma mark - 程序收到远程推送消息 Remote notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	DMLog(@"%@", userInfo);
    
	//接收到push  设置badge的值
	NSString *badgeStr = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
	if (badgeStr != nil) {
		[UIApplication sharedApplication].applicationIconBadgeNumber = [badgeStr intValue];
	}
}

#pragma mark - LoginViewControllerDelegate
- (void)loginSuccess{
    [UIView animateWithDuration:0.5 animations:^{
        self.loginVC.view.frame = CGRectMake(0, SCREEN_HEIGHT*2, self.loginVC.view.frame.size.width, self.loginVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        double delayInSeconds = 1.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
        });
    }];
}

@end
