//
//  TXLFSessionStore.m
//  TXLF
//
//  Created by George Nixon on 11/4/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFSessionStore.h"
#import "TXLFSession.h"

//Most of the methods in TXLFSession need to be moved here.

@implementation TXLFSessionStore

+(TXLFSessionStore*) sharedStore {
    static TXLFSessionStore* sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

+(id)allowWithZone:(NSZone*) zone {
    return [self sharedStore];
}

-(id)init {
    self = [super init];
    if(self)
        allSessions = [[NSMutableArray alloc] init];
    return self;
}

-(NSArray*) allSessions {
    return allSessions;
}

-(void) addSessions {
    allSessions = [TXLFSession generateSessions];
}

@end
