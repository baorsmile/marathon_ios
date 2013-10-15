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

@interface RootViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) AddShift *addShift;
@property (nonatomic, strong) RUserLocation *myLocation;
@property (nonatomic, strong) NSTimer *getLocationTimer;

@end

@implementation RootViewController
@synthesize locationManager;
@synthesize mapView;
@synthesize addShift;
@synthesize myLocation;
@synthesize getLocationTimer;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLocation) name:kLoginSuccessNotification object:nil];
    
    self.addShift = [[AddShift alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = 10;
    
//    [self.locationManager startUpdatingLocation];
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        locationManager.headingFilter = 1;
        [locationManager startUpdatingHeading];
    }
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-34, 320, 34)];
    bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:bottomView];
    
    UIButton *reminderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reminderBtn.frame = CGRectMake(10, VIEW_HEIGHT - 50, 70, 40);
    reminderBtn.backgroundColor = [UIColor blackColor];
    [reminderBtn addTarget:self action:@selector(reminder_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reminderBtn];
    
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame = CGRectMake(VIEW_WIDTH-70-10, VIEW_HEIGHT - 50, 70, 40);
    friendsBtn.backgroundColor = [UIColor redColor];
    [friendsBtn addTarget:self action:@selector(friends_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendsBtn];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake((VIEW_WIDTH-100)/2, VIEW_HEIGHT - 100 -10, 100, 100);
    startBtn.backgroundColor = [UIColor blueColor];
    [startBtn addTarget:self action:@selector(start_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
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
    NSString *location = [PersistenceHelper dataForKey:@"location"];
    DMLog(@"%@",location);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"CoreLocation Update Index" message:[NSString stringWithFormat:@"Number:%@",location] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)friends_click:(id)sender{
    [self stopUpdateLocation];
}

- (void)start_click:(id)sender{
    [self startUpdateLocation];
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

- (void)startUpdateLocation
{
    if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
        
        if([CLLocationManager locationServicesEnabled])
        {
            [self.locationManager startUpdatingLocation];
            if (self.getLocationTimer == nil) {
                [self performSelector:@selector(requestAllLocation) withObject:nil];
                self.getLocationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestAllLocation) userInfo:nil repeats:YES];
            }
        }
    }
    else if ([CLLocationManager instancesRespondToSelector:@selector(locationServicesEnabled)]) {
        
        if ([self.locationManager performSelector:@selector(locationServicesEnabled)]) {
            [self.locationManager startUpdatingLocation];
            if (self.getLocationTimer == nil) {
                [self performSelector:@selector(requestAllLocation) withObject:nil];
                self.getLocationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestAllLocation) userInfo:nil repeats:YES];
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
    
    NSString *location = [PersistenceHelper dataForKey:@"location"];
    int locationIndex;
    if (location && [location length] > 0) {
        locationIndex = [location integerValue];
    }else{
        locationIndex = 0;
    }
    
    locationIndex++;
    
    [PersistenceHelper setData:[NSString stringWithFormat:@"%d",locationIndex] forKey:@"location"];

    DMLog(@"latitude:%f",newLocation.coordinate.latitude);
    DMLog(@"longitude:%f",newLocation.coordinate.longitude);
    
    if (isUpload) {
        return;
    }
    
    [self uploadLocation2Server:newLocation.coordinate];
    [self moveToLocation:newLocation.coordinate];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    /*
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];
    annotationView.frame = CGRectMake(0, 0, 40, 40);
    annotationView.backgroundColor = [UIColor cyanColor];
    */
    
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
