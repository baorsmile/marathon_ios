//
//  BlockRatingPromptAlertView.h
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/13/12.
//  Copyright (c) 2012 Barrett Jacobsen. All rights reserved.
//

#import "BlockAlertView.h"
#import "SCRRatingView.h"

@class BlockRatingPromptAlertView;

typedef BOOL(^RatingTextFieldReturnCallBack)(BlockRatingPromptAlertView *);

@interface BlockRatingPromptAlertView : BlockAlertView <UITextFieldDelegate,SCRRatingDelegate> {
    
    NSCharacterSet *unacceptedInput;
    NSInteger maxLength;
    NSInteger currentRating;
    
    CGFloat keyboardHeight;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) SCRRatingView *ratingBar;

+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title placeholder:(NSString *)placeholder ratingValue:(NSInteger)ratingValue ratingBar:(out SCRRatingView**)ratingBar textField:(out UITextField**)textField block:(RatingTextFieldReturnCallBack) block ;

- (id)initWithTitle:(NSString *)title ratingValue:(NSInteger)ratingValue placeholder:(NSString*)placeholder block: (RatingTextFieldReturnCallBack) block;

+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText;
+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block:(RatingTextFieldReturnCallBack) block;

+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField;

+ (BlockRatingPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField block:(RatingTextFieldReturnCallBack) block;


- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block: (RatingTextFieldReturnCallBack) block;


- (void)setAllowableCharacters:(NSString*)accepted;
- (void)setMaxLength:(NSInteger)max;

@end
