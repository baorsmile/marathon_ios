//
//  RootViewController.m
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RootViewController.h"
#import "Addshift.h"
#import "RUserLocation.h"
#import "FriendsViewController.h"
#import "ReminderViewController.h"

@interface RootViewController (){
    int seconds;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) AddShift *addShift;
@property (nonatomic, strong) RUserLocation *myLocation;
@property (nonatomic, strong) NSTimer *getLocationTimer;
@property (nonatomic, strong) NSDate *downDate;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, strong) FriendsViewController *friendsVC;
@property (nonatomic, strong) ReminderViewController *reminderVC;

@end

@implementation RootViewController
@synthesize locationManager;
@synthesize mapView;
@synthesize addShift;
@synthesize myLocation;
@synthesize getLocationTimer;
@synthesize downDate;
@synthesize statusLabel;
@synthesize countTimer;
@synthesize friendsVC,reminderVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    isUpload = NO;
    isDownload = NO;
    status = kStartStatusStop;
    seconds = 0;
    
    [[MMProgressHUD sharedHUD] setOverlayMode:MMProgressHUDWindowOverlayModeGradient];
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLocation) name:kLoginSuccessNotification object:nil];
    
    self.addShift = [[AddShift alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = 10;
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    self.friendsVC = [[FriendsViewController alloc] init];
    friendsVC.view.frame = CGRectMake(320, 0, 190, VIEW_HEIGHT-34);
    [self.view addSubview:friendsVC.view];
    
    self.reminderVC = [[ReminderViewController alloc] init];
    reminderVC.view.frame = CGRectMake(-190, 0, 190, VIEW_HEIGHT-34);
    [self.view addSubview:reminderVC.view];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-34, 320, 34)];
    bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:bottomView];
    
    UIButton *reminderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reminderBtn.frame = CGRectMake(15, VIEW_HEIGHT-37-5, 45, 37);
    [reminderBtn setBackgroundImage:[UIImage imageNamed:@"reminder"] forState:UIControlStateNormal];
    [reminderBtn addTarget:self action:@selector(reminder_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reminderBtn];
    
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame = CGRectMake(VIEW_WIDTH-49-15, VIEW_HEIGHT-37-5, 49, 37);
    [friendsBtn setBackgroundImage:[UIImage imageNamed:@"friends"] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(friends_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendsBtn];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake((VIEW_WIDTH-60)/2, VIEW_HEIGHT-60-5, 60, 60);
    [startBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start_click_down:) forControlEvents:UIControlEventTouchDown];
    [startBtn addTarget:self action:@selector(start_click_up:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = HEI_(16);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"Start";
    statusLabel.textColor = [UIColor whiteColor];
    [startBtn addSubview:statusLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)requestLocation{
    DMLog(@"login success");
}

- (void)reminder_click:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.reminderVC.view.frame = CGRectMake(0, 0, 190, VIEW_HEIGHT-34);
    }];
}

- (void)friends_click:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.friendsVC.view.frame = CGRectMake(320-190, 0, 190, VIEW_HEIGHT-34);
    }];
}

- (void)start_click_down:(id)sender{
    self.downDate = [NSDate date];
}

- (void)start_click_up:(id)sender{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSinceDate:downDate];
    if (status == kStartStatusStop) {
        [self startUpdateLocation];
        [self startTimer];
    }else if (status == kStartStatusStart){
        if (time<1.5) {
            //pause
            [self stopUpdateLocation];
            [self pauseTimer];
        }else{
            [self stopUpdateLocation];
            [self stopTimer];
        }
    }else{
        if (time<1.5) {
            //start
            [self startUpdateLocation];
            [self startTimer];
        }else{
            [self stopUpdateLocation];
            [self stopTimer];
        }
    }
}

- (NSString *)getAvatarName:(NSString *)code{
    NSString *resultName;
    
    if ([code isEqualToString:@"123456"]) {
        resultName = @"AVATAS1";
    }else if ([code isEqualToString:@"12345"]){
        resultName = @"AVATAS2";
    }else if ([code isEqualToString:@"1234"]){
        resultName = @"AVATAS3";
    }else if ([code isEqualToString:@"123"]){
        resultName = @"AVATAS4";
    }else if ([code isEqualToString:@"12"]){
        resultName = @"AVATAS5";
    }
    
    return resultName;
}

- (void)showTime{
    seconds++;
    NSString *timeString=[NSString stringWithFormat:@"%02d:%02d",seconds/60,seconds%60];
    statusLabel.text = timeString;
}

- (void)startTimer{
    status = kStartStatusStart;

    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    [countTimer fire];

    [MMProgressHUD showWithTitle:nil status:@"开始计时" image:[UIImage imageNamed:@"test"]];
    [MMProgressHUD dismissAfterDelay:1.0];
}

- (void)pauseTimer{
    status = kStartStatusPause;
    
    [countTimer invalidate];
    self.countTimer = nil;
    [MMProgressHUD showWithTitle:nil status:@"暂停计时" image:[UIImage imageNamed:@"test"]];
    [MMProgressHUD dismissAfterDelay:1.0];
}

- (void)stopTimer{
    status = kStartStatusStop;
    seconds = 0;
    
    [countTimer invalidate];
    self.countTimer = nil;
    
    [MMProgressHUD showWithTitle:nil status:@"停止计时" image:[UIImage imageNamed:@"test"]];
    [MMProgressHUD dismissAfterDelay:1.0];
    
    statusLabel.text = @"Start";
}

#pragma mark - About Location Method
- (void)startUpdateLocation
{
    if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
        
        if([CLLocationManager locationServicesEnabled])
        {
            [self.locationManager startUpdatingLocation];
            if (self.getLocationTimer == nil) {
                self.getLocationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestAllLocation) userInfo:nil repeats:YES];
                [getLocationTimer fire];
            }
        }
    }
    else if ([CLLocationManager instancesRespondToSelector:@selector(locationServicesEnabled)]) {
        
        if ([self.locationManager performSelector:@selector(locationServicesEnabled)]) {
            [self.locationManager startUpdatingLocation];
            if (self.getLocationTimer == nil) {
                self.getLocationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestAllLocation) userInfo:nil repeats:YES];
                [getLocationTimer fire];
            }
        }
    }
}

- (void)stopUpdateLocation
{
    if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
        if([CLLocationManager locationServicesEnabled])
        {
            [self.locationManager stopUpdatingLocation];
            if (self.getLocationTimer) {
                [getLocationTimer invalidate];
                self.getLocationTimer = nil;
            }
        }
    }
    else if ([CLLocationManager instancesRespondToSelector:@selector(locationServicesEnabled)]){
        
        if ([self.locationManager performSelector:@selector(locationServicesEnabled)]) {
            [self.locationManager stopUpdatingLocation];
            if (self.getLocationTimer) {
                [getLocationTimer invalidate];
                self.getLocationTimer = nil;
            }
        }
    }
}

- (void)uploadLocation2Server:(CLLocationCoordinate2D)coordinate{
    if (isUpload) {
        return;
    }
    
    isUpload = YES;
    
    NSString *uploadStr = kUpLoadLocation(coordinate.latitude, coordinate.longitude);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:uploadStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        isUpload = NO;
        
        if (responseObject == nil || [[responseObject objectForKey:@"result"] intValue] == 0 ) {
            // 操作错误
            
            return;
        }
        
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        if ([[dataDic objectForKey:@"success"] isEqualToString:@"1"]) {

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 网络连接失败
        isUpload = NO;
    }];
}

- (void)requestAllLocation{
    if (isDownload) {
        return;
    }
    
    isDownload = YES;
    
    NSString *locationStr = kGetLocation;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:locationStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        isDownload = NO;
        
        if (responseObject == nil || [[responseObject objectForKey:@"result"] intValue] == 0 ) {
            // 操作错误
            
            return;
        }
        
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        if (dataArray && [dataArray count] > 0) {
            [self addPlayerAnnotations:dataArray];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 网络连接失败
        isDownload = NO;
    }];
}

- (void)moveToLocation:(CLLocationCoordinate2D)coordinate{
    GPoint realLatLon = {coordinate.latitude, coordinate.longitude};
    
    GPoint fakeLatLon = [addShift realToFake:realLatLon];
    
    CLLocationCoordinate2D fakeCoordinate = CLLocationCoordinate2DMake(fakeLatLon.lat, fakeLatLon.lon);

    MKCoordinateRegion defaultRegion;
	
    defaultRegion.center.latitude = fakeLatLon.lat;
    defaultRegion.center.longitude = fakeLatLon.lon;
    
    defaultRegion.span.latitudeDelta = kDefaultLatitudeDelta;
    defaultRegion.span.longitudeDelta = kDefaultLatitudeDelta;
    
    [mapView setRegion:defaultRegion animated:YES];
    
    [mapView removeAnnotation:myLocation];
    
    self.myLocation = [[RUserLocation alloc] init];
    myLocation.coordinate = fakeCoordinate;
    myLocation.userInfo = @{@"invite_code": kCode};
    
    [mapView addAnnotation:myLocation];
}

- (void)addPlayerAnnotations:(NSArray *)playerArray{
    [self removePlayerAnnotations];
    for (NSDictionary *item in playerArray) {
        if ([[item objectForKey:@"invite_code"] isEqualToString:kCode]) {
            continue;
        }else{
            GPoint realLatLon = {[[item objectForKey:@"lat"] doubleValue], [[item objectForKey:@"lon"] doubleValue]};
            GPoint fakeLatLon = [addShift realToFake:realLatLon];
            CLLocationCoordinate2D fakeCoordinate = CLLocationCoordinate2DMake(fakeLatLon.lat, fakeLatLon.lon);
            RUserLocation *playLocation = [[RUserLocation alloc] init];
            playLocation.coordinate = fakeCoordinate;
            playLocation.userInfo = item;
            
            [mapView addAnnotation:playLocation];
        }
    }
}

- (void)removePlayerAnnotations {
    NSMutableArray *delArray = [NSMutableArray array];
    for (id annotation in [mapView annotations]) {
        if (annotation == myLocation) {
            continue;
        }else{
            [delArray addObject:annotation];
        }
    }
    [mapView removeAnnotations:delArray];
}

#pragma mark - CLLocationManagerDelegate
//
//#ifdef __IPHONE_7_0
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    
//}
//#else
//
//#endif

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    DMLog(@"latitude:%f",newLocation.coordinate.latitude);
    DMLog(@"longitude:%f",newLocation.coordinate.longitude);
    
    [self uploadLocation2Server:newLocation.coordinate];
    [self moveToLocation:newLocation.coordinate];

}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation == myLocation) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myLocation"];
        annotationView.frame = CGRectMake(0, 0, 36, 48);
        annotationView.backgroundColor = [UIColor clearColor];
        NSString *code = [myLocation.userInfo objectForKey:@"invite_code"];
        annotationView.image = [UIImage imageNamed:[self getAvatarName:code]];
        annotationView.centerOffset = CGPointMake(0, -24);
        return annotationView;
    }else{
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"playLocation"];
        annotationView.frame = CGRectMake(0, 0, 36, 48);
        annotationView.backgroundColor = [UIColor clearColor];
        NSString *code = [((RUserLocation*)annotation).userInfo objectForKey:@"invite_code"];
        annotationView.image = [UIImage imageNamed:[self getAvatarName:code]];
        annotationView.centerOffset = CGPointMake(0, -24);
        return annotationView;
    }
    
    return nil;
}

@end
