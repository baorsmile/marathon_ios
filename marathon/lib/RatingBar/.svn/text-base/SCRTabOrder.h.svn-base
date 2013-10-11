//
//  SCRTabOrder.h
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 2/12/10.
//	aleks@screencustoms.com
//	
//	Purpose
//	Allows to go from one field to another using Next button on the screen keyboard.
//	The last text-field when Done clicked will close the keyboard.
//

@class SCRTabOrder;

@protocol SCRTabOrderDelegate <NSObject>

@required

- (BOOL)tabOrderShouldReturn:(SCRTabOrder *)tabOrder;

@optional

- (UIReturnKeyType)returnKeyTypeForLastTextField:(SCRTabOrder *)tabOrder;

@end

@class SCRTabOrderGroup;

@interface SCRTabOrder : NSObject<UITextFieldDelegate> {

@private
	id <SCRTabOrderDelegate> _delegate;
	NSMutableArray *_textFields;
}

@property (nonatomic, assign) IBOutlet id <SCRTabOrderDelegate> delegate;

- (void)addTextField:(UITextField *)textField;
- (void)removeTextField:(UITextField *)textField;

@end
