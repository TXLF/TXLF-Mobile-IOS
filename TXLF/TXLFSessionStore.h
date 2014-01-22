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
    NSMutableArray *allSessions;
    NSMutableArray *sessionSlots;
}

+(TXLFSessionStore *) sharedStore;

-(NSArray *) allSessions;
-(NSArray *) sessionSlots;

+(NSData *) fetchSessions;
+(NSMutableArray *) generateSessions;
+(id) stripJSONObject:(NSDictionary *) dict :(NSString *) objectName;
+(NSMutableArray *) parseSessionDate:(NSString *) dates;

@end
