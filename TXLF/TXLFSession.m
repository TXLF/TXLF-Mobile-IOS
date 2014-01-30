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
//
// Need to account for multiple start/end days for events spread across multiple days
-(void)setsessionDateTime:(NSDate *) startDate
                         :(NSDate *) startTime
                         :(NSDate *) endDate
                         :(NSDate *) endTime
                         :(NSString *) DoW
                         :(NSNumber *) slot {
        // Need to make sure ordering is preserved or turn into dictionary
        sessionDateTime = [NSArray arrayWithObjects:startDate,startTime,endDate,endTime,DoW,slot,nil];
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

-(NSArray *)sessionDateTime {
    return sessionDateTime;
}

-(NSString *)sessionDocumentation {
    return sessionDocumentation;
}

-(id) init {
    self = [super init];
    sessionPresenter = [[NSMutableArray alloc] init];
    sessionLocation = [[NSMutableArray alloc] init];
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
            [self setsessionDateTime:[NSDate date] :[NSDate date] :[NSDate date] :[NSDate date] :@"SAT" :[NSNumber numberWithInteger:0]];
        }
        if(!sessionDocumentation) {
            [self setsessionDocumentation:@"http://texaslinuxfest.org"];
        }
    }
    return self;
}

-(id) initWithTitleTime:(NSString *) title :(NSArray *) time {
    self = [self init];
    [self setsessionName:title];
    NSDate* time0 = [NSDate date];
    NSDate* time1 = [NSDate date];
    NSDate* time2 = [NSDate date];
    NSDate* time3 = [NSDate date];
    NSString* time4 = @"SAT";
    NSNumber* time5 = 0;
    
    NSUInteger count = [time count];
    if (count < 1 || ! (time0 = [time objectAtIndex:0])) {
        time0 = [NSDate date];
    }
    if (count < 2 || ! (time1 = [time objectAtIndex:1])) {
        time1 = [NSDate date];
    }
    if (count < 3 || ! (time2 = [time objectAtIndex:2])) {
        time2 = [NSDate date];
    }
    if (count < 4 || ! (time3 = [time objectAtIndex:3])) {
        time3 = [NSDate date];
    }
    if (count < 5 || ! (time4 = [time objectAtIndex:4])) {
        time4 = @"SAT";
    }
    if (count < 6 || ! (time5 = [time objectAtIndex:5])) {
        time5 = [NSNumber numberWithInteger:0];
    }
    [self setsessionDateTime:time0 :time1 :time2 :time3 :time4 :time5];
    return self;
}


@end
