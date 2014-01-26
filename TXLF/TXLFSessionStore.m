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
        [TXLFSessionStore allSessions:NO];
    return self;
}

+(NSArray*) allSessions :(BOOL) regen {
    static NSMutableArray* allSessions = nil;
    // regen -> Refresh sesssions without having to restart the app
    if(!allSessions || regen) {
        allSessions = [self generateSessions];
    }
    return allSessions;
}

//+(NSArray *) sessionSlots {
//    return sessionSlots;
//}

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
        NSDictionary* sessionDict = [self stripJSONObject:singleSession :@"node"];
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
        NSLog(@"%@", session.sessionName);
        //NSLog(@"%@", [[session sessionDateTime] objectAtIndex:5]);
    }
    return sessionArray;
}

+(NSArray *) parseSessionDate :(NSString *) dates {
    // May need to be updated handle sessions that spam multiple days
    // Also breaking up the start/end times into dates and times is probably pointless
    // when using NSDate and the storage mechanism
    // so this need lots of cleanup
    NSArray* times = [dates componentsSeparatedByString:@" - "];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    NSDate* startDate = [NSDate date];
    NSDate* startTime = [NSDate date];
    NSDate* endDate = [NSDate date];
    NSDate* endTime = [NSDate date];
    // Needs to be implemented
    NSString* DoW = @"SAT";
    NSNumber* slot = [NSNumber numberWithInteger:0];
    
    if(times.count > 0) {
        startDate = [dateFormat dateFromString:[times objectAtIndex:0]];
    }
    if(times.count > 1) {
        startTime = [dateFormat dateFromString:[times objectAtIndex:1]];
    }
    if(times.count > 2) {
        endDate = [dateFormat dateFromString:[times objectAtIndex:2]];
    }
    if(times.count > 3) {
        endTime = [dateFormat dateFromString:[times objectAtIndex:3]];
    }
    
    NSString* startTimeString = [[times objectAtIndex:0] stringByAppendingString:@" "];
    startTimeString  = [startTimeString stringByAppendingString:[times objectAtIndex:1]];
    NSString* endTimeString = [[times objectAtIndex:2] stringByAppendingString:@" "];
    endTimeString = [endTimeString stringByAppendingString:[times objectAtIndex:3]];
    startTime = [dateFormat dateFromString:startTimeString];
    endTime = [dateFormat dateFromString:endTimeString];
    
    if(!startDate || !startTime || !endDate || !endTime) {
        [dateFormat setDateFormat:@"EEE, MM/dd/yyyy h:mma"];
        startTime = [dateFormat dateFromString:startTimeString];
        endTime = [dateFormat dateFromString:endTimeString];
        [dateFormat setDateFormat:@"EEE, MM/dd/yyyy"];
        startDate = [dateFormat dateFromString:[times objectAtIndex:0]];
        endDate = [dateFormat dateFromString:[times objectAtIndex:2]];
       
        //[dateFormat setDateFormat:@"h:mma"];
        //startTime = [dateFormat dateFromString:[times objectAtIndex:1]];
        //endTime = [dateFormat dateFromString:[times objectAtIndex:3]];
    }
    
    // These are in GMT conversion to CST will need to occur somewhere
    //[dateFormat SetDateFormat:@""];
    //NSMutableArray* start_end_time;
    // May need to isert object at Index
    //[start_end_time insertObject:startTime atIndex:0];
    //[start_end_time insertObject:endTime atIndex:1];
    //NSLog(@"S date:  %@ S time: %@", startDate, startTime);
    // These need to be specified in a resource file and/or generated from the JSON data available
    NSDate* slot1 = [NSDate dateWithTimeIntervalSince1970:1370095200]; // JUN_1_2013 09:00
    NSDate* slot2 = [NSDate dateWithTimeIntervalSince1970:1370098800];
    NSDate* slot3 = [NSDate dateWithTimeIntervalSince1970:1370102400];
    NSDate* slot4 = [NSDate dateWithTimeIntervalSince1970:1370104000];
    NSDate* slot5 = [NSDate dateWithTimeIntervalSince1970:1370107600];
    NSDate* slot6 = [NSDate dateWithTimeIntervalSince1970:1370111200];
    NSDate* slot7 = [NSDate dateWithTimeIntervalSince1970:1370114800];
    NSDate* slot8 = [NSDate dateWithTimeIntervalSince1970:1370118400];
    NSDate* slot9 = [NSDate dateWithTimeIntervalSince1970:1370122000];
    NSDate* slot10 = [NSDate dateWithTimeIntervalSince1970:1370125600];// JUN_1_2013 18:00
    if ([startTime timeIntervalSinceDate:slot1] <= 0) {
        slot = [NSNumber numberWithInteger:1];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot2] <= 0) {
        slot = [NSNumber numberWithInteger:2];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot3] <= 0) {
        slot = [NSNumber numberWithInteger:3];
        NSLog(@"Slot: %@", slot);
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot4] <= 0) {
        slot = [NSNumber numberWithInteger:4];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot5] <= 0) {
        slot = [NSNumber numberWithInteger:5];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot6] <= 0) {
        slot = [NSNumber numberWithInteger:6];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot7] <= 0) {
        slot = [NSNumber numberWithInteger:7];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot8] <= 0) {
        slot = [NSNumber numberWithInteger:8];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot9] <= 0) {
        slot = [NSNumber numberWithInteger:9];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else if ([startTime timeIntervalSinceDate:slot10] <= 0) {
        slot = [NSNumber numberWithInteger:10];
        NSLog(@"Slot: %@ - %@", slot, startTime);
    } else {
        NSLog(@"Unable to determine session: %@", startTime);
    }
    return [NSArray arrayWithObjects:startDate, startTime, endDate, endTime, DoW, slot, nil];
}

+(void) guessSessionSplits {
    
    
}



@end
