//
//  SCRSymbolicProgressBar.h
//  Bredbandskollen
//
//  Created by Aleks Nesterow-Rutkowski on 3/2/10.
//	aleks@screencustoms.com
//	
//	Purpose
//	Represents a progress-bar that consists of a number of identical elements, such as circles,
//	that however support two states: empty and filled.
//

@interface SCRSymbolicProgressBar : UIControl {

@private /* @property */
	
	CGFloat _value;
	NSUInteger _symbols;
	UIImage *_emptyImage, *_filledImage;
	
@private
	
	NSMutableArray *_imageViews;
}

/** Aligned to [0..1] range. If you want half of the symbols filled, specify 0.5. */
@property (nonatomic, assign) CGFloat value;
/** Amount of symbols used to represent the value. */
@property (nonatomic, assign) NSUInteger symbols;
@property (nonatomic, retain) UIImage *emptyImage, *filledImage;

@end
