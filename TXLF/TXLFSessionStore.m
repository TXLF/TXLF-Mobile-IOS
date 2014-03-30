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

static NSString *dirtyJSON;
static UITableView *sessionTable;

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
    if(self) {
        [TXLFSessionStore allSessions:NO];
    }
    return self;
}

+(NSArray*) allSessions :(BOOL) regen {
    static NSArray* allSessions = nil;
    // regen -> Refresh sesssions without having to restart the app
    if(!allSessions || regen) {
        allSessions = [self generateSessions];
        [sessionTable reloadData];
        [sessionTable setNeedsDisplay];
        
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

+(void) fetchSessions {
    NSLog(@"Attempting to pull remote Session Data");
    NSURL *url = [NSURL URLWithString:@"http://2013.texaslinuxfest.org/session-schedule_mobile"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *net_session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [net_session dataTaskWithRequest:req completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          dirtyJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"Remote Session Data pulled");
                                          [TXLFSessionStore allSessions:TRUE];
                                      }];
    [dataTask resume];
    
    //NSString* tempString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
}

+(NSData *) prepSessions {
    // TODO These URLs need to be specified in a resource file
    NSString *localCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0] stringByAppendingPathComponent:@"session-schedule_mobile.json"];
    //There is an extra "sessions(...)" around the JSON for some reason, probably needs sanitation too
    NSData *sessionJSON;
    if([dirtyJSON length] > 18) {
        NSRange subRange = {9, [dirtyJSON length] - 10};
        NSString* sessionJSONString = [dirtyJSON substringWithRange:subRange];
        sessionJSON = [sessionJSONString dataUsingEncoding:NSUTF8StringEncoding];
    }
    if(sessionJSON) {
        [sessionJSON writeToFile:localCachePath atomically:YES];
        NSLog(@"Session information cached locally.");
        
    } else {
        sessionJSON = [NSData dataWithContentsOfFile:localCachePath];
        if(sessionJSON) {
            NSLog(@"Session information loaded from local cache.");
        }
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
    NSData *sessionJSON = [TXLFSessionStore prepSessions];
    NSMutableArray* sessionArray = [[NSMutableArray alloc] init];
    NSError* errorObj = [[NSError alloc] initWithCoder:nil];
    if (!sessionJSON) {
        TXLFSession* session = [[TXLFSession alloc] initWithStringsDict:@{@"empty_key" : @"empty_value"}];
        [sessionArray addObject:session];
        return sessionArray;
    }
    NSDictionary* sessionDictionary = [NSJSONSerialization JSONObjectWithData:sessionJSON options:0 error:&errorObj];
    NSArray* sessions = [TXLFSessionStore stripJSONObject:sessionDictionary :@"nodes"];
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
        NSUInteger n = allSlotsArray.count;
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

+(void) updateFavs:(TXLFSession *)session :(BOOL)faved{
    static NSMutableDictionary* favs_dict = nil;
    NSError* errorObj = [[NSError alloc] initWithCoder:nil];
    //TODO put this is property list downloadable from Web
    NSString *localFavsCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0] stringByAppendingPathComponent:@"fav_sessions"];
    if(!favs_dict) {
        NSData *plistXML = [NSData dataWithContentsOfFile:localFavsCachePath];;
        if (plistXML) {
            //favs_dict = (NSMutableDictionary *)[NSPropertyListSerialization
            //                                      propertyListWithData:plistXML
            //                                      options:NSPropertyListImmutable
            //                                      format:NULL
            //                                      error:&errorObj];
            NSDictionary *temp_dict = [NSJSONSerialization JSONObjectWithData:plistXML options:0 error:&errorObj];
            favs_dict = [NSMutableDictionary dictionaryWithDictionary:temp_dict];
            NSLog(@"Favorites Read during update");
        } else {
            favs_dict = [[NSMutableDictionary alloc] init];
        }
    }
    
    [favs_dict removeObjectForKey:[[NSNumber numberWithUnsignedInteger:session.sid] stringValue]];
    if (faved) {
        [favs_dict setValue:@"YES" forKey:[[NSNumber numberWithUnsignedInteger:session.sid] stringValue]];
    }
    
    if (favs_dict) {
        NSData *tempData = [NSJSONSerialization dataWithJSONObject:favs_dict options:0 error:&errorObj];
    
        //This should probably only be written when the application exits
        [tempData writeToFile:localFavsCachePath atomically:YES];
        NSLog(@"Favs Saved");
    } else {
        NSLog(@"Error writing Favs");
    }
}

+(void) setTable:(UITableView *) table {
    sessionTable = table;
}

@end
