//
//  RootViewController.h
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    BOOL isUpload;
    BOOL isDownload;
    
    START_STATUS status;
}

@end
