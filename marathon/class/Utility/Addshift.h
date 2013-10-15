//
//  addshift.h
//  AccuMap
//
//  Created by Acamar on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define LAT 0
#define LON 1

#define ACAMAR_FALSE 0
#define ACAMAR_TRUE 1

/*
typedef struct
{
	double lat;
	double lon;
}GPoint;
*/
@interface AddShift : NSObject {
	int EarthRadius;
	double lon_step;
	double lat_step;
	double uLatStart;
	double uLatEnd;
	double uLonStart;
	double uLonEnd;
	double uMaxLatX;
	double uMaxLonX;
	double uMaxGeoX;
}

- (GPoint) fakeLocation:(GPoint) realP;
- (double) convLatMeterstoDegrees:(double)meters;
- (double) convLongMeterstoDegrees:(double)meters  withLat:(double)latitude;
- (GPoint) fakeToReal:(GPoint) fakeP;
- (GPoint) realToFake:(GPoint) ori;


- (id)init;
- (void)initVals;
- (int)isValidRange:(GPoint)loc;
- (BOOL)isValidRange:(double)lat withLon:(double)lon;
- (GPoint)getOffset:(GPoint)loc;
- (GPoint)fakeOffset: (GPoint) loc;

@end
