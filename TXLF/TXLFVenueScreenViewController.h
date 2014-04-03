//
//  TXLFVenueScreenViewController.h
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TXLFVenueScreenViewController : UIViewController <CLLocationManagerDelegate> {
    IBOutlet MKMapView *map;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D venueLocation;
    CLLocationCoordinate2D secondPark;
    CLLocationCoordinate2D fifthPark;
}

@end
