//
// MBProgressHUD.m
// Version 0.4
// Created by Matej Bukovinski on 2.4.09.
//

#import "MBProgressHUD.h"

#import "HJManagedGifV.h"

@interface MBProgressHUD ()

- (void)hideUsingAnimation:(BOOL)animated;
- (void)showUsingAnimation:(BOOL)animated;
- (void)done;
- (void)updateLabelText:(NSString *)newText;
- (void)updateDetailsLabelText:(NSString *)newText;
- (void)updateProgress;
- (void)updateIndicators;
- (void)handleGraceTimer:(NSTimer *)theTimer;
- (void)handleMinShowTimer:(NSTimer *)theTimer;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void)cleanUp;
- (void)deviceOrientationDidChange:(NSNotification*)notification;
- (void)launchExecution;
- (void)hideDelayed:(NSNumber *)animated;

@property (retain) UIView *indicator;
@property (assign) float width;
@property (assign) float height;
@property (retain) NSTimer *graceTimer;
@property (retain) NSTimer *minShowTimer;
@property (retain) NSDate *showStarted;

@end


@implementation MBProgressHUD

#pragma mark -
#pragma mark Accessors

@synthesize animationType;

@synthesize delegate;
@synthesize opacity;
@synthesize labelFont;
@synthesize detailsLabelFont;
@synthesize lineImageName;

@synthesize indicator;

@synthesize width;
@synthesize height;
@synthesize xOffset;
@synthesize yOffset;
@synthesize margin;

@synthesize graceTime;
@synthesize minShowTime;
@synthesize graceTimer;
@synthesize minShowTimer;
@synthesize taskInProgress;
@synthesize removeFromSuperViewOnHide;

@synthesize customView;

@synthesize showStarted;

#pragma mark HJManagedImageVDelegate
-(void) managedImageSet:(HJManagedImageV*)mi
{
    if (mi.image) {
        [kAppDelegate setGTipsBottomImage:mi.image];//更新小贴士保存的图片
    }
}

- (void)setMode:(MBProgressHUDMode)newMode {
    // Dont change mode if it wasn't actually changed to prevent flickering
    if (mode && (mode == newMode)) {
        return;
    }
	
    mode = newMode;
	
	if ([NSThread isMainThread]) {
		[self updateIndicators];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else {
		[self performSelectorOnMainThread:@selector(updateIndicators) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
	}
}

- (MBProgressHUDMode)mode {
	return mode;
}

- (void)setLabelText:(NSString *)newText {
	if ([NSThread isMainThread]) {
		[self updateLabelText:newText];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else {
		[self performSelectorOnMainThread:@selector(updateLabelText:) withObject:newText waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
	}
}

- (NSString *)labelText {
	return labelText;
}

- (void)setDetailsLabelText:(NSString *)newText {
	if ([NSThread isMainThread]) {
		[self updateDetailsLabelText:newText];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else {
		[self performSelectorOnMainThread:@selector(updateDetailsLabelText:) withObject:newText waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
	}
}

- (NSString *)detailsLabelText {
	return detailsLabelText;
}

- (void)setProgress:(float)newProgress {
    progress = newProgress;
	
    // Update display ony if showing the determinate progress view
    if (mode == MBProgressHUDModeDeterminate) {
		if ([NSThread isMainThread]) {
			[self updateProgress];
			[self setNeedsDisplay];
		} else {
			[self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO];
			[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
		}
    }
}

- (float)progress {
	return progress;
}

#pragma mark -
#pragma mark Accessor helpers

- (void)updateLabelText:(NSString *)newText {
    if (labelText != newText) {
        [labelText release];
        labelText = [newText copy];
    }
}

- (void)updateDetailsLabelText:(NSString *)newText {
    if (detailsLabelText != newText) {
        [detailsLabelText release];
        detailsLabelText = [newText copy];
    }
}

- (void)updateProgress {
    [(MBRoundProgressView *)indicator setProgress:progress];
}

- (void)updateIndicators {
    if (indicator) {
        [indicator removeFromSuperview];
    }
	
    if (mode == MBProgressHUDModeDeterminate) {
        self.indicator = [[[MBRoundProgressView alloc] init] autorelease];
    }else if (mode == MBProgressHUDModeCustomIndicator) {
        self.indicator = [[[MBActivityIndicatorView alloc] init] autorelease];
    }
    else if (mode == MBProgressHUDModeCustomView && self.customView != nil){
        self.indicator = self.customView;
    } else if (mode == MBProgressHUDModeCustomView && self.customView == nil) {
        self.indicator = nil;
    } else {
		self.indicator = [[[UIActivityIndicatorView alloc]
						   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        [(UIActivityIndicatorView *)indicator startAnimating];
	}
	
	
    [self addSubview:indicator];
}

#pragma mark -
#pragma mark Constants

#define PADDING 5.0f

#define LABELFONTSIZE 15.0f
#define LABELDETAILSFONTSIZE 15.0f

#pragma mark -
#pragma mark Class methods

+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
	return [hud autorelease];
}

//Add by wwq for force the HUD hidden , ignor wait time
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated ignorWaitTime:(BOOL)ignorWaitTime {
    NSMutableArray *removeArray = [NSMutableArray array];
	MBProgressHUD *viewToRemove = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
            [removeArray addObject:v];
		}
	}
    
    for (int i = 0; i < [removeArray count]; i++) {
        viewToRemove = (MBProgressHUD *)[removeArray objectAtIndex:i];
        viewToRemove.removeFromSuperViewOnHide = YES;
        if (YES == ignorWaitTime) {
            [viewToRemove hideUsingAnimation:animated];//忽略等待时间
        }else {
            [viewToRemove hide:animated];
        }
    }
    return YES;
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:view animated:animated ignorWaitTime:NO];
    return YES;    
}

+ (BOOL)hasHUDInView:(UIView *)view {
    UIView *hudView = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			hudView = v;
            break;
		}
	}
    if (hudView) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark Lifecycle methods

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (id)initWithView:(UIView *)view {
	// Let's check if the view is nil (this is a common error when using the windw initializer above)
	if (!view) {
		[NSException raise:@"MBProgressHUDViewIsNillException" 
					format:@"The view used in the MBProgressHUD initializer is nil."];
	}
	id me = [self initWithFrame:view.bounds];
	// We need to take care of rotation ourselfs if we're adding the HUD to a window
	if ([view isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:NO];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) 
												 name:UIDeviceOrientationDidChangeNotification object:nil];
	
	return me;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
        // Set default values for properties
        self.animationType = MBProgressHUDAnimationFade;
        self.mode = MBProgressHUDModeIndeterminate;
        self.labelText = nil;
        self.detailsLabelText = nil;
        self.lineImageName = nil;
        self.opacity = 0.8f;
        self.labelFont = [UIFont systemFontOfSize:LABELFONTSIZE];
        self.detailsLabelFont = [UIFont systemFontOfSize:LABELDETAILSFONTSIZE];
        self.xOffset = 0.0f;
        self.yOffset = 0.0f;
		self.margin = 20.0f; 
//        self.margin = 10.0f;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f; //小贴士最小显示时间
		self.removeFromSuperViewOnHide = NO;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		
        // Transparent background
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
		
        // Make invisible for now
        self.alpha = 0.0f;
		
        // Add label
        label = [[UILabel alloc] initWithFrame:self.bounds];
        
        // Add line
        lineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		
        // Add details label
        detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        if (bottomImageURL && [bottomImageURL length]>0) {
            bottomImageview.url = [NSURL URLWithString:bottomImageURL];
            [[kAppDelegate objManager] manage:bottomImageview];
            bottomImageview.callbackOnSetImage = self;
        }
        
		taskInProgress = NO;
		rotationTransform = CGAffineTransformIdentity;
    }
    return self;
}

- (void)dealloc {
    if (self.superview) {
        [self removeFromSuperview];
    }
    self.delegate = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [indicator release];
    [label release];
    [detailsLabel release];
    [labelText release];
    [detailsLabelText release];
    [lineImageView release];
    [lineImageName release];
	[graceTimer release];
	[minShowTimer release];
	[showStarted release];
	[customView release];
    
    [bottomImageview release];
    [bottomImageURL release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    CGRect frame = self.bounds;
	
    // Compute HUD dimensions based on indicator size (add margin to HUD border)
    CGRect indFrame;
    if (indicator) {
        indFrame = indicator.bounds;
    } else {
        indFrame = CGRectZero;
    }
    
    if (indicator) {
        margin = 20.0f;
    } else {
        margin = 15.0f;
    }
    
    self.width = indFrame.size.width + 2 * margin;
    self.height = indFrame.size.height + 2 * margin;
	
    // Position the indicator
    indFrame.origin.x = floorf((frame.size.width - indFrame.size.width) / 2) + self.xOffset;
    indFrame.origin.y = floorf((frame.size.height - indFrame.size.height) / 2) + self.yOffset;
    indicator.frame = indFrame;
	
    // Add label if label text was set
    if (nil != self.labelText) {
        // Get size of label text
        
//        CGSize dims = [self.labelText sizeWithFont:self.labelFont];
// fix dim		
        CGSize dims = [self.labelText sizeWithFont:self.labelFont constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
        
        // Compute label dimensions based on font metrics if size is larger than max then clip the label width
        float lHeight = dims.height;
        float lWidth;
        if (dims.width <= (frame.size.width - 2 * margin)) {
            lWidth = dims.width;
        }
        else {
            lWidth = frame.size.width - 4 * margin;
        }
		
        // Set label properties
        label.font = self.labelFont;
        label.numberOfLines = 0;
        label.adjustsFontSizeToFitWidth = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = self.labelText;
		
        // Update HUD size
        if (self.width < (lWidth + 2 * margin)) {
            self.width = lWidth + 2 * margin;
        }
        if (self.width > 280) {
            self.width = 280;
        }
        
        if (indicator) {
            self.height = self.height + lHeight + PADDING;
        } else {
            self.height = self.height + lHeight;
        }
        
		
        // Move indicator to make room for the label
        indFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2));
        indicator.frame = indFrame;
		
        // Set the label position and dimensions
        CGRect lFrame;
        if (indicator) {
            lFrame = CGRectMake(floorf((frame.size.width - lWidth) / 2) + xOffset,
                                floorf(indFrame.origin.y + indFrame.size.height + PADDING),
                                lWidth, lHeight);
        } else {
           lFrame = CGRectMake(floorf((frame.size.width - lWidth) / 2) + xOffset,
                         floorf(indFrame.origin.y + indFrame.size.height),
                         lWidth, lHeight);
        }
         
        label.frame = lFrame;
		
        [self addSubview:label];
        
        UIImage *defaultImage = [UIImage imageByName:@"loading_note_ad_none.png"];
        CGFloat bottomImageWidth = defaultImage.size.width;
        CGFloat bottomImageHeight = defaultImage.size.height;
		
        // Add details label delatils text was set
        if (nil != self.detailsLabelText) {
            
            [self changeDetailsText:-1];
            
            // Get size of label text
//            dims = [self.detailsLabelText sizeWithFont:self.detailsLabelFont];
            
            lWidth = frame.size.width - 2 * margin;
            if (lWidth > 200) {
                lWidth = 200;
            }
            dims = [detailsLabel.text sizeWithFont:self.detailsLabelFont constrainedToSize:CGSizeMake(lWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
			
            // Compute label dimensions based on font metrics if size is larger than max then clip the label width
            lHeight = dims.height;
			
            // Set label properties
            detailsLabel.font = self.detailsLabelFont;
            detailsLabel.adjustsFontSizeToFitWidth = NO;
            detailsLabel.textAlignment = NSTextAlignmentLeft;
            detailsLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            detailsLabel.numberOfLines = 0;
            detailsLabel.opaque = NO;
            detailsLabel.backgroundColor = [UIColor clearColor];
            detailsLabel.textColor = [UIColor lightGrayColor];
//            detailsLabel.text = self.detailsLabelText;
			
            // Update HUD size
            if (self.width < lWidth) {
                self.width = lWidth + 2 * margin;
            }
            if (self.width > 280) {
                self.width = 280;
            }
			
            // Move indicator to make room for the new label
            indFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2) + 15);
            indFrame.origin.y -= floorf(bottomImageHeight/2);
            indicator.frame = indFrame;
			
            // Move first label to make room for the new label
            lFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2) + 10);
            lFrame.origin.y -= floorf(bottomImageHeight/2);
            label.frame = lFrame;
            
            CGFloat _yOffset = lFrame.origin.y + lFrame.size.height + 3*PADDING;
            //add label 和 detailLabel 分隔线 Set line position
            if (lineImageName && [lineImageName length]>0) {
                
                CGRect lineFrame;
                lineFrame = CGRectMake(2, 
                                       _yOffset, self.width-2, 2);
                lineImageView.frame = lineFrame;
                lineImageView.center = CGPointMake(label.center.x, lineImageView.center.y);
                
                lineImageView.image = [UIImage stretchableImage:lineImageName leftCap:5 topCap:1];
                lineImageView.backgroundColor = [UIColor clearColor];
                [self addSubview:lineImageView];
                
//                indicator.frame = CGRectMake(indicator.frame.origin.x, label.frame.origin.y - indicator.frame.size.height - 15,
//                                             indicator.frame.size.width, indicator.frame.size.height);
                
                _yOffset = lineFrame.origin.y + lineFrame.size.height + 2*PADDING;
                
                // Update HUD size
                self.height = self.height + lineFrame.size.height + 4*PADDING;
            }
			
            // Set label position and dimensions
            CGRect lFrameD = CGRectMake(floorf((frame.size.width - lWidth) / 2) + xOffset,
                                        _yOffset, lWidth, lHeight);
            detailsLabel.frame = lFrameD;
            
            // Update HUD size
            self.height = self.height + lFrameD.size.height + 2*PADDING;
			
            [self addSubview:detailsLabel];
            
            //add 底部ImageView
            if (bottomImageview.image) {
                CGFloat bottomWidth = bottomImageWidth;
                CGFloat bottomHeight = bottomImageHeight;
                _yOffset = detailsLabel.frame.origin.y + detailsLabel.frame.size.height + 2*PADDING;
                // Update bottom Imageview
                CGRect bottomFrameD = CGRectMake((lFrameD.origin.x + lFrameD.size.width - bottomWidth) + xOffset,
                                                 _yOffset, bottomWidth, bottomHeight);
                bottomImageview.frame = bottomFrameD;
                
                // Update HUD size
                self.height = self.height + bottomFrameD.size.height + 2*PADDING;
                
                [self addSubview:bottomImageview];
            }
            
        }
    }
}

#pragma mark -
#pragma mark Showing and execution

- (void)show:(BOOL)animated {
	useAnimation = animated;
	
	// If the grace time is set postpone the HUD display
	if (self.graceTime > 0.0) {
		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime 
														   target:self 
														 selector:@selector(handleGraceTimer:) 
														 userInfo:nil 
														  repeats:NO];
	} 
	// ... otherwise show the HUD imediately 
	else {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)hide:(BOOL)animated {
    
	useAnimation = animated;
	
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && showStarted) {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
		if (interv < self.minShowTime) {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) 
																 target:self 
															   selector:@selector(handleMinShowTimer:) 
															   userInfo:nil 
																repeats:NO];
			return;
		} 
	}
	
	// ... otherwise hide the HUD immediately
    [self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:delay] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
	[self hide:[animated boolValue]];
}

- (void)handleGraceTimer:(NSTimer *)theTimer {
	// Show the HUD only if the task is still running
	if (taskInProgress) {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	
    methodForExecution = method;
    targetForExecution = [target retain];
    objectForExecution = [object retain];
	
    // Launch execution in new thread
	taskInProgress = YES;
    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
	
	// Show HUD view
	[self show:animated];
}

- (void)launchExecution {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    // Start executing the requested task
    [targetForExecution performSelector:methodForExecution withObject:objectForExecution];
	
    // Task completed, update view in main thread (note: view operations should
    // be done only in the main thread)
    [self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	
    [pool release];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    [self done];
}

- (void)done {
    isFinished = YES;
	
    // If delegate was set make the callback
    self.alpha = 0.0f;
    
	if(delegate != nil) {
        if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
            [delegate performSelector:@selector(hudWasHidden:) withObject:self];
        } else if ([delegate respondsToSelector:@selector(hudWasHidden)]) {
            [delegate performSelector:@selector(hudWasHidden)];
        }
	}
	
	if (removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
}

- (void)cleanUp {
	taskInProgress = NO;
	
	self.indicator = nil;
	
    [targetForExecution release];
    [objectForExecution release];
	
    [self hide:useAnimation];
}

#pragma mark -
#pragma mark Fade in and Fade out

- (void)showUsingAnimation:(BOOL)animated {
    self.alpha = 0.0f;
    if (animated && animationType == MBProgressHUDAnimationZoom) {
        self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
    }
    
	self.showStarted = [NSDate date];
    // Fade in
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        self.alpha = 1.0f;
        if (animationType == MBProgressHUDAnimationZoom) {
            self.transform = rotationTransform;
        }
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0f;
    }
}

- (void)hideUsingAnimation:(BOOL)animated {
    // Fade out
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
        // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
        // in the done method
        if (animationType == MBProgressHUDAnimationZoom) {
            self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
        }
        self.alpha = 0.02f;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 0.0f;
        [self done];
    }
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
    // Center HUD
    CGRect allRect = self.bounds;
    // Draw rounded HUD bacgroud rect
    CGRect boxRect = CGRectMake(roundf((allRect.size.width - self.width) / 2) + self.xOffset,
                                roundf((allRect.size.height - self.height) / 2) + self.yOffset, self.width, self.height);
	// Corner radius
	float radius = 10.0f;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

#pragma mark -
#pragma mark Manual oritentation change

#define RADIANS(degrees) ((degrees * (float)M_PI) / 180.0f)

- (void)deviceOrientationDidChange:(NSNotification *)notification { 
	if (!self.superview) {
		return;
	}
	if ([self.superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	NSInteger degrees = 0;
	
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; } 
		else { degrees = 90; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; } 
		else { degrees = 0; }
	}
	
	rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));

	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

@end


/////////////////////////////////////////////////////////////////////////////////////////////

@implementation MBRoundProgressView

#pragma mark -
#pragma mark Accessors

- (float)progress {
    return _progress;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Lifecycle

- (id)init {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
    }
    return self;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    
    CGRect allRect = self.bounds;
    CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw background
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.1f); // translucent white
    CGContextSetLineWidth(context, 2.0f);
    CGContextFillEllipseInRect(context, circleRect);
    CGContextStrokeEllipseInRect(context, circleRect);
    
    // Draw progress
    CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
    CGFloat radius = (allRect.size.width - 4) / 2;
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////

@implementation MBActivityIndicatorView

#pragma mark -
#pragma mark Lifecycle

- (id)init {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
        
        indicatorView = [[[UIImageView alloc] initWithFrame:self.frame] autorelease];
        indicatorView.center = self.center;
        indicatorView.image = [UIImage imageByName:@"animation_say_wave.png"];
        indicatorView.backgroundColor = [UIColor clearColor];
        [self addSubview:indicatorView];
        
        
        [self beginAnimation];
    }
    return self;
}

- (void)beginAnimation {
    
    [indicatorView.layer removeAllAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D: 
                         CATransform3DMakeRotation(M_PI/2, 0, 0, 0.01) ];
    animation.duration = 0.5;
    animation.cumulative = YES;
    animation.repeatCount = INT32_MAX;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,indicatorView.frame.size.width, indicatorView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size); 
    [indicatorView.image drawInRect:CGRectMake(1,1,indicatorView.frame.size.width-2,indicatorView.frame.size.height-2)];
    indicatorView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [indicatorView.layer addAnimation:animation forKey:@"MBActivityIndicator"]; 
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////
