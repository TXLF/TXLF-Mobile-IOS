//
//  TXLFSession.m
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//


#import "TXLFSession.h"

@implementation TXLFSession

@synthesize sessionTitle;
@synthesize sessionSlot;
@synthesize sessionNid;
@synthesize sessionLocation;
@synthesize sessionPresentation;
@synthesize sessionPresenter;
@synthesize sessionUid;
@synthesize favorite;


-(id) initWithStringsDict:(NSDictionary *) valueDictionary {
    self = [super init];
    NSString *title = [valueDictionary objectForKey:@"title"];
    NSString *field_session_slot = [valueDictionary objectForKey:@"field_session_slot"];
    NSString *nid = [valueDictionary objectForKey:@"nid"];
    NSString *field_session_room = [valueDictionary objectForKey:@"field_session_room"];
    NSString *path = [valueDictionary objectForKey:@"path"];
    NSString *body = [valueDictionary objectForKey:@"body"];
    NSString *field_experience = [valueDictionary objectForKey:@"field_experience"];
    NSString *uri = [valueDictionary objectForKey:@"uri"];
    NSString *field_profile_bio = [valueDictionary objectForKey:@"field_profile_bio"];
    NSString *field_profile_company = [valueDictionary objectForKey:@"field_profile_company"];
    NSString *picture = [valueDictionary objectForKey:@"picture"];
    NSString *field_profile_website = [valueDictionary objectForKey:@"field_profiel_website"];
    NSString *field_profile_first_name = [valueDictionary objectForKey:@"field_profile_first_name"];
    NSString *field_profile_last_name = [valueDictionary objectForKey:@"field_profile_last_name"];
    NSString *uid_1 = [valueDictionary objectForKey:@"uid_1"];

    
    if (! (title && (self.sessionTitle = [TXLFSession parseSessionTitle:title]))) {
        self.sessionTitle = @"An Exciting Session";
    }
    if (! (field_session_slot && (self.sessionSlot = [TXLFSession parseSessionSlot:field_session_slot]))) {
        self.sessionSlot = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"startTime",
                                                                      [NSDate date], @"endTime", nil];
    }
    if (! (nid && (self.sessionNid = [TXLFSession parseSessionNid:nid]))) {
        self.sessionNid = [NSNumber numberWithInt:0];
    }
    if (! (field_session_room && (self.sessionLocation = [TXLFSession parseSessionLocation:field_session_room]))) {
        self.sessionLocation = [TXLFSession parseSessionLocation:@"Room Unknown"];
    }
    if (!path ||  ! [path compare:@""]) {
        path = @"http://http://texaslinuxfest.org";
    }
    if (!body || ! [body compare:@""]) {
        body = [self.sessionTitle stringByAppendingString:@" summary."];
    }
    if (!field_experience || ! [field_experience compare:@""]) {
        field_experience = @"Unkown";
    }
    if (!uri ||  ! [uri compare:@""]) {
        uri = @"http://http://texaslinuxfest.org";
    }
    self.sessionPresentation = [TXLFSession parseSessionPresentation: path :[TXLFSession parseSessionTitle:body] :field_experience :uri];
    
    if (!field_profile_bio) {
        field_profile_bio = @"Presenter Bio";
    }
    if (!field_profile_company) {
        field_profile_company = @"Presenter Comany";
    }
    if (!picture ||  ! [picture compare:@""]) {
        picture = @"http://2013.texaslinuxfest.org/sites/default/files/styles/thumbnail/public/pictures/picture-223-1369188113.jpg?itok=qj23EcUZ";
    }
    if (!field_profile_website) {
        field_profile_website = @"http://http://texaslinuxfest.org";
    }
    if (!field_profile_first_name) {
        field_profile_first_name = @"Tux";
    }
    if (!field_profile_last_name) {
        field_profile_last_name = @"Linux";
    }
    self.sessionPresenter = [TXLFSession parseSessionPresenterWithDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        field_profile_bio, @"bio",
                                                                        field_profile_company, @"company",
                                                                        picture, @"picture",
                                                                        field_profile_website, @"website",
                                                                        field_profile_first_name, @"firstName",
                                                                        field_profile_last_name, @"lastName", nil]];
    
    if (! (uid_1 && (self.sessionNid = [TXLFSession parseSessionNid:uid_1]))) {
        self.sessionUid = [NSNumber numberWithInt:0];
    }
    self.favorite = FALSE;
    return self;
}

+(NSString *) parseSessionTitle:(NSString *) title {
    // ToDo check if there is an API URL escape function that can do this
    NSString* cleaned = [title stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    cleaned = [cleaned stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    cleaned = [cleaned stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    return cleaned;
}



+(NSDictionary *) parseSessionSlot:(NSString *) dates {
    // May need to be updated handle sessions that spam multiple days
    // TODO - I think timezone conversion occurs automatically, but something we may need to watch
    
    // This is specific to the expected input string
    // TODO - represent as REGEX?
    NSArray *times = [dates componentsSeparatedByString:@"- "];
    NSString *startString = [[NSDate date] description];
    NSString *endString = [[NSDate date] description];
    // This is specific to the expected input string
    // TODO - it may be possible to remove this with abuove REGEX
    if(times.count == 2) {
        startString = [times objectAtIndex:0];
        endString = [times objectAtIndex:1];
    } else if (times.count == 4) {
        startString = [[times objectAtIndex:0] stringByAppendingString:[times objectAtIndex:1]];
        endString = [[times objectAtIndex:2] stringByAppendingString:[times objectAtIndex:3]];
    }
    return [TXLFSession parseSessionSlot:startString :endString];
    
}
+(NSDictionary *) parseSessionSlot:(NSString *) start :(NSString *) end {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    // Relying on autoconversion
    NSDate *startTime = [dateFormat dateFromString:start];
    NSDate *endTime = [dateFormat dateFromString:end];
    
    // If autocoversion doesn't work, specify format
    // TODO - specify format in resource file?
    // TODO - what happens when autoconversion works, but isn't what we want?
    if( startTime == nil || endTime == nil) {
        [dateFormat setDateFormat:@"EEE, MM/dd/yyyy h:mma"];
        startTime = [dateFormat dateFromString:start];
        endTime = [dateFormat dateFromString:end];
    }
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:startTime, endTime, nil]
                                       forKeys:@[@"startTime", @"endTime"]];
}

+(NSNumber *) parseSessionNid:(NSString *) nid {
    return [NSNumber numberWithLong:[nid integerValue]];
}

+(NSDictionary *) parseSessionLocation:(NSString *) descriptionString {
    return [TXLFSession parseSessionLocationWithDict:[NSDictionary dictionaryWithObject:descriptionString forKey:@"roomNumber"]];
}

+(NSDictionary *) parseSessionLocationWithDict:(NSDictionary *) descriptionDict {
    // TODO - defaults for the location should be stored in a resource file
    NSDictionary *gps = [descriptionDict objectForKey:@"gps"];
    NSMutableDictionary *address = [descriptionDict objectForKey:@"address"];
    NSString *building = [descriptionDict objectForKey:@"building"];
    NSString *floor = [descriptionDict objectForKey:@"floor"];
    NSString *roomNumber = [descriptionDict objectForKey:@"roomNumber"];
    NSString *roomName = [descriptionDict objectForKey:@"roomName"];
    NSString *notes = [descriptionDict objectForKey:@"notes"];
    
    if (! (gps || ([gps objectForKey:@"X"] && [gps objectForKey:@"Y"]))) {
        gps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:30.26384], @"X",
                                                         [NSNumber numberWithFloat: -97.73958], @"Y", nil];
    } else if (! [gps objectForKey:@"X"]) {
        gps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:30.26384], @"X",
                                                         [gps objectForKey:@"Y"], @"Y", nil];
    } else if (! [gps objectForKey:@"Y"]) {
        gps = [NSDictionary dictionaryWithObjectsAndKeys:[gps objectForKey:@"X"], @"X",
                                                         [NSNumber numberWithFloat: -97.73958], @"Y", nil];
    }
    
    if (! address) {
        address = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"500 E Cesar Chavez", @"street",
                                                                    @"", @"lineTwo",
                                                                    @"Austin", @"city",
                                                                    @"Texas", @"state",
                                                                    @"78701", @"zip", nil];
    }
    if (! [address objectForKey:@"street"]) {
        [address setObject:@"500 E Cesar Chavez" forKey:@"street"];
    }
    if (! [address objectForKey:@"lineTwo"]) {
        [address setObject:@"" forKey:@"lineTwo"];
    }
    if (! [address objectForKey:@"city"]) {
        [address setObject:@"Austin" forKey:@"city"];
    }
    if (! [address objectForKey:@"state"]) { // TXLF should always be in Texas
        [address setObject:@"Texas" forKey:@"state"];
    }
    if (! [address objectForKey:@"zip"]) {
        [address setObject:@"78701" forKey:@"zip"];
    }
    
    if (! building) {
        building = @"Austin Convention Center";
    }
    
    if (! floor) {
        floor = @"";
    }
    
    if (! roomNumber) {
        roomNumber = @"";
    }
    
    if (! roomName) {
        roomName = @"";
    }
    
    if (! notes) {
        notes = @"";
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:gps, @"gps",
                                                      address, @"address",
                                                      building, @"building",
                                                      floor, @"floor",
                                                      roomNumber, @"roomNumber",
                                                      roomName, @"roomName",
                                                      notes, @"notes", nil];
}

// Order of arguments is important here
+(NSDictionary *) parseSessionPresentation:(NSString *) siteUrl
                                          :(NSString *) abstract
                                          :(NSString *) experience
                                          :(NSString *) files {
    // TODO define experience in resource file?
    int exp = 0;
    if ([experience rangeOfString:@"NOVICE" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        exp = exp | 1;
    }
    if ([experience rangeOfString:@"INTERMEDIATE" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        exp = exp | 2;
    }
    if ([experience rangeOfString:@"ADVANCED" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        exp = exp | 4;
    }
    // Re-ordeing levels to make more sense
    // Not Specified 0
    // NOVICE 1
    // NOVICE, INTERMEDIATE 3 -> 2
    // NOVICE, INTERMEDIATE, ADVANCED 7 -> 3
    // INTERMEDIATE 2 -> 4
    // INTERMEDIATE, ADVANCED 6 -> 5
    // NOVICE, ADVANCED 5 -> 6 -- probabably a mistake, changing to ADVANCED
    // ADVANCED 4 -> 6
    
    if (exp == 3) {
        exp = 2;
    } else if (exp == 7) {
        exp = 3;
    } else if (exp == 2) {
        exp = 4;
    } else if (exp == 6) {
        exp = 5;
    } else if (exp == 5) {
        exp = 6;
    } else if (exp == 4) {
        exp = 6;
    }
  
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSURL URLWithString:siteUrl], @"siteUrl",
                                                      abstract, @"abstract",
                                                      [NSNumber numberWithInt:exp], @"experience",
                                                      [NSURL URLWithString:files], @"files", nil];
    
}


+(NSDictionary *) parseSessionPresenterWithDict:(NSDictionary *) presenterDict {
    // TODO - see if ther are some API object for email addrsses and phone #'s
    NSString *bio = [presenterDict objectForKey:@"bio"];
    NSString *company = [presenterDict objectForKey:@"company"];
    NSURL *picture = [NSURL URLWithString:[presenterDict objectForKey:@"picture"]];
    NSURL *website = [NSURL URLWithString:[presenterDict objectForKey:@"website"]];
    NSString *firstName = [presenterDict objectForKey:@"firstName"];
    NSString *lastName = [presenterDict objectForKey:@"lastName"];
    NSString *email = [presenterDict objectForKey:@"email"];
    NSString *phone = [presenterDict objectForKey:@"phon"];
    NSString *position = [presenterDict objectForKey:@"position"];
    NSString *title = [presenterDict objectForKey:@"title"];
    
    // These are the attributes not included in the JSON
    // missing JSON attritbutes should have been added in init
    if (!email) {
        email = @"info@texaslinuxfest.org";
    }
    if (!phone) {
        phone = @"555.555.5555";
    }
    if (!position) {
        position = @"";
    }
    if(!title) {
        title = @"";
    }

    return [NSDictionary dictionaryWithObjectsAndKeys:bio, @"bio",
                                                      company, @"company",
                                                      picture, @"picture",
                                                      website, @"website",
                                                      firstName, @"firstName",
                                                      lastName, @"lastName",
                                                      email, @"email",
                                                      phone, @"phone",
                                                      position, @"position",
                                                      title, @"title", nil];
}

-(BOOL) toggleFavorite {
    self.favorite = !self.favorite;
    return self.favorite;
}


@end
