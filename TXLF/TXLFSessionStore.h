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
}

+(TXLFSessionStore *) sharedStore;

-(NSArray *) allSessions;
-(void) addSessions;

@end
