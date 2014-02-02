//
//  TXLFProgramScreenViewController.m
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFProgramScreenViewController.h"
#import "TXLFSessionCell.h"
#import "TXLFSession.h"
#import "TXLFSessionStore.h"

@interface TXLFProgramScreenViewController ()

@end

@implementation TXLFProgramScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     [TXLFSessionStore sharedStore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.

    // if sorting by slots
    return [[TXLFSessionStore allSlots] count];
    // If sorting by tracks
    //return [[TXLFSessionStore allTracks] count];
    // If sorting by Favs
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // if sorting by slots
    NSArray *sessions = [TXLFSessionStore allSessions: NO];
    NSInteger j = 0;
    for(NSInteger i = 0; i < sessions.count; i++) {
        NSDate* slot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
        if ([slot isEqualToDate:[[TXLFSessionStore allSlots] objectAtIndex:section]]) {
            j++;
        }
    }
    return j;
    // if sorting by tracks
    //NSArray *sessions = [TXLFSessionStore allSessions: NO];
    //NSInteger j = 0;
    //for(NSInteger i = 0; i < sessions.count; i++) {
    //    NSString *track = [[[[sessions objectAtIndex:i] sessionLocation] objectForKey:@"address"] objectForKey:@"roomNumber"];
   //     if ([track isEqualToString:[[TXLFSessionStore allTracks] objectAtIndex:section]]) {
   //         j++;
   //     }
   // }
   // return j;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"sessionCell";
    TXLFSessionCell *cell = [[TXLFSessionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSArray *sessions = [TXLFSessionStore allSessions:NO];
    NSMutableArray *sessionsForSection = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < sessions.count; i++) {
        // if sorting by slots
        NSDate* slot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
        if ([slot isEqualToDate:[[TXLFSessionStore allSlots] objectAtIndex:[indexPath section]]]) {
            [sessionsForSection addObject:[sessions objectAtIndex:i]];
        }
        
    }

    
    TXLFSession* session = [sessionsForSection objectAtIndex:[indexPath row]];
    cell.textLabel.text = [session sessionTitle];
    NSString* subtitle = [[session sessionPresenter] objectForKey:@"firstName"];
    subtitle = [subtitle stringByAppendingString:@" " ];
    cell.detailTextLabel.text = [subtitle stringByAppendingString:[[session sessionPresenter] objectForKey:@"lastName"]];

    
    NSString* track = [[session sessionLocation] objectForKey:@"roomNumber"];
    if ([track isEqualToString:@"Amphitheatre"]) {
        cell.contentView.backgroundColor = [[UIColor alloc] initWithRed:0.64 green:0.13 blue:1 alpha:0.7];
    } else if ([track  isEqualToString: @"Track A - Room 101"]) {
        cell.contentView.backgroundColor = [[UIColor alloc] initWithRed:0.83 green:0.2 blue:0.41 alpha:0.7];
    } else if([track  isEqualToString: @"Track B - Room 102"]) {
        cell.contentView.backgroundColor = [[UIColor alloc] initWithRed:0.86 green:0.6 blue:0.2 alpha:0.7];
    } else if([track  isEqualToString: @"Track C - Room 105"]) {
        cell.contentView.backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.87 blue:0.17 alpha:0.7];
    } else if([track  isEqualToString: @"Track D - Room 106"]) {
        cell.contentView.backgroundColor = [[UIColor alloc] initWithRed:0.75 green:0.85 blue:0.25 alpha:0.7];
    } else if([track  isEqualToString: @"Track E - Room 103"]) {
        cell.contentView.backgroundColor = [[UIColor alloc] initWithRed:0.39 green:0.78 blue:0.76 alpha:0.7];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sessions = [TXLFSessionStore allSessions:NO];
    NSMutableArray *sessionsForSection = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < sessions.count; i++) {
        // if sorting by slots
        NSDate* slot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
        if ([slot isEqualToDate:[[TXLFSessionStore allSlots] objectAtIndex:[indexPath section]]]) {
            [sessionsForSection addObject:[sessions objectAtIndex:i]];
        }
        
    }

    TXLFSessionDetailViewController *detailView = [[TXLFSessionDetailViewController alloc] init];
    TXLFSession* session = [sessionsForSection objectAtIndex:[indexPath row]];
    [detailView setSession:session];
    [[self navigationController] pushViewController:detailView animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // If Sorting by slots
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE - h:mma"];
    return [dateFormat stringFromDate:[[TXLFSessionStore allSlots] objectAtIndex:section]];
    // If Sorting by Track
    
}



@end
