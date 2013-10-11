//
//  HJManagedCropImageV.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJManagedCropImageV.h"

@implementation HJManagedCropImageV

@synthesize imageScaledForceType,isCropForceCenter;
@synthesize cropImage,scaledSize,cropRect;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        isCropForceCenter = NO;
        imageScaledForceType = ScaledForceAuto;//默认自动压缩
        scaledSize = CGSizeZero;
        cropRect = CGRectZero;
    }
    return self;
}

#pragma mark - drawing
- (void)updateDrawing
{
    [super updateDrawing];
}


-(void) setImage:(UIImage*)theImage {
    
    self.errorLabel.alpha = 0;
    
	if (theImage==image) {
		//when the same image is on the screen multiple times, an image that is alredy set might be set again with the same image.
		return; 
	}
	[image release];
    image = nil;
    image = theImage;
    [image retain];
    
    
    UIImage* sizeFitImage = image;
    if (scaledSize.height>0 && scaledSize.width>0) {//如果未设置压缩尺寸，不压缩
        
        if (imageScaledForceType == ScaledForceWidth) {         //按宽度压缩
            CGFloat factor = scaledSize.width/image.size.width;
            scaledSize = CGSizeMake(scaledSize.width, image.size.height*factor);
        }else if (imageScaledForceType == ScaledForceHeight) {  //按高度压缩
            CGFloat factor = scaledSize.height/image.size.height;
            scaledSize = CGSizeMake(image.size.width*factor, scaledSize.height);
        }
        
        sizeFitImage = [Utility imageWithImageSimple:image scaledToSize:scaledSize];
    }
    
    if (cropRect.size.width>0 && cropRect.size.height>0) {//如果未设置裁剪尺寸，不裁剪
        
        if (YES == isCropForceCenter) {//从图片中间进行截取，重新计算cropRect的x&&y
            CGFloat x = cropRect.origin.x;
            if (sizeFitImage.size.width > cropRect.size.width) {
                x = (sizeFitImage.size.width - cropRect.size.width) / 2;
            }else {
                x = 0;
            }
            
            CGFloat y = cropRect.origin.y;
            if (sizeFitImage.size.height > cropRect.size.height) {
                y = (sizeFitImage.size.height - cropRect.size.height) / 2;
            }else {
                y = 0;
            }
            
            cropRect = CGRectMake(x, y, cropRect.size.width, cropRect.size.height);
        }
        
        sizeFitImage = [Utility getSubImage:sizeFitImage forRect:cropRect];
    }
    
    self.cropImage = sizeFitImage;
	
	[imageView removeFromSuperview];

    self.imageView = [[[UIImageView alloc] initWithImage:cropImage] autorelease];
    
    if (url) {
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }else {
        imageView.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleToFill;
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
            self.isUseDefaultImage = NO;
        }else {
            self.isUseDefaultImage = YES;
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

@end


