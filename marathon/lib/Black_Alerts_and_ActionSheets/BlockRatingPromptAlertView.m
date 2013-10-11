//
//  BlockRatingPromptAlertView.m
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/13/12.
//  Copyright (c) 2012 Barrett Jacobsen. All rights reserved.
//

#import "BlockRatingPromptAlertView.h"

#define kTextBoxHeight      31
#define kTextBoxSpacing     10
#define kTextBoxHorizontalMargin 12

#define kRatingBarHeight      44
#define kRatingBarSpacing     10
#define kRatingBarHorizontalMargin 12

#define kKeyboardResizeBounce         20

@interface BlockRatingPromptAlertView()
@property(nonatomic, copy) RatingTextFieldReturnCallBack callBack;
@end

@implementation BlockRatingPromptAlertView
@synthesize textField, callBack,ratingBar;

#pragma mark 
#pragma mark RatingBar delegate
- (void)ratingView:(SCRRatingView *)_ratingView didChangeUserRatingFrom:(NSInteger)previousUserRating to:(NSInteger)userRating {
    
    currentRating = userRating;
    if (userRating != 0) {
        _ratingView.rating = userRating;
    }
}

- (void)ratingView:(SCRRatingView *)_ratingView didChangeRatingFrom:(CGFloat)previousRating
				to:(CGFloat)rating {
    
    //DO nothing  
}

- (void)currentRating:(NSInteger)currentRating {
    //DO nothing 
}


+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText {
    return [self promptWithTitle:title message:message defaultText:defaultText block:nil];
}

+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block:(RatingTextFieldReturnCallBack)block {
    return [[[BlockRatingPromptAlertView alloc] initWithTitle:title message:message defaultText:defaultText block:block] autorelease];
}

+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField {
    return [self promptWithTitle:title message:message textField:textField block:nil];
}


+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField block:(RatingTextFieldReturnCallBack) block{
    BlockRatingPromptAlertView *prompt = [[[BlockRatingPromptAlertView alloc] initWithTitle:title message:message defaultText:nil block:block] autorelease];
    
    *textField = prompt.textField;
    
    return prompt;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block: (RatingTextFieldReturnCallBack) block {
    
    self = [super initWithTitle:title message:message];
    
    if (self) {
        UITextField *theTextField = [[[UITextField alloc] initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, _view.bounds.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight)] autorelease]; 
        
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setTextAlignment:NSTextAlignmentCenter];
        [theTextField setClearButtonMode:UITextFieldViewModeAlways];
        
        if (defaultText)
            theTextField.text = defaultText;
        
        if(block){
            theTextField.delegate = self;
        }
        
        [_view addSubview:theTextField];
        
        self.textField = theTextField;
        
        _height += kTextBoxHeight + kTextBoxSpacing;
        
        self.callBack = block;
    }
    
    return self;
}

#pragma mark -
#pragma mark RatingBar
+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title placeholder:(NSString *)placeholder ratingValue:(NSInteger)ratingValue ratingBar:(out SCRRatingView**)ratingBar textField:(out UITextField**)textField block:(RatingTextFieldReturnCallBack) block {
    BlockRatingPromptAlertView *prompt = [[[BlockRatingPromptAlertView alloc] initWithTitle:title ratingValue:ratingValue placeholder:placeholder block:block] autorelease];
    
    *textField = prompt.textField;
    *ratingBar = prompt.ratingBar;
    
    return prompt;
}

- (id)initWithTitle:(NSString *)title ratingValue:(NSInteger)ratingValue placeholder:(NSString*)placeholder block: (RatingTextFieldReturnCallBack) block {
    
    self = [super initWithTitle:title message:nil];
    
    if (self) {
        //add rating bar
        SCRRatingView *theRatingBar = [[[SCRRatingView alloc] initWithFrame:CGRectMake(kRatingBarHorizontalMargin, _height, _view.bounds.size.width - kRatingBarHorizontalMargin * 2, kRatingBarHeight)] autorelease];
        [theRatingBar setStarImage:[UIImage imageByName:@"ico_star_big.png"]
                             forState:kSCRatingViewHighlighted];
        [theRatingBar setStarImage:[UIImage imageByName:@"ico_star_big.png"]
                             forState:kSCRatingViewHot];
        [theRatingBar setStarImage:[UIImage imageByName:@"ico_star_big_none.png"]
                             forState:kSCRatingViewNonSelected];
        [theRatingBar setStarImage:[UIImage imageByName:@"ico_star_big.png"]
                             forState:kSCRatingViewSelected];
        [theRatingBar setStarImage:[UIImage imageByName:@"ico_star_big.png"]
                             forState:kSCRatingViewUserSelected];
        theRatingBar.rating = ratingValue;
        [_view addSubview:theRatingBar];
        self.ratingBar = theRatingBar;
        
        _height += kRatingBarHeight + kRatingBarSpacing;
        
        //add TextField
        UITextField *theTextField = [[[UITextField alloc] initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, _view.bounds.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight)] autorelease]; 
        
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setTextAlignment:NSTextAlignmentLeft];
        [theTextField setClearButtonMode:UITextFieldViewModeAlways];
        [theTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [theTextField setReturnKeyType:UIReturnKeyDone];
        
        if (placeholder)
            theTextField.placeholder = placeholder;
        
        if(block){
            theTextField.delegate = self;
        }
        
        [_view addSubview:theTextField];
        
        self.textField = theTextField;
        
        _height += kTextBoxHeight + kTextBoxSpacing;
        
        self.callBack = block;
    }
    
    return self;
}

- (void)show {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的  
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
//#ifdef __IPHONE_5_0
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 5.0) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
	}
#endif
    
    [super show];
    
    [self.textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 5.0) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
	}
#endif
    
}

- (void)recheckFrameOrigin {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    __block CGRect frame = _view.frame;
    
    CGFloat originY = screenHeight - keyboardHeight - frame.size.height;
    
    if (originY < 0)
        originY = 0;
    
    if (originY != frame.origin.y) {
        frame.origin.y = originY;
        _view.frame = frame;
        
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    __block CGRect frame = _view.frame;
    
    //    if (frame.origin.y + frame.size.height > screenHeight - keyboardSize.height) {
    
    keyboardHeight = keyboardSize.height;
    
    frame.origin.y = screenHeight - keyboardHeight - frame.size.height;
    
    if (frame.origin.y < 0)
        frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _view.frame = frame;
                     } 
                     completion:^(BOOL finished){
                         [self recheckFrameOrigin];
                     }];
    //    }
}


- (void)keyboardWillChangeHeight:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    __block CGRect frame = _view.frame;
    frame.origin.y = screenHeight - keyboardHeight - frame.size.height;
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _view.frame = frame;
                     } 
                     completion:^(BOOL finished){
                         [self recheckFrameOrigin];
                     }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    keyboardHeight = 0.0;
}


- (void)setAllowableCharacters:(NSString*)accepted {
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:accepted] invertedSet];
    self.textField.delegate = self;
}

- (void)setMaxLength:(NSInteger)max {
    maxLength = max;
    self.textField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField{
    if(callBack){
        return callBack(self);
    }
    return NO;
}

- (BOOL)textField:(UITextField *)_textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [_textField resignFirstResponder];
        return NO;
    }
	
	if (range.location > maxLength)
        return NO; // return NO to not change text
	
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [self.textField.text length] + [string length] - range.length;
    
    if (maxLength > 0 && newLength > maxLength)
        return NO;
    
    if (!unacceptedInput)
        return YES;
    
    if ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] > 1)
        return NO;
    else 
        return YES;
}

- (void)dealloc
{
    self.callBack = nil;
    [super dealloc];
}

@end
