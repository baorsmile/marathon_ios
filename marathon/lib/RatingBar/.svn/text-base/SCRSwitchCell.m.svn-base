//
//  SCRSwitchCell.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 2/18/10.
//	aleks@screencustoms.com
//

#import "SCRSwitchCell.h"
#import "SCRMemoryManagement.h"

@implementation SCRSwitchCell

#define kOffset			10
#define kTitleFontSize	17

@synthesize titleLabel = _titleLabel, optionSwitch = _optionSwitch;

- (CGRect)__calculateTitleLabelRect {
	
	CGFloat width = CGRectGetWidth(self.contentView.frame);
	CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CGFloat switchWidth = CGRectGetWidth(self.optionSwitch.frame);
	
	CGRect result = CGRectMake(kOffset, 0, width - switchWidth - kOffset * 3, height);
	return result;
}

- (CGRect)__calculateOptionSwitchRect {
	
	CGFloat width = CGRectGetWidth(self.contentView.frame);
	CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CGFloat switchWidth = CGRectGetWidth(self.optionSwitch.frame);
    CGFloat switchHeight = CGRectGetHeight(self.optionSwitch.frame);
	
	CGRect result = CGRectMake(width - kOffset - switchWidth, (height - switchHeight) / 2.,
							   switchWidth, switchHeight);
	return result;
}

- (void)__initializeComponent {
	
    self.backgroundColor = [UIColor whiteColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_titleLabel = [[UILabel alloc] initWithFrame:[self __calculateTitleLabelRect]];
	_titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
	[self.contentView addSubview:_titleLabel];
	
	_optionSwitch = [[UISwitch alloc] initWithFrame:[self __calculateOptionSwitchRect]];
	[self.contentView addSubview:_optionSwitch];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {

	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		
		[self __initializeComponent];
	}
	
	return self;
}

- (void)dealloc {
	
	SCR_RELEASE_SAFELY(_titleLabel);
	SCR_RELEASE_SAFELY(_optionSwitch);
	
    [super dealloc];
}

- (void)layoutSubviews {

	[super layoutSubviews];
	
	self.titleLabel.frame = [self __calculateTitleLabelRect];
	self.optionSwitch.frame = [self __calculateOptionSwitchRect];
}

@end
