//
//  UIApplication+LocalNotifications.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 6/11/10.
//	aleks@screencustoms.com
//

#import "UIApplication+LocalNotifications.h"

@implementation UIApplication (LocalNotifications)

+ (void)showLocalNotification:(NSString *)text {
	
	[UIApplication showLocalNotification:text actionButton:nil];
}

+ (void)showLocalNotification:(NSString *)text actionButton:(NSString *)buttonText {

	Class notificationClass = NSClassFromString(@"UILocalNotification");
	
	if (notificationClass) {
		
		id notification = [[notificationClass alloc] init];
		
		if (notification) {
			
			[notification setAlertBody:text];
			[notification setAlertAction:buttonText];
			[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
			[notification release];
		}
	}
}

@end
