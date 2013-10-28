//
//  TXLFSession.h
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXLFSession : NSObject {
    NSString *sessionName;
    NSMutableArray  *sessionPresenter; //First Name, Last Name, Company, Title, Email Address, Phone Number, Notes
    NSMutableArray  *sessionLocation; //Addresss, Building, Floor, Room #, Room name, Notes
    NSDate   *sessionDateTime;
    NSString *sessionDocumentation; //URL to slides
}

-(void)setsessionName:(NSString *)name;
-(void)setsessionPresenter:(NSString *) fname
                          :(NSString *) lname
                          :(NSString *) company
                          :(NSString *) title
                          :(NSString *) email
                          :(NSString *) phone :(NSString *) notes;
-(void)setsessionLocation:(NSString *) address
                         :(NSString *) building
                         :(NSString *) floor
                         :(NSString *) roomNumber
                         :(NSString *) roomName
                         :(NSNumber *) gpsX
                         :(NSNumber *) gpsY
                         :(NSString *) notes;
-(void)setsessionDateTime:(NSDate *) dateTime;
-(void)setsessionDocumentation:(NSString *) url;

-(NSString *)sessionName;
-(NSMutableArray *)sessionPresenter;
-(NSMutableArray *)sessionLocation;
-(NSDate *)sessionDateTime;
-(NSString *)sessionDocumentation;



@end
