//
//  SCRViewSlider.m
//  iAudition
//
//  Created by Aleks Nesterow-Rutkowski on 10/20/09.
//  aleks@screencustoms.com
//

#import "SCRViewSlider.h"

@interface SCRViewSlider (/* Private methods */)

- (void)__slideTableView:(SCRSlideDirection)direction;

@end

@implementation SCRViewSlider

@synthesize viewToSlide = _viewToSlide;
@synthesize ySlideDistance = _ySlideDistance, heightSlideDistance = _heightSlideDistance, slideDuration = _slideDuration;
@synthesize hideKeyboardOnReturn = _hideKeyboardOnReturn;

- (id)init {

	if ((self = [super init])) {
		_slideDuration = 0.3f;
	}
	return self;
}

- (void)dealloc {

	[_viewToSlide release];
	[super dealloc];
}

#pragma mark TextField Callbacks

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[self __slideTableView:SCRSlideDirectionUp];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	[self __slideTableView:SCRSlideDirectionDown];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	if (self.hideKeyboardOnReturn) {
		[textField resignFirstResponder];
	}
	
	return YES;
}

#pragma mark Private Methods

- (void)__slideTableView:(SCRSlideDirection)direction {
	
	CGFloat y = SCRSlideDirectionUp == direction ? -self.ySlideDistance : self.ySlideDistance;
	CGFloat height = SCRSlideDirectionUp == direction ? -self.heightSlideDistance : self.heightSlideDistance;
	
	CGRect rect = self.viewToSlide.frame;
	rect = CGRectMake(rect.origin.x, rect.origin.y + y, rect.size.width, rect.size.height + height);
	
	[UIView beginAnimations:@"SCRViewSlider::slideView" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:self.slideDuration];
	
	self.viewToSlide.frame = rect;

	[UIView commitAnimations];
}

@end
