//
//  TXLFSession.h
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// "title"                      => sessionTitle                     e.g. : Why Software Patents?
// "field_session_slot"         => sessionSlot.startTime            e.g. : Sat, 06/01/2013 - 10:15am
//                              => sessionSlot.endTime              e.g. : Sat, 06/01/2013 - 11:10am
// "nid"                        => sessionNid                       currently unused
// "field_session_room"         => sessionLocation.gps.X             e.g. GPS X coordinate
//                              => sessionLocation.gps.Y             e.g. GPY Y coordinate
//                              => sessionLocation.address.street   e.g. 500 E. Cesar Chavez
//                              => sessionLocation.address.lineTwo  e.g. STE 100
//                              => sessionLocation.address.city     e.g. Austin
//                              => sessionLocation.address.state    i.e. Texas
//                              => sessionLocation.address.zip      e.g. 78701
//                              => sessionLocation.building         e.g. Austin Convention Center
//                              => sessionLocation.floor            e.g. Twentieth
//                              => sessionLocation.roomNumber       e.g. 104
//                              => sessionLocation.roomName         e.g. Amphitheatre
//                              => sessionLocation.notes            e.g. Right half of room only
// "path"                       => sessionPresentation.siteURL      URI of presentation page on site
// "body"                       => sessionPresentatoin.abstract     short description of presentation
// "field_experience"           => sessionPresentation.experience   Novice,Intermediate,Advanced
// "uri"                        => sessionPresentation.files        URI of slide-deck or other files
// "field_profile_bio"          => sessionPresenter.bio             Bio text
// "field_profile_company"      => sessionPresenter.company         Presenter's company
// "picture"                    => sessionPresenter.picture         URL to presenter's picture
// "field_profile_website"      => sessionPresenter.website         URL to presenter's website
// "field_profile_first_name"   => sessionPresenter.firstName       presenter's first name
// "field_profile_last_name"    => sessionPresenter.lastName        presenter's last  name
//                              => sessionPresenter.email           presenter's email addresss
//                              => sessionPresenter.phone           presenter's phone number
//                              => sessionPresenter.position        presenter's position/title in company
//                              => sessionPresenter.title           e.g. Dr.,Mr.,Mz.,Honorable
// "uid_1"                      => sessionUid                       currently unused
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface TXLFSession : NSObject {

}

@property (nonatomic,strong) NSString *sessionTitle;
@property (nonatomic,strong) NSDictionary *sessionSlot;
@property (nonatomic,strong) NSNumber *sessionNid;
@property (nonatomic,strong) NSDictionary *sessionLocation;
@property (nonatomic,strong) NSDictionary *sessionPresentation;
@property (nonatomic,strong) NSDictionary *sessionPresenter;
@property (nonatomic,strong) NSNumber *sessionUid;

// TODO - check convention orders of class/instance methods

-(id) initWithStringsDict:(NSDictionary *) valueDictionary;

+(NSString *) parseSessionTitle:(NSString *) title;
+(NSDictionary *) parseSessionSlot :(NSString *) dates;
+(NSDictionary *) parseSessionSlot:(NSString *) start :(NSString *) end;
+(NSNumber *) parseSessionNid:(NSString *) nid;
+(NSDictionary *) parseSessionLocation:(NSString *) descriptionString;
+(NSDictionary *) parseSessionLocationWithDict:(NSDictionary *) descriptionDict;
+(NSDictionary *) parseSessionPresentation:(NSString *) siteUrl :(NSString *) abstract :(NSString *) experience :(NSString *) files;
+(NSDictionary *) parseSessionPresentationWithDict:(NSDictionary *) presentationDict;
// TODO add parseSessionPresenter that takes string arguments
+(NSDictionary *) parseSessionPresenterWithDict:(NSDictionary *) presenterDict;

@end
