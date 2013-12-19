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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateRegion region = MKCoordinateRegionMake(venueLocation, MKCoordinateSpanMake(0.01, 0.01));
    [map setRegion:region animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
