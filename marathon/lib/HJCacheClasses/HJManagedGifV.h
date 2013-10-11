//
//  HJManagedGifV.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>
#import "HJMOUser.h"
#import "HJMOHandler.h"
#import <UIKit/UIKit.h>

#import "SCGIFImageView.h"

#import "Utility.h"

@class HJManagedGifV;

@protocol HJManagedGifVDelegate
@optional
	-(void) managedGifSet:(HJManagedGifV*)mi;
	-(void) managedGifCancelled:(HJManagedGifV*)mi;
@end

typedef enum {
    GIF_FROM_NET = 0,
    GIF_FROM_FILE
} GIF_FROM;

@interface HJManagedGifV : SCGIFImageView <HJMOUser> {
	
	id oid;
	NSURL* url;
    NSString *originalPath;
	HJMOHandler* moHandler;
	
    NSData *gifData;
	id callbackOnSetGif;
	id callbackOnCancel;
	BOOL isCancelled;
	UIActivityIndicatorView* loadingWheel;
	int index; // optional; may be used to assign an ordering to a image.
    GIF_FROM from;
    
    NSInteger waitingTime;
    
}

@property (nonatomic,assign) BOOL isGifCompleteLoaded;
@property (nonatomic, assign) GIF_FROM from;
@property int index;
@property (nonatomic, copy)   NSString *originalPath;

@property (nonatomic, retain) NSData *gifData;
@property (nonatomic, retain) NSString *gifFullPath;
@property (nonatomic, retain) UIActivityIndicatorView* loadingWheel;
@property (nonatomic, retain) id <HJManagedGifVDelegate> callbackOnCancel;
@property (nonatomic, assign) id <HJManagedGifVDelegate> callbackOnSetGif;

@property (nonatomic, assign) NSInteger waitingTime;

@property (nonatomic, assign) BOOL isLocalDefaultGif;

-(void) clear;
-(void) markCancelled;

-(void) showLoadingWheel;
-(void) stopLoadingWheel;


@end





