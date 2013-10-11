//
//  SCRRadioCell.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 3/11/10.
//	aleks@screencustoms.com
//

#import "SCRRadioCell.h"

#import "SCRColorScheme.h"
#import "SCRMemoryManagement.h"

@implementation SCRRadioCell

#define kDefaultSelectedColor	RGB(56, 84, 135)
#define kDefaultColor			[UIColor blackColor]

@synthesize selectedColor = _selectedColor, defaultColor = _defaultColor;

#pragma mark init / dealloc

- (void)dealloc {
	
	SCR_RELEASE_SAFELY(_selectedColor);
	SCR_RELEASE_SAFELY(_defaultColor);
	
    [super dealloc];
}

#pragma mark State management

- (void)setAccessoryType:(UITableViewCellAccessoryType)value {
	
	[super setAccessoryType:value];
	
	UIColor *textColor;
	
	if (UITableViewCellAccessoryCheckmark == value) {
		textColor = self.selectedColor ? self.selectedColor : kDefaultSelectedColor;
	} else {
		textColor = self.defaultColor ? self.defaultColor : kDefaultColor;
	}
	
	self.textLabel.textColor = textColor;
}

@end
