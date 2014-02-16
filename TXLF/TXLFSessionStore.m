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
    static NSArray* allSessions = nil;
    // regen -> Refresh sesssions without having to restart the app
    if(!allSessions || regen) {
        allSessions = [self generateSessions];
        NSLog(@"Sessions generated");
    }
    return allSessions;
}

+(NSArray *) allSlots {
    static NSArray* allSlots = nil;
    if(!allSlots) {
        allSlots = [self generateSlots];
        NSLog(@"Slots generated");
    }
    return allSlots;
}

+(NSArray *) allTracks {
    static NSArray* allTracks = nil;
    if(!allTracks) {
        allTracks = [self generateTracks];
        NSLog(@"Tracks generated");
    }
    return allTracks;
}

+(NSData *) fetchSessions {
    //These URLs need to be specified in a resource file or something
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
        NSLog(@"Session information loaded from local cache.");
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
    NSArray* sessions = [TXLFSessionStore stripJSONObject:sessionDictionary :@"nodes"];
    NSMutableArray* sessionArray = [[NSMutableArray alloc] init];
    for(id singleSession in sessions) {
        NSDictionary* sessionDict = [self stripJSONObject:singleSession :@"node"];
        TXLFSession* session = [[TXLFSession alloc] initWithStringsDict:sessionDict];
        [sessionArray addObject:session];
    }
    return sessionArray;
}

+(NSArray *) generateSlots {
    NSMutableArray *allSlotsArray = [[NSMutableArray alloc] init];
    NSArray *sessions = [TXLFSessionStore allSessions:NO];
    for (id session in sessions) {
        NSDate *startTime = [[session sessionSlot] objectForKey:@"startTime"];
        // Unique Insertion sort
        int n = allSlotsArray.count;
        if (n < 1) {
            [allSlotsArray addObject:startTime];
        } else {
            while (--n && [startTime compare:[allSlotsArray objectAtIndex:n]] == NSOrderedAscending);
        }
        if([startTime compare:[allSlotsArray objectAtIndex:n]] == NSOrderedDescending) {
            [allSlotsArray  insertObject:startTime atIndex:n+1];
        } else if (n == 0 && [startTime compare:[allSlotsArray objectAtIndex:n]] != NSOrderedSame) {
            [allSlotsArray  insertObject:startTime atIndex:n];
        }
    }
    return allSlotsArray;
}

+(NSArray *) generateTracks {
    NSMutableArray *allTracksArray = [[NSMutableArray alloc] init];
    for (id session in [TXLFSessionStore allSessions:NO]) {
        NSString *track = [[session sessionLocation] objectForKey:@"roomNumber"];
        if (![allTracksArray containsObject:track]) {
            [allTracksArray addObject:track];
        }
    }
    return [allTracksArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
@end
