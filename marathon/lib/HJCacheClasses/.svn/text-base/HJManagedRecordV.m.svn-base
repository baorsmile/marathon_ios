//
//  HJManagedRecordV.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJManagedRecordV.h"

@interface HJManagedRecordV ()

@end


@implementation HJManagedRecordV

@synthesize oid;
@synthesize url;
@synthesize moHandler;

@synthesize callbackOnSetRecord;
@synthesize callbackOnCancel;
@synthesize loadingWheel;
@synthesize index;

@synthesize originalPath;
@synthesize from;
@synthesize isRecordCompleteLoaded;
@synthesize recordFullPath,recordData;
@synthesize waitingTime;

@synthesize timeLabel,playButton,duration,timerPlay,playImageFirst,playImageSecond,playImageThird;
@synthesize isLocalDefaultRecord;
@synthesize bgImageName;//控件背景图片名称
@synthesize labelColor;

#pragma mark - UIView lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		isCancelled = NO;
        isRecordCompleteLoaded = NO;
		url=nil;
		index = -1;
		self.userInteractionEnabled = YES;//用户交互的总开关
        UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        touch.numberOfTapsRequired = 2;
        [self addGestureRecognizer:touch];
        
        waitingTime = 60;
        
        isLocalDefaultRecord = NO;
        
        self.bgImageName = @"bar_voice.png";
        self.labelColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc {
	[self clear];
    self.originalPath = nil;
	self.callbackOnCancel=nil;
	self.loadingWheel=nil;
    
    
    self.playButton = nil;
    self.timeLabel = nil;
    self.playImageFirst = nil;
    self.playImageSecond = nil;
    self.playImageThird = nil;
    self.bgImageName = nil;
    
    if ([timerPlay isValid]) {
        [timerPlay invalidate];
    }
    self.timerPlay = nil;
    
    duration = 0;
}


-(void) clear {
	[self.moHandler removeUser:self];
	self.moHandler = nil;
	self.oid = nil;
	self.url = nil;
    
    self.recordData = nil;
    self.recordFullPath = nil;
}



-(void) changeManagedObjStateFromLoadedToReady {
	if (moHandler.moData) {
		moHandler.managedObj=[NSData dataWithData:moHandler.moData];
        self.from = RECORD_FROM_NET;
	} else if (moHandler.moReadyDataFilename) {
		moHandler.managedObj=[NSData dataWithContentsOfFile:moHandler.moReadyDataFilename];
        self.from = RECORD_FROM_FILE;
	} else {
		NSLog(@"HJManagedRecordV error in changeManagedObjStateFromLoadedToReady ?");
	}
}

-(void) managedObjFailed {
	NSLog(@"moHandlerFailed %@",moHandler);
	self.recordData = nil;
}

-(void) managedObjReady {
    isRecordCompleteLoaded = YES;
	[self setRecordData:moHandler.managedObj];
}

-(void) markCancelled {
    [loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
    
	isCancelled = YES;
    if (callbackOnCancel && [callbackOnCancel respondsToSelector:@selector(managedRecordCancelled:)]) {
        [callbackOnCancel managedRecordCancelled:self];
    }
}

-(void)setRecordData:(NSData*)theRecordData {

	if (theRecordData==recordData) {
        //初始化语音播放
        [kAppDelegate initPlayer:recordFullPath playerDelegate:self];
		//when the same record is on the screen multiple times, an image that is alredy set might be set again with the same record.
		return; 
	}
    recordData = nil;
	recordData = theRecordData;//ToDo:
    
    if (callbackOnSetRecord && [callbackOnSetRecord respondsToSelector:@selector(managedRecordSet:)]) {
        [callbackOnSetRecord managedRecordSet:self];
    }
    
    //转换格式并保存到本地
    NSString* urlStr = [self.url absoluteString];
    NSString *filename = @"";
    if (urlStr && [urlStr length]>0) {
        filename = [Utility getRecordFilename:urlStr];
        
        //write file
        NSMutableString* recordFilePath = [[NSMutableString alloc] initWithString:DOWNLOAD_FOLDER];
        [recordFilePath appendString:@"/"];
        [recordFilePath appendString:filename];
        self.recordFullPath = [NSString stringWithString:recordFilePath];
        
        
        NSMutableString* recordFilePathTemp = [[NSMutableString alloc] initWithString:DOWNLOAD_TEMP_FOLDER];
        NSError* error = nil;
        BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:recordFilePathTemp];
        if (directoryExists != YES) {
            [[NSFileManager defaultManager] createDirectoryAtPath:recordFilePathTemp withIntermediateDirectories:YES attributes:nil error:&error];
        }
        [recordFilePathTemp appendString:@"/"];
        [recordFilePathTemp appendString:filename];
        [recordData writeToFile:recordFilePathTemp atomically:YES];
        
        //change to apple format
        [Utility chageStandardFile:recordFilePathTemp toAppleFile:recordFullPath];
        [DownloadFileManager managerDownFile:recordFullPath];
        
        [[NSFileManager defaultManager] removeItemAtPath:recordFilePathTemp error:nil];
    }else if (YES == isLocalDefaultRecord) {
        self.recordFullPath = PLAYFILEPATH;
    }
    
    //初始化语音播放
    [kAppDelegate initPlayer:recordFullPath playerDelegate:self];
    
	//// NSLog(@"setImageCallback from %@ to %@",self,callbackOnSetRecord);
	[loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
	self.hidden=NO;
    
    playButton.enabled = YES;
}

- (void)setDuration:(NSUInteger)_duration {
    duration = _duration;
    
    self.backgroundColor = [UIColor clearColor];
    if (playButton == nil) {
        UIImage* playImage = [UIImage stretchableImage:bgImageName leftCap:30 topCap:20];
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        playButton.backgroundColor = [UIColor clearColor];
        [playButton setBackgroundImage:playImage forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];//开始播放
        [playButton addTarget:self action:@selector(playButtonOnClicked:) forControlEvents:UIControlEventTouchUpOutside];//开始播放
        [self addSubview:playButton];
    }
    if (recordData == nil) {
        playButton.enabled = NO;
    }else {
        playButton.enabled = YES;
    }
    [playButton setNeedsLayout];
    
    if (playImageFirst == nil) {
        UIImage* firstImage = [UIImage imageByName:@"ico_voicewave_1"];
        self.playImageFirst = [[UIImageView alloc] initWithImage:firstImage];
        playImageFirst.frame = CGRectMake(15, (playButton.frame.size.height-playImageFirst.frame.size.height)/2, firstImage.size.width, firstImage.size.height);
        playImageFirst.backgroundColor = [UIColor clearColor];
        playImageFirst.userInteractionEnabled = NO;
        [self addSubview:playImageFirst];
        playImageFirst.center = CGPointMake(playImageFirst.center.x, playButton.center.y);
    }
    [playImageFirst setNeedsLayout];
    
    if (playImageSecond == nil) {
        UIImage* secondImage = [UIImage imageByName:@"ico_voicewave_2"];
        self.playImageSecond = [[UIImageView alloc] initWithImage:secondImage];
        playImageSecond.frame = playImageFirst.frame;
        playImageSecond.backgroundColor = [UIColor clearColor];
        playImageSecond.userInteractionEnabled = NO;
        [self addSubview:playImageSecond];
    }
    [playImageSecond setNeedsLayout];
    
    if (playImageThird == nil) {
        UIImage* thirdImage = [UIImage imageByName:@"ico_voicewave_3"];
        self.playImageThird = [[UIImageView alloc] initWithImage:thirdImage];
        playImageThird.frame = playImageFirst.frame;
        playImageThird.backgroundColor = [UIColor clearColor];
        playImageThird.userInteractionEnabled = NO;
        [self addSubview:playImageThird];
    }
    [playImageThird setNeedsLayout];
    
    if (timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
        timeLabel.font = [UIFont boldSystemFontOfSize:14];
        timeLabel.textColor = labelColor;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.numberOfLines = 1;
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.lineBreakMode = UILineBreakModeTailTruncation;
        timeLabel.userInteractionEnabled = NO;
        [self addSubview:timeLabel];
        timeLabel.center = CGPointMake(playButton.frame.origin.x+playButton.frame.size.width-timeLabel.frame.size.width/2-10, playButton.center.y);
    }
    timeLabel.text = [NSString stringWithFormat:@"%02d'",duration];
	[timeLabel setNeedsLayout];
    
    loadingWheel.center = playButton.center;
    
    
	[self setNeedsLayout];
}

- (void)playButtonOnClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventStopGAvAudioPlayer object:nil];
    
    if (kAppDelegate.gAvAudioPlayer.playing) {
        [kAppDelegate.gAvAudioPlayer stop];
    }
    
    if (isPlaying) {
		isPlaying = NO;
		
		[self stopAudio];
		[timerPlay invalidate];
        self.timerPlay = nil;
	}
	else {
		isPlaying = YES;
        
        if (YES == isLocalDefaultRecord) {
            [kAppDelegate initPlayer:recordFullPath playerDelegate:self];
        }
        
		[self playAudio];
	}
}


- (void)playAudio {
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudio) name:kEventStopGAvAudioPlayer object:nil];
    
    if ([timerPlay isValid]) {
        [timerPlay invalidate];
        self.timerPlay = nil;
    }
    
//	if (!kAppDelegate.gAvAudioPlayer)
    {
	    [kAppDelegate initPlayer:recordFullPath playerDelegate:self];
	}
	
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    
	timerCount = 0;
	self.timerPlay = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updatePlayTimer) userInfo:nil repeats:YES];
	BOOL result = [kAppDelegate.gAvAudioPlayer play];
    if (NO == result) {
        [self stopAudio];
    }
}

- (void) stopAudio {
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([timerPlay isValid]) {
        [timerPlay invalidate];
        self.timerPlay = nil;
    }
    
	if (kAppDelegate.gAvAudioPlayer) {
		[kAppDelegate.gAvAudioPlayer stop];
		kAppDelegate.gAvAudioPlayer.currentTime = 0;
	}
    
    playImageFirst.alpha = 1;
    playImageSecond.alpha = 1;
    playImageThird.alpha = 1;
    
    timeLabel.text = [NSString stringWithFormat:@"%02d'",duration];
}

- (void) updatePlayTimer {
	
    if (timerCount >= duration) {
        [self stopAudio];
        
        playImageFirst.alpha = 1;
        playImageSecond.alpha = 1;
        playImageThird.alpha = 1;
        
        timeLabel.text = [NSString stringWithFormat:@"%02d'",duration];
        return;
    }
    
    NSInteger indexForImage = timerCount%4;
    if (indexForImage == 0) {
        playImageFirst.alpha = 1;
        playImageSecond.alpha = 0;
        playImageThird.alpha = 0;
    }else if (indexForImage == 1) {
        playImageFirst.alpha = 1;
        playImageSecond.alpha = 1;
        playImageThird.alpha = 0;
    }else if (indexForImage == 2) {
        playImageFirst.alpha = 1;
        playImageSecond.alpha = 1;
        playImageThird.alpha = 1;
    }else if (indexForImage == 3) {
        playImageFirst.alpha = 0;
        playImageSecond.alpha = 0;
        playImageThird.alpha = 0;
    }
    
	timerCount++;
    timeLabel.text = [NSString stringWithFormat:@"%02d'",timerCount];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([timerPlay isValid]) {
        [timerPlay invalidate];
        self.timerPlay = nil;
    }
    
	timerCount=0;
	isPlaying = NO;
    
    playImageFirst.alpha = 1;
    playImageSecond.alpha = 1;
    playImageThird.alpha = 1;
    
    timeLabel.text = [NSString stringWithFormat:@"%02d'",duration];
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
	self.loadingWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingWheel.center = self.center;
    loadingWheel.frame = CGRectMake((self.frame.size.width-self.loadingWheel.frame.size.width)/2, (self.frame.size.height-self.loadingWheel.frame.size.height)/2, self.loadingWheel.frame.size.width, self.loadingWheel.frame.size.height);
	loadingWheel.hidesWhenStopped=YES;
	[self addSubview:loadingWheel];
	[loadingWheel startAnimating];
    
    [self performSelector:@selector(stopLoadingWheel) withObject:nil afterDelay:waitingTime];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer{
    [self becomeFirstResponder];
    [self playButtonOnClicked:playButton];
}

@end


