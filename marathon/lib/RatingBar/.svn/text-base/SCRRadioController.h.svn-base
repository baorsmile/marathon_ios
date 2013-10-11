//
//  SCRRadioViewController.h
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 12/22/09.
//	aleks@screencustoms.com
//	
//	Purpose
//	Provides a generic way to display one-choice options.
//

@class SCRRadioController;

@protocol SCRRadioControllerDelegate<NSObject>

- (void)radioController:(SCRRadioController *)radioController setSelectedIndex:(NSUInteger)selectedIndex forKey:(NSString *)key;

@end

@interface SCRRadioController : UITableViewController {
	
@private
	id <SCRRadioControllerDelegate> _delegate;
	
	NSUInteger _selectedIndex;
	NSArray *_optionList;
	NSString *_key;
	SEL _selector;
}

@property (nonatomic, assign) id <SCRRadioControllerDelegate> delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, retain) NSArray *optionList;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) SEL selector;

@end
