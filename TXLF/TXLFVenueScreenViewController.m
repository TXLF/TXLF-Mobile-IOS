//
//  TXLFVenueScreenViewController.m
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFVenueScreenViewController.h"
#import "TXLFSession.h"

@implementation TXLFVenueScreenViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        venueLocation = CLLocationCoordinate2DMake(30.26384,-97.73958);
        secondPark = CLLocationCoordinate2DMake(30.263338, -97.742437);
        fifthPark = CLLocationCoordinate2DMake(30.264939, -97.737283);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateRegion region = MKCoordinateRegionMake(venueLocation, MKCoordinateSpanMake(0.01, 0.01));
    [map setRegion:region animated:YES];
    MKPointAnnotation *conventionCenter = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *secondParkPoint = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *fifthParkPoint = [[MKPointAnnotation alloc] init];
    conventionCenter.coordinate = venueLocation;
    conventionCenter.title = @"Convention Center";
    secondParkPoint.coordinate = secondPark;
    secondParkPoint.title = @"Park";
    fifthParkPoint.coordinate = fifthPark;
    fifthParkPoint.title = @"Park";
    
    [map addAnnotation:conventionCenter];
    [map addAnnotation:secondParkPoint];
    [map addAnnotation:fifthParkPoint];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
