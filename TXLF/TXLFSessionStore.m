//
//  TXLFSessionStore.m
//  TXLF
//
//  Created by George Nixon on 11/4/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFSessionStore.h"
#import "TXLFSession.h"


@implementation TXLFSessionStore

+(TXLFSessionStore*) sharedStore {
    static TXLFSessionStore* sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

+(id)allocWithZone:(NSZone*) zone {
    return [self sharedStore];
}

-(id)init {
    self = [super init];
    if(self)
        allSessions = [TXLFSessionStore generateSessions];
    return self;
}

-(NSArray*) allSessions {
    return allSessions;
}

-(NSArray *) sessionSlots {
    return sessionSlots;
}

+(NSData *) fetchSessions {
    //These need to be specified in a resource file or something
    NSString *localCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0] stringByAppendingPathComponent:@"session-schedule_mobile.json"];
    //NSURL *url = [NSURL URLWithString:@"http://2013.texaslinuxfest.org/session-schedule_mobile"];
    NSURL *url = [NSURL URLWithString:@"http://inni.odlenixon.com/session-schedule_mobile"];
    NSString* tempString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //There is an extra "sessions(...)" around the JSON for some reason, probably needs sanitation too
    NSRange subRange = {9, [tempString length] - 10};
    NSString* sessionJSONString = [tempString substringWithRange:subRange];
    NSData *sessionJSON = [sessionJSONString dataUsingEncoding:NSUTF8StringEncoding];
    if(sessionJSON) {
        [sessionJSON writeToFile:localCachePath atomically:YES];
        NSLog(@"Session information cached locally.");
        
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

+(NSArray *) generateSessions {
    NSData* sessionJSON = [TXLFSessionStore fetchSessions];
    NSError* errorObj = [[NSError alloc] initWithCoder:nil];
    NSDictionary* sessionDictionary = [NSJSONSerialization JSONObjectWithData:sessionJSON options:0 error:&errorObj];
    //Probably need some error handling or something
    //The typing for sessions propably needs to be refined
    NSArray* sessions = [TXLFSessionStore stripJSONObject:sessionDictionary :@"nodes"];
    NSMutableArray* sessionArray = [[NSMutableArray alloc] init];
    for(id singleSession in sessions) {
        NSDictionary* sessionDict = [TXLFSessionStore stripJSONObject:singleSession :@"node"];
        NSString* stitle = [sessionDict objectForKey:@"title"];
        NSString* sslot = [sessionDict objectForKey:@"field_session_slot"];
        NSString* snid = [sessionDict objectForKey:@"nid"];
        NSString* sroom = [sessionDict objectForKey:@"field_session_room"];
        NSString* spath = [sessionDict objectForKey:@"path"];
        NSString* sbody = [sessionDict objectForKey:@"body"];
        NSString* sexperience = [sessionDict objectForKey:@"field_experience"];
        NSString* surl = [sessionDict objectForKey:@"uri"];
        NSString* sbio = [sessionDict objectForKey:@"field_profile_bio"];
        NSString* spic = [sessionDict objectForKey:@"picture"];
        NSString* scompany = [sessionDict objectForKey:@"field_profile_company"];
        NSString* swebsite = [sessionDict objectForKey:@"field_profile_website"];
        NSString* sfname = [sessionDict objectForKey:@"field_profile_first_name"];
        NSString* slname = [sessionDict objectForKey:@"field_profile_last_name"];
        NSString* suid_1 = [sessionDict objectForKey:@"uid_1"];
        TXLFSession* session = [[TXLFSession alloc] initWithTitleTime:stitle :[self parseSessionDate:sslot]]; //Current date as placeholder
        [session setsessionPresenter:sfname :slname :scompany :stitle :@"N/A" :@"N/A" :sbio
                                            :[UIImage imageWithContentsOfFile:@"/net/inni.odlenixon.com/mnt/NI/home/george/src/TXLF/TXLF/icon_tux.png"]
                                            :[NSURL URLWithString:swebsite] :@"N/A"];
        [session setsessionLocation:nil :@"Austin Convention Center" :@"N/A" :sroom :@"N/A" :[[NSNumber alloc] init] :[[NSNumber alloc] init] :@"N/A"];
        [session setsessionAbstract:sbody];
        [session setsessionExperience:sexperience];
        [sessionArray addObject:session];
    }
    return sessionArray;
}

+(NSMutableArray *) parseSessionDate :(NSString *) dates {
    NSArray* times = [dates componentsSeparatedByString:@" - "];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    NSString* startTimeString = [[times objectAtIndex:0] stringByAppendingString:@" "];
    startTimeString  = [startTimeString stringByAppendingString:[times objectAtIndex:1]];
    NSString* endTimeString = [[times objectAtIndex:2] stringByAppendingString:@" "];
    endTimeString = [endTimeString stringByAppendingString:[times objectAtIndex:3]];
    NSDate* startTime = [dateFormat dateFromString:startTimeString];
    NSDate* endTime = [dateFormat dateFromString:endTimeString];
    
    if(!startTime || !endTime) {
        [dateFormat setDateFormat:@"EEE, MM/dd/yyyy h:mma"];
        startTime = [dateFormat dateFromString:startTimeString];
        endTime = [dateFormat dateFromString:endTimeString];
    }
    
    // These are in GMT conversion to CST will need to occur somewhere
    NSLog(@"Start Time: %@", startTime);
    NSLog(@"End Time: %@", endTime);
    //[dateFormat SetDateFormat:@""];
    NSMutableArray* start_end_time;
    // May need to isert object at Index
    [start_end_time addObject:startTime];
    [start_end_time addObject:endTime];
    return start_end_time;
}





@end
