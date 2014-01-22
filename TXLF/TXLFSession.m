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

-(void)setsessionAbstract:(NSString *) abstract {
    sessionAbstract = abstract;
}

-(void)setsessionExperience:(NSString *) experience{
    sessionExperience = experience;
    
}

-(void)setsessionPresenter:(NSString *) fname
                          :(NSString *) lname
                          :(NSString *) company
                          :(NSString *) title
                          :(NSString *) email
                          :(NSString *) phone
                          :(NSString *) bio
                          :(UIImage *) pic
                          :(NSURL *) website
                          :(NSString *) notes {
    [sessionPresenter insertObject:fname   atIndex:0];
    [sessionPresenter insertObject:lname   atIndex:1];
    [sessionPresenter insertObject:company atIndex:2];
    [sessionPresenter insertObject:title   atIndex:3];
    [sessionPresenter insertObject:email   atIndex:4];
    [sessionPresenter insertObject:phone   atIndex:5];
    [sessionPresenter insertObject:bio     atIndex:6];
    [sessionPresenter insertObject:pic     atIndex:7];
    [sessionPresenter insertObject:website atIndex:8];
    [sessionPresenter insertObject:notes   atIndex:9];
}

-(void)setsessionLocation:(NSString *) address
                         :(NSString *) building
                         :(NSString *) floor
                         :(NSString *) roomNumber
                         :(NSString *) roomName
                         :(NSNumber *) gpsX //Can we just make these floats?
                         :(NSNumber *) gpsY //Can we just make these floats?
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

// This should include a field for the origonal JSON text
// in case there is some special formating that would be useful to preserve
-(void)setsessionDateTime:(NSDate *) startTime
                         :(NSDate *) endTime {
    [sessionDateTime insertObject:startTime atIndex:0];
    [sessionDateTime insertObject:endTime atIndex:1];
}

-(void)setsessionDocumentation:(NSString *) url {
    sessionDocumentation=url; //This should probably be a URL object of array of URL objects
}
    
-(NSString *)sessionName {
    return sessionName;
}

-(NSString *)sessionAbstract {
    return sessionAbstract;
}

-(NSMutableArray *)sessionPresenter {
    return sessionPresenter;
}

-(NSMutableArray *)sessionLocation {
    return sessionLocation;
}

-(NSMutableArray *)sessionDateTime {
    return sessionDateTime;
}

-(NSString *)sessionDocumentation {
    return sessionDocumentation;
}

-(id) init {
    self = [super init];
    sessionPresenter = [[NSMutableArray alloc] init];
    if(self) {
        if(!sessionName) {
            [self setsessionName:@"Test Session"];
        }
        if(!sessionPresenter) {
            [self setsessionPresenter:@"Jane" :@"Doe" :@"TXLF" :@"Tester" :@"info@texaslinuxfest.org" :@"555.555.5555" :@"bio" :[NSURL URLWithString:@"http://texaslinuxfest.org"] :nil :@"N/A"];
        }
        if(!sessionLocation) {
            [self setsessionLocation:@"500 East Cesar Chavez, Austin, TX, 78701" :@"Austin Convention Center - Building 1" :@"1" :@"101" :@"Lecture Hall" :[NSNumber numberWithFloat:85.6] :[NSNumber numberWithFloat:85.6] :@"No Notes"];
        }
        if(!sessionDateTime) {
            [self setsessionDateTime:[NSDate date] :[NSDate date]];
        }
        if(!sessionDocumentation) {
            [self setsessionDocumentation:@"http://texaslinuxfest.org"];
        }
    }
    return self;
}

-(id) initWithTitleTime:(NSString *) title :(NSMutableArray *) time {
    self = [self init];
    [self setsessionName:title];
    [self setsessionDateTime:[time objectAtIndex:0] :[time objectAtIndex:1]];
    return self;
}


@end
