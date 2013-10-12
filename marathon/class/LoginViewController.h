//
//  LoginViewController.h
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginSuccess;
@end

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id<LoginViewControllerDelegate> delegate;

@end
