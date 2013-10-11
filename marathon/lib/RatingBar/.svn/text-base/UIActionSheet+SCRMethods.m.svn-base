//
//  UIActionSheet+SCRMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 3/25/10.
//	aleks@screencustoms.com
//

#import "UIActionSheet+SCRMethods.h"

@interface UIActionSheet (SCRMethodsPrivate)

+ (UIActionSheet *)actionSheetWithMessage:(NSString *)message;

@end

@implementation UIActionSheet (SCRMethodsPrivate)

+ (UIActionSheet *)actionSheetWithMessage:(NSString *)message {
	
	return [[[UIActionSheet alloc] initWithTitle:message
										delegate:nil
							   cancelButtonTitle:NSLocalizedString(@"OK", @"")
						  destructiveButtonTitle:nil
							   otherButtonTitles:nil] autorelease];
}

@end

@implementation UIActionSheet (SCRMethods)

+ (void)showWithMessage:(NSString *)message fromTabBar:(UITabBar *)tabbar {
	
	[[UIActionSheet actionSheetWithMessage:message] showFromTabBar:tabbar];
}

+ (void)showWithMessage:(NSString *)message fromToolbar:(UIToolbar *)toolbar {

	[[UIActionSheet actionSheetWithMessage:message] showFromToolbar:toolbar];
}

+ (void)showWithMessage:(NSString *)message inView:(UIView *)view {

	[[UIActionSheet actionSheetWithMessage:message] showInView:view];
}

@end
