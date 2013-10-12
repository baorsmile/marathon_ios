//
//  AppDelegate.h
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,LoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RootViewController *rootVC;
@property (nonatomic, strong) LoginViewController *loginVC;


@end
