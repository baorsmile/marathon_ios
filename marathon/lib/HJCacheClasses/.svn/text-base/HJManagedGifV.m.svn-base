//
//  HJManagedGifV.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJManagedGifV.h"

@interface HJManagedGifV ()

@end


@implementation HJManagedGifV

@synthesize oid;
@synthesize url;
@synthesize moHandler;

@synthesize callbackOnSetGif;
@synthesize callbackOnCancel;
@synthesize loadingWheel;
@synthesize index;

@synthesize originalPath;
@synthesize from;
@synthesize isGifCompleteLoaded;
@synthesize gifFullPath,gifData;
@synthesize waitingTime;

@synthesize isLocalDefaultGif;

#pragma mark - UIView lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		isCancelled = NO;
        isGifCompleteLoaded = NO;
		url=nil;
		index = -1;
		self.userInteractionEnabled = YES;//用户交互的总开关
        UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        touch.numberOfTapsRequired = 2;
        [self addGestureRecognizer:touch];
        [touch release];
        
        waitingTime = 60;
        
        isLocalDefaultGif = NO;
    }
    return self;
}

- (void)dealloc {
	[self clear];
    self.originalPath = nil;
	self.callbackOnCancel=nil;
	self.loadingWheel=nil;
    
    
    [super dealloc];
}


-(void) clear {
	[self.moHandler removeUser:self];
	self.moHandler = nil;
	self.oid = nil;
	self.url = nil;
    
    self.gifData = nil;
    self.gifFullPath = nil;
}

-(void) changeManagedObjStateFromLoadedToReady {
	if (moHandler.moData) {
		moHandler.managedObj=[NSData dataWithData:moHandler.moData];
        self.from = GIF_FROM_NET;
	} else if (moHandler.moReadyDataFilename) {
		moHandler.managedObj=[NSData dataWithContentsOfFile:moHandler.moReadyDataFilename];
        self.from = GIF_FROM_FILE;
	} else {
		NSLog(@"HJManagedGifV error in changeManagedObjStateFromLoadedToReady ?");
	}
}

-(void) managedObjFailed {
	NSLog(@"moHandlerFailed %@",moHandler);
	[gifData release];
	self.gifData = nil;
}

-(void) managedObjReady {
    isGifCompleteLoaded = YES;
	[self setGifData:moHandler.managedObj];
}

-(void) markCancelled {
    [loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
    
	isCancelled = YES;
    if (callbackOnCancel && [callbackOnCancel respondsToSelector:@selector(managedGifCancelled:)]) {
        [callbackOnCancel managedGifCancelled:self];
    }
}

-(void)setGifData:(NSData*)theGifData {

	if (theGifData==gifData) {
		//when the same gif is on the screen multiple times, an image that is alredy set might be set again with the same gif.
		return; 
	}
	[gifData release];
    gifData = nil;
	gifData = theGifData;
    [gifData retain];
    
    if (callbackOnSetGif && [callbackOnSetGif respondsToSelector:@selector(managedGifSet:)]) {
        [callbackOnSetGif managedGifSet:self];
    }
    
    if ([gifData isKindOfClass:[UIImage class]]) {
        NSData* imageData = UIImageJPEGRepresentation((UIImage*)gifData, 1.0);
        [self setGIFImageData:imageData];
    }else if ([gifData isKindOfClass:[NSData class]]) {
        [self setGIFImageData:gifData];
    }
    
	//// NSLog(@"setImageCallback from %@ to %@",self,callbackOnSetRecord);
	[loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
	self.hidden=NO;
}

- (void)stopLoadingWheel {
    
    [loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView* _loadingWheel = (UIActivityIndicatorView*)subview;
            [_loadingWheel stopAnimating];
            [_loadingWheel removeFromSuperview];
        }
    }
}

-(void)showLoadingWheel {
	[self stopLoadingWheel];
	self.loadingWheel = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	loadingWheel.center = self.center;
    loadingWheel.frame = CGRectMake((self.frame.size.width-self.loadingWheel.frame.size.width)/2, (self.frame.size.height-self.loadingWheel.frame.size.height)/2, self.loadingWheel.frame.size.width, self.loadingWheel.frame.size.height);
	loadingWheel.hidesWhenStopped=YES;
	[self addSubview:loadingWheel];
	[loadingWheel startAnimating];
    
    [self performSelector:@selector(stopLoadingWheel) withObject:nil afterDelay:waitingTime];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer{
    [self becomeFirstResponder];
}

@end


