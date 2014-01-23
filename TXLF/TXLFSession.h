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
    NSString *sessionAbstract;
    NSString *sessionExperience;
    
    NSMutableArray  *sessionPresenter; //First Name, Last Name, Company, Title, Email Address, Phone Number, Notes
    NSMutableArray  *sessionLocation; //Addresss, Building, Floor, Room #, Room name, Notes
    NSArray  *sessionDateTime;
    NSString *sessionDocumentation; //URL to slides
}

-(void)setsessionName:(NSString *)name;

-(void)setsessionAbstract:(NSString *) abstract;

-(void)setsessionExperience:(NSString *) experience;

-(void)setsessionPresenter:(NSString *) fname
                          :(NSString *) lname
                          :(NSString *) company
                          :(NSString *) title
                          :(NSString *) email
                          :(NSString *) phone
                          :(NSString *) bio
                          :(UIImage *) pic
                          :(NSURL *) website
                          :(NSString *) notes;

-(void)setsessionLocation:(NSString *) address
                         :(NSString *) building
                         :(NSString *) floor
                         :(NSString *) roomNumber
                         :(NSString *) roomName
                         :(NSNumber *) gpsX
                         :(NSNumber *) gpsY
                         :(NSString *) notes;

-(void)setsessionDateTime:(NSDate *) startdate
                         :(NSDate *) startTime
                         :(NSDate *) endDate
                         :(NSDate *) endTime
                         :(NSString *) DoW;

-(void)setsessionDocumentation:(NSString *) url;

-(id) initWithTitleTime:(NSString *) title :(NSMutableArray *) time;

-(NSString *)sessionName;
-(NSString *)sessionAbstract;
-(NSMutableArray *)sessionPresenter;
-(NSMutableArray *)sessionLocation;
-(NSDate *)sessionDateTime;
-(NSString *)sessionDocumentation;




@end
