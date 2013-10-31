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
    NSURL *url = [NSURL URLWithString:@"http://2013.texaslinuxfest.org/session-schedule_mobile"];
    NSString* tempString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //There is an extra "sessions(...)" around the JSON for some reason, probably needs sanitation too
    NSRange subRange = {9, [tempString length] - 10};
    NSString* sessionJSONString = [tempString substringWithRange:subRange];
    NSData *sessionJSON = [sessionJSONString dataUsingEncoding:NSUTF8StringEncoding];
    if(sessionJSON) {
        [sessionJSON writeToFile:localCachePath atomically:YES];
        NSLog(@"Session JSON cached to %@", localCachePath);
    } else {
        sessionJSON = [NSData dataWithContentsOfFile:localCachePath];
    }
    return sessionJSON;
}

//This may return an NSArray or NSDictionary, the typing probably needs refining
+(id) stripJSONObject:(NSDictionary *) dict :(NSString *) objectName {
    NSError *errorObj = [[NSError alloc] initWithCoder:nil];
    NSArray* innerArray = [dict objectForKey:objectName];
    NSData*  innerData  = [NSJSONSerialization dataWithJSONObject:innerArray options:0 error:&errorObj];
    id results = [NSJSONSerialization JSONObjectWithData:innerData options:0 error:&errorObj];
    return results;
}

+(NSMutableArray *) generateSessions {
    NSData* sessionJSON = [TXLFSession fetchSessions];
    NSError* errorObj = [[NSError alloc] initWithCoder:nil];
    NSDictionary* sessionDictionary = [NSJSONSerialization JSONObjectWithData:sessionJSON options:0 error:&errorObj];
    //Probably need some error handling or something
    //The typing for sessions propably needs to be refined
    NSArray* sessions = [TXLFSession stripJSONObject:sessionDictionary :@"nodes"];
    NSMutableArray* sessionArray = [[NSMutableArray alloc] init];
    for(id singleSession in sessions) {
        NSDictionary* sessionDict = [TXLFSession stripJSONObject:singleSession :@"node"];
        NSString* title1 = [sessionDict objectForKey:@"title"];
        TXLFSession* session = [[self alloc] initWithTitleTime:title1 :[NSDate date]]; //Current date as placeholder
        [sessionArray addObject:session];
        NSLog(@"Session: %@", [session sessionName]);
    }
    return sessionArray;
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
