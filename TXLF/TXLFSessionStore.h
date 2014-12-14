//
//  TXLFSessionStore.h
//  TXLF
//
//  Created by George Nixon on 11/4/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXLFSession;

@interface TXLFSessionStore : NSObject {

}



//@property NSArray* allSessions;
//@property NSDictionary* allSlots;
//@property NSDictionary* allTracks;

+(TXLFSessionStore *) sharedStore;

+(NSArray *) allSessions:(BOOL) regen;
+(NSArray *) allSlots;
+(NSArray *) allTracks;

+(void) fetchSessions;
+(NSData *) prepSessions;
//+(NSMutableArray *) generateSessions;
//+(NSMutableArrary *) generateSlots;
//+(id) stripJSONObject:(NSDictionary *) dict :(NSString *) objectName;
+(void) updateFavs:(TXLFSession *) session :(BOOL) faved;

+(void) setTable:(UITableView *) table;

@end
