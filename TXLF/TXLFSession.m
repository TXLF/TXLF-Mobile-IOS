//
//  TXLFSession.m
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFSession.h"

@implementation TXLFSession

-(void)setsessionName:(NSString *)name {
    sessionName=name;
}

-(void)setsessionPresenter:(NSString *) fname
                          :(NSString *) lname
                          :(NSString *) company
                          :(NSString *) title
                          :(NSString *) email
                          :(NSString *) phone
                          :(NSString *) notes {
    [sessionPresenter insertObject:fname   atIndex:0];
    [sessionPresenter insertObject:lname   atIndex:1];
    [sessionPresenter insertObject:company atIndex:2];
    [sessionPresenter insertObject:title   atIndex:3];
    [sessionPresenter insertObject:email   atIndex:4];
    [sessionPresenter insertObject:phone   atIndex:5];
    [sessionPresenter insertObject:notes   atIndex:6];
}

-(void)setsessionLocation:(NSString *) address
                         :(NSString *) building
                         :(NSString *) floor
                         :(NSString *) roomNumber
                         :(NSString *) roomName
                         :(NSNumber *) gpsX
                         :(NSNumber *) gpsY
                         :(NSString *) notes {
    [sessionLocation insertObject:address atIndex:0];
    [sessionLocation insertObject:building atIndex:1];
    [sessionLocation insertObject:floor atIndex:2];
    [sessionLocation insertObject:roomNumber atIndex:3];
    [sessionLocation insertObject:roomName atIndex:4];
    [sessionLocation insertObject:gpsX atIndex:5];
    [sessionLocation insertObject:gpsY atIndex:6];
    [sessionLocation insertObject:notes atIndex:7];
    
}

-(void)setsessionDateTime:(NSDate *) dateTime {
    sessionDateTime=dateTime;
}

-(void)setsessionDocumentation:(NSString *) url {
    sessionDocumentation=url;
}
    
-(NSString *)sessionName {
    return sessionName;
}

-(NSMutableArray *)sessionPresenter {
    return sessionPresenter;
}

-(NSMutableArray *)sessionLocation {
    return sessionLocation;
}

-(NSDate *)sessionDateTime {
    return sessionDateTime;
}

-(NSString *)sessionDocumentation {
    return sessionDocumentation;
}

-(id) init {
    self = [super init];
    if(self) {
        if(!sessionName) {
            [self setsessionName:@"Test Session"];
        }
        if(!sessionPresenter) {
            [self setsessionPresenter:@"Jane" :@"Doe" :@"TXLF" :@"Tester" :@"info@texaslinuxfest.org" :@"555.555.5555" :@"N/A"];
        }
        if(!sessionLocation) {
            [self setsessionLocation:@"" :<#(NSString *)#> :<#(NSString *)#> :<#(NSString *)#> :<#(NSString *)#> :<#(NSNumber *)#> :<#(NSNumber *)#> :<#(NSString *)#>]
        }
        
    }
    return self;
}


@end
