//
//  UIAlertView+SCRMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 3/14/10.
//	aleks@screencustoms.com
//

#import "UIAlertView+SCRMethods.h"

@implementation UIAlertView (SCRMethods)

+ (UIAlertView *)alertViewFromError:(NSError *)error {
	
	UIAlertView *result = [[[UIAlertView alloc] 
							initWithTitle:NSLocalizedString([error localizedFailureReason], @"")
							message:NSLocalizedString([error localizedDescription], @"")
							delegate:nil
							cancelButtonTitle:NSLocalizedString(@"OK", @"")
							otherButtonTitles:nil] autorelease];
	return result;
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message {
	
	[[[[UIAlertView alloc] initWithTitle:title
								 message:message
								delegate:nil
					   cancelButtonTitle:NSLocalizedString(@"OK", @"")
					   otherButtonTitles:nil] autorelease] show];
}

+ (void)showWithMessage:(NSString *)message {
	
	[UIAlertView showWithTitle:nil message:message];
}

@end
