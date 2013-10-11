//
//  HJManagedImageV.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJManagedImageV.h"

@interface UIImage (Grayscale)
- (UIImage *) partialImageWithPercentage:(float)percentage grayscaleRest:(BOOL)grayscaleRest;
@end

@implementation UIImage (Grayscale)
- (UIImage *) partialImageWithPercentage:(float)percentage grayscaleRest:(BOOL)grayscaleRest {
    const int ALPHA = 0;
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    CGRect imageRect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    memset(pixels, 0, width * height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    int x_origin = 0;
    int y_to = height * percentage;
    for(int y = 0; y < y_to; y++) {
        for(int x = x_origin; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
    
            grayscaleRest = YES;
            if (grayscaleRest) {
                uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                
                rgbaPixel[RED] = gray;
                rgbaPixel[GREEN] = gray;
                rgbaPixel[BLUE] = gray;
            }
            else {
                rgbaPixel[ALPHA] = 0;
                rgbaPixel[RED] = 0;
                rgbaPixel[GREEN] = 0;
                rgbaPixel[BLUE] = 0;
            }
        }
    }
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:self.scale
                                           orientation:UIImageOrientationUp];
    
    CGImageRelease(image);
    
    return resultUIImage;
}

@end

@interface HJManagedImageV ()
- (void)commonInit;
- (void)updateDrawing;
@end


@implementation HJManagedImageV

@synthesize oid;
@synthesize url;
@synthesize moHandler;

@synthesize callbackOnSetImage;
@synthesize callbackOnCancel;
@synthesize imageView;
@synthesize modification;
@synthesize loadingWheel;
@synthesize index;
@synthesize originalPath;
@synthesize from;
@synthesize isImageCompleteLoaded;

@synthesize waitingTime;

@synthesize progress = _progress;
@synthesize hasGrayscaleBackground = _hasGrayscaleBackground;
@synthesize errorLabel;

@synthesize _originalImage;
@synthesize fileName,vendorID;
@synthesize isUseDefaultImage;
@synthesize isNeedShowError,isDownloadError;
@synthesize zoomScale;//缩放比例，如果小于1，则缩小后再显示

#pragma mark - UIView lifecycle
- (void)commonInit
{
    _progress = 0.f;
    _hasGrayscaleBackground = YES;
    self._originalImage = self.image;
}

#pragma mark - Custom Accessor
- (void)setProgress:(float)progress
{
    //_progress = progress;
    _progress = MIN(MAX(0.f, progress), 1.f);
    [self updateDrawing];
}

- (void)setHasGrayscaleBackground:(BOOL)hasGrayscaleBackground
{
    _hasGrayscaleBackground = hasGrayscaleBackground;
    [self updateDrawing];
}

#pragma mark - drawing
- (void)updateDrawing
{
    _internalUpdating = YES;
    
    self.image = [_originalImage partialImageWithPercentage:_progress grayscaleRest:_hasGrayscaleBackground];
}


- (id)initWithFrame:(CGRect)frame {
    [self commonInit];
    self = [super initWithFrame:frame];
    if (self) {
		isCancelled = NO;
        isImageCompleteLoaded = NO;
		modification=0;
		url=nil;
		onImageTap = nil;
		index = -1;
		self.userInteractionEnabled = NO; //because want to treat it like a UIImageView. Just turn this back on if you want to catch taps.
        
        waitingTime = 120;
        
        isUseDefaultImage = NO;
        isNeedShowError = NO;
        isDownloadError = NO;
        
        zoomScale = 1;
    }
    return self;
}

- (void)dealloc {
	[self clear];
    self._originalImage = nil;
    self.originalPath = nil;
	self.callbackOnCancel=nil;
	self.loadingWheel=nil;
    if (onImageTap) {
        [onImageTap release];
        onImageTap = nil;
    }
    
    self.fileName = nil;
    self.vendorID = nil;
    
    [super dealloc];
}


-(void) clear {
	[self.moHandler removeUser:self];
	self.moHandler = nil;
	[imageView removeFromSuperview];
	self.image = nil;
	self.imageView.image = nil;
	self.imageView =nil;
	self.oid = nil;
	self.url = nil;
}

/*
-(void) clear {
	self.url = nil;
	self.callbackOnSetImage = nil;
	//int rc1 = [image retainCount];
	[self.imageView removeFromSuperview];
	self.imageView = nil;
	//int rc2 = [image retainCount];
	[image release]; image=nil; //do this instead of self.image=nil because setImage has more code
	self.loadingWheel = nil;
}
*/


-(void) changeManagedObjStateFromLoadedToReady {
	if (moHandler.moData) {
        if (zoomScale < 1) {//压缩图片
            moHandler.moData = UIImageJPEGRepresentation([Utility imageWithImageSimple:[UIImage imageWithData:moHandler.moData] scaledToSize:CGSizeMake(70, 100)], zoomScale);
        }
        
        moHandler.managedObj=[UIImage imageWithData:moHandler.moData];
        
        self.from = IMAGE_FROM_NET;
	} else if (moHandler.moReadyDataFilename) {
        if (zoomScale < 1) {//压缩图片
            UIImage* smallImage = [Utility imageWithImageSimple:[UIImage imageWithContentsOfFile:moHandler.moReadyDataFilename] scaledToSize:CGSizeMake(70, 100)];
            if (smallImage) {
                [UIImageJPEGRepresentation(smallImage, zoomScale) writeToFile:moHandler.moReadyDataFilename atomically:YES];
            }
        }
        
		moHandler.managedObj=[UIImage imageWithContentsOfFile:moHandler.moReadyDataFilename];
        self.from = IMAGE_FROM_FILE;
	} else {
		// NSLog(@"HJManagedImageV error in changeManagedObjStateFromLoadedToReady ?");
	}
}

#pragma mark - 获取失败
-(void) managedObjFailed {
	// NSLog(@"moHandlerFailed %@",moHandler);
	[image release];
	image = nil;
    
    [self stopLoadingWheel];
    
    isDownloadError = YES;
    if (YES == isNeedShowError) {
        if (errorLabel == nil) {
            self.errorLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 180, 15)] autorelease];
            errorLabel.font = [UIFont boldSystemFontOfSize:12];
            errorLabel.textColor = LIGHT_COFFEE_TEXT_COLOR;
            errorLabel.backgroundColor = [UIColor clearColor];
            errorLabel.numberOfLines = 1;
            errorLabel.textAlignment = UITextAlignmentCenter;
            errorLabel.lineBreakMode = UILineBreakModeTailTruncation;
            errorLabel.userInteractionEnabled = NO;
        }
        [self addSubview:errorLabel];
        errorLabel.center = CGPointMake(self.center.x, errorLabel.center.y);
        errorLabel.alpha = 1;
        errorLabel.text = @"获取图片失败，点击图片重试";
        [errorLabel setNeedsLayout];
    }
    
}

-(void) managedObjReady {
    isImageCompleteLoaded = YES;
    isDownloadError = NO;
	[self setImage:moHandler.managedObj];
}


-(UIImage*) image {
	return image; 
}

-(void) markCancelled {
    [loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
    
	isCancelled = YES;
	[callbackOnCancel managedImageCancelled:self];
}

-(UIImage*) modifyImage:(UIImage*)theImage modification:(int)mod {
	return theImage;
}


-(void) setImage:(UIImage*)theImage modification:(int)mod {
	if (mod==modification) {
		[self setImage:theImage];
	} else {
		UIImage* modified = [self modifyImage:theImage modification:(int)mod];
		[self setImage:modified];
	}
}

- (void) setImageWithoutCallBack:(UIImage *)theImage{
    errorLabel.alpha = 0;
    
	if (theImage==image) {
		//when the same image is on the screen multiple times, an image that is alredy set might be set again with the same image.
		return;
	}
	[image release];
    image = nil;
    image = theImage;
    [image retain];
	
	[imageView removeFromSuperview];
    
    self.imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
	//// NSLog(@"setImageCallback from %@ to %@",self,callbackOnSetImage);
	[loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
	self.hidden=NO;
	if (image!=nil) {
        if (url) {
            isUseDefaultImage = NO;
        }else {
            isUseDefaultImage = YES;
        }
        
        if (!_internalUpdating) {
            [_originalImage release];
            _originalImage = nil;
            self._originalImage = image;
//            [self updateDrawing];
        }
        
        _internalUpdating = NO;
	}
}


-(void) setImage:(UIImage*)theImage {
    
    errorLabel.alpha = 0;
    
	if (theImage==image) {
		//when the same image is on the screen multiple times, an image that is alredy set might be set again with the same image.
		return; 
	}
	[image release];
    image = nil;
    image = theImage;
    [image retain];
	
	[imageView removeFromSuperview];

    self.imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    if (url) {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }else {
        imageView.contentMode = UIViewContentModeScaleToFill;
    }
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
	//// NSLog(@"setImageCallback from %@ to %@",self,callbackOnSetImage);
	[loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
	self.hidden=NO;
	if (image!=nil) {
        if (url) {
            isUseDefaultImage = NO;
        }else {
            isUseDefaultImage = YES;
        }
		
        if (!_internalUpdating) {
            [_originalImage release];
            _originalImage = nil;
            self._originalImage = image;
            [self updateDrawing];
        }
        
        if ([callbackOnSetImage respondsToSelector:@selector(managedImageSet:)]) {
           [callbackOnSetImage managedImageSet:self]; 
        }
        
        _internalUpdating = NO;
	}
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
	self.loadingWheel = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	loadingWheel.center = self.center;
    loadingWheel.frame = CGRectMake((self.frame.size.width-self.loadingWheel.frame.size.width)/2, (self.frame.size.height-self.loadingWheel.frame.size.height)/2, self.loadingWheel.frame.size.width, self.loadingWheel.frame.size.height);
	loadingWheel.hidesWhenStopped=YES;
	[self addSubview:loadingWheel];
	[loadingWheel startAnimating];
    
    [self performSelector:@selector(stopLoadingWheel) withObject:nil afterDelay:waitingTime];
}

-(void) setCallbackOnImageTap:(id)obj method:(SEL)m {
	NSInvocation* invo = [NSInvocation invocationWithMethodSignature:[obj methodSignatureForSelector:m]]; 
	[invo setTarget:obj];
	[invo setSelector:m];
	[invo setArgument:&self atIndex:2];
	[invo retain];
	[onImageTap release];
	onImageTap = invo;
	self.userInteractionEnabled=YES; //because it's NO in the initializer, but if we want to get a callback on tap, 
									 //then need to get touch events.
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)] autorelease];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:singleRecognizer];//给self添加一个手势监测；
    
    // 双击的手势 Recognizer
    UITapGestureRecognizer* doubleRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)] autorelease];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [self addGestureRecognizer:doubleRecognizer];
    
    // 双击手势确定监测失败才会触发单击手势的相应操作
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
}

- (void)singleTap:(UIGestureRecognizer *)recogniser {
    if (onImageTap) {
		[onImageTap invoke];
	}
}

- (void)doubleTap:(UIGestureRecognizer *)recogniser {
    if (onImageTap) {
		[onImageTap invoke];
	}
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (onImageTap) {
//		[onImageTap invoke];
	}
    else {
        [super touchesEnded:touches withEvent:event];
    }
}


@end


