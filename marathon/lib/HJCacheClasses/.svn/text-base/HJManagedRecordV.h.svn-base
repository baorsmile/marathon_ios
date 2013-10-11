//
//  HJManagedRecordV.h
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

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "Utility.h"

@class HJManagedRecordV;

@protocol HJManagedRecordVDelegate
@optional
	-(void) managedRecordSet:(HJManagedRecordV*)mi;
	-(void) managedRecordCancelled:(HJManagedRecordV*)mi;
@end

typedef enum {
    RECORD_FROM_NET = 0,
    RECORD_FROM_FILE
} RECORD_FROM;

@interface HJManagedRecordV : UIView <HJMOUser, AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
	
	id oid;
	NSURL* url;
    NSString *originalPath;
	HJMOHandler* moHandler;
	
    NSData *recordData;
	id callbackOnSetRecord;
	id callbackOnCancel;
	BOOL isCancelled;
	UIActivityIndicatorView* loadingWheel;
	int index; // optional; may be used to assign an ordering to a image.
    RECORD_FROM from;
    
    NSInteger waitingTime;
    
	NSTimer *timerPlay;
	NSUInteger timerCount;
	NSUInteger duration;
	BOOL isPlaying;
}

@property (nonatomic,assign) BOOL isRecordCompleteLoaded;
@property (nonatomic, assign) RECORD_FROM from;
@property int index;
@property (nonatomic, copy)   NSString *originalPath;

@property (nonatomic, retain) NSData *recordData;
@property (nonatomic, retain) NSString *recordFullPath;
@property (nonatomic, retain) UIActivityIndicatorView* loadingWheel;
@property (nonatomic, retain) id <HJManagedRecordVDelegate> callbackOnCancel;
@property (nonatomic, retain) id <HJManagedRecordVDelegate> callbackOnSetRecord;

@property (nonatomic, assign) NSInteger waitingTime;

@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, retain) NSTimer *timerPlay;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UIImageView *playImageFirst;
@property (nonatomic, retain) UIImageView *playImageSecond;
@property (nonatomic, retain) UIImageView *playImageThird;

@property (nonatomic, retain) NSString* bgImageName;
@property (nonatomic, retain) UIColor* labelColor;

@property (nonatomic, assign) BOOL isLocalDefaultRecord;

-(void) clear;
-(void) markCancelled;


-(void) showLoadingWheel;
-(void) stopLoadingWheel;

- (void) stopAudio;
- (void) playAudio;

@end





