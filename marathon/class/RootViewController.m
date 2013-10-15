//
//  RootViewController.m
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RootViewController.h"
#import "Addshift.h"

@interface RootViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) AddShift *addShift;

@end

@implementation RootViewController
@synthesize locationManager;
@synthesize mapView;

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
    
}

- (void)start_click:(id)sender{
    [self.locationManager startUpdatingLocation];
}

- (void)moveToLocation:(CLLocationCoordinate2D)coordinate{
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000);
    region.span.latitudeDelta /= 3;
    region.span.longitudeDelta /= 3;
    [mapView setRegion:region animated:YES];
    
    MKUserLocation *annotation = [[MKUserLocation alloc] init];
    annotation.coordinate = coordinate;
    
    [mapView addAnnotation:annotation];
    
//    MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
//    annotationView.
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
    
    [self moveToLocation:newLocation.coordinate];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];
    annotationView.frame = CGRectMake(0, 0, 40, 40);
    annotationView.backgroundColor = [UIColor cyanColor];
    
    return annotationView;
}

@end
