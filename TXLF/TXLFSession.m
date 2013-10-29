//
//  TXLFSession.m
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFSession.h"

@implementation TXLFSession

// !! These session data-structures need to be updated to be a super-set of ones in the JSON feed

+(NSData *) fetchSessions {
    //These need to be specified in a resource file or something
    NSString *localCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0] stringByAppendingPathComponent:@"session-schedule_mobile.json"];
    //NSURL *url = [NSURL URLWithString:@"http://2013.texaslinuxfest.org/session-schedule_mobile"]; //This URL contains enclosing 'sessions()' which causes issues for un-serialization below; for now, we just use a local network copy with the enclosing parens removed
    NSURL *url = [NSURL URLWithString:@"http://inni.odlenixon.com/session-schedule_mobile"];
    NSData *sessionJSON = [NSData dataWithContentsOfURL:url];
    if(sessionJSON) {
        [sessionJSON writeToFile:localCachePath atomically:YES];
        NSLog(@"Session JSON cached to %@", localCachePath);
    } else {
        sessionJSON = [NSData dataWithContentsOfFile:localCachePath];
    }
    return sessionJSON;
}

+(void) generateSessions {
    NSData* sessionJSON = [TXLFSession fetchSessions];
    NSError *errorObj = [[NSError alloc] initWithCoder:nil];
    NSDictionary* sessionDictionary = [NSJSONSerialization JSONObjectWithData:sessionJSON options:0 error:&errorObj];
    //NSLog(@"This is the error: %@", errorObj); //Probably need some error handling/sanitation or something
    NSLog(@"Session JSON converted to dictionary data");
    
    NSArray* sessionKeys = [sessionDictionary allKeys];
    NSArray* sessionValues = [sessionDictionary allValues];
    NSLog(@"Here are the keys: %@", sessionKeys);
    NSLog(@"Here are the values: %@", sessionValues);
                              
    
    
}

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

-(void)setsessionDateTime:(NSDate *) dateTime {
    sessionDateTime=dateTime;
}

-(void)setsessionDocumentation:(NSString *) url {
    sessionDocumentation=url; //This should probably be a URL object of array of URL objects
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
            [self setsessionLocation:@"500 East Cesar Chavez, Austin, TX, 78701" :@"Austin Convention Center - Building 1" :@"1" :@"101" :@"Lecture Hall" :[NSNumber numberWithFloat:85.6] :[NSNumber numberWithFloat:85.6] :@"No Notes"];
        }
        if(!sessionDateTime) {
            [self setsessionDateTime:[NSDate date]];
        }
        if(!sessionDocumentation) {
            [self setsessionDocumentation:@"http://texaslinuxfest.org"];
        }
    }
    return self;
}

-(id) initWithTitleTime:(NSString *) title :(NSDate *) time {
    self = [self init];
    [self setsessionName:title];
    [self setsessionDateTime:time];
    return self;
}


@end
