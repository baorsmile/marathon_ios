//
//  UIApplication+SCRMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 6/11/10.
//	aleks.nesterow@gmail.com
//

#import "UIApplication+UniversalApp.h"

@implementation UIApplication (UniversalApp)

+ (void)setStatusBarHidden:(BOOL)value {

	UIApplication *app = [UIApplication sharedApplication];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		[app setStatusBarHidden:value withAnimation:UIStatusBarAnimationFade];
		
	} else {
		
		if ([app respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
			
			[app setStatusBarHidden:value withAnimation:UIStatusBarAnimationFade];
			
		} else {
			
			BOOL animated = YES;
			
			SEL theSelector = @selector(setStatusBarHidden:animated:);
			NSMethodSignature *aSignature = [UIApplication instanceMethodSignatureForSelector:theSelector];
			NSInvocation *anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
			
			[anInvocation setSelector:theSelector];
			[anInvocation setTarget:app];
			
			[anInvocation setArgument:&value atIndex:2];
			[anInvocation setArgument:&animated atIndex:3];
			
			[anInvocation invoke];
		}
	}
}

@end
