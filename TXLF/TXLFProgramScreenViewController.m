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

@synthesize sortByControl;
@synthesize sessionTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
     [TXLFSessionStore sharedStore];
    [sortByControl addTarget:sessionTable
                      action:@selector(reloadData)
            forControlEvents:UIControlEventValueChanged];
    [TXLFSessionStore setTable:sessionTable];
    
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
    NSInteger sortBy = [sortByControl selectedSegmentIndex];
    switch (sortBy) {
        case 0:
            /* if sorting by slots */
             return [[TXLFSessionStore allSlots] count];
            break;
        case 1:
            /* If sorting by tracks */
            return [[TXLFSessionStore allTracks] count];
            break;
        case 2:
            /* If sorting by Favs */
            return 1;
            break;
        default:
            NSLog(@"There has been an error");
            break;
    }
    // TODO return something reasonable
    return [[TXLFSessionStore allSlots] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *sessions = [TXLFSessionStore allSessions: NO];
    NSInteger sortBy = [sortByControl selectedSegmentIndex];
    NSInteger j = 0;
    switch (sortBy) {
        case 0:
            /* if sorting by slots */
            for(NSInteger i = 0; i < sessions.count; i++) {
                NSDate* slot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
                if ([slot isEqualToDate:[[TXLFSessionStore allSlots] objectAtIndex:section]]) {
                    j++;
                }
            }

            break;
        case 1:
            /*if sorting by tracks */
            for(NSInteger i = 0; i < sessions.count; i++) {
                NSString *track = [[[sessions objectAtIndex:i] sessionLocation] objectForKey:@"roomNumber"];
                if ([track isEqualToString:[[TXLFSessionStore allTracks] objectAtIndex:section]]) {
                    j++;
                }
            }
            break;
        case 2:
            /* if sorting by Favs */
            for (id session in sessions) {
                if([session favorite]) {
                    j++;
                }
            }
            break;
        default:
            NSLog(@"There has been an error");
            sortByControl.selectedSegmentIndex = 0;
            break;
    }
    return j;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"sessionCell";
    TXLFSessionCell *cell = [[TXLFSessionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSArray *sessions = [TXLFSessionStore allSessions:NO];
    NSMutableArray *sessionsForSection = [[NSMutableArray alloc] init];
    NSInteger sortBy = [sortByControl selectedSegmentIndex];
    // TODO - need to optimize, this loop is called for each row
    for(NSInteger i = 0; i < sessions.count; i++) {
        NSDate* slot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
        if(sortBy == 0) {
            /* if sorting by slots */
            if ([slot isEqualToDate:[[TXLFSessionStore allSlots] objectAtIndex:[indexPath section]]]) {
                [sessionsForSection addObject:[sessions objectAtIndex:i]];
            }
        } else if (sortBy == 1) {
            /* if sorting by tracks */
            NSString *strack = [[[sessions objectAtIndex:i] sessionLocation] objectForKey:@"roomNumber"];
            NSString *ttrack = [[TXLFSessionStore allTracks] objectAtIndex:[indexPath section]];
            if ([strack isEqualToString:ttrack]) {
                //Insertion Sort - TODO maybe better to use some sort of built-in sorting?
                int n = (int)sessionsForSection.count;
                if (n < 1) {
                    [sessionsForSection addObject:[sessions objectAtIndex:i]];
                } else {
                    while (--n && [slot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedAscending);
                    if([slot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedDescending) {
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n+1];
                    } else {
                        // This should handle both duplicates (e.g. bad input or concurrent sessions) and items that should be inserted at the beginning of the array
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n];
                    }
                }
            }
        } else if (sortBy == 2) {
            /* if sorting by favs */
            if ([[sessions objectAtIndex:i] favorite]) {
                int n = (int)sessionsForSection.count;
                if (n < 1) {
                    [sessionsForSection addObject:[sessions objectAtIndex:i]];
                } else {
                    NSDate *sslot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
                    while (--n && [sslot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedAscending);
                    if([sslot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedDescending) {
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n+1];
                    } else {
                        // This should handle both duplicates (e.g. bad input or concurrent sessions) and items that should be inserted at the beginning of the array
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n];
                    }
                }
            }
        } else {
            NSLog(@"There has been an error");
            sortByControl.selectedSegmentIndex = 0;
        }
    }

    TXLFSession* session = [sessionsForSection objectAtIndex:[indexPath row]];
    cell.textLabel.text = [session sessionTitle];
    NSString* subtitle = [[session sessionPresenter] objectForKey:@"firstName"];
    subtitle = [subtitle stringByAppendingString:@" " ];
    subtitle = [subtitle stringByAppendingString:[[session sessionPresenter] objectForKey:@"lastName"]];
    subtitle = [subtitle stringByAppendingString:@" : " ];
    NSString *slotsTitle = [subtitle stringByAppendingString:[[session sessionLocation] objectForKey:@"roomNumber"]];
    slotsTitle = [slotsTitle stringByAppendingString:@" "];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    switch (sortBy) {
        case 0:
            /* if sorting by slots */
             cell.detailTextLabel.text = slotsTitle;
            break;
        case 1:
            /* if sorting by Tracks */
            [dateFormat setDateFormat:@"EEE - h:mma"];
            cell.detailTextLabel.text = [subtitle stringByAppendingString:[dateFormat stringFromDate:[[session sessionSlot] objectForKey:@"startTime"]]];
            break;
        case 2:
            /* if sorting by Favs */
            [dateFormat setDateFormat:@"EEE - h:mma"];
            cell.detailTextLabel.text = [slotsTitle stringByAppendingString:[dateFormat stringFromDate:[[session sessionSlot] objectForKey:@"startTime"]]];
            break;
        default:
            NSLog(@"There has been an error");
            sortByControl.selectedSegmentIndex = 0;
            break;
    }
    
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
    
    //if ([session favorite]) {
    //    UIImageView *favIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"Icons/fav.png"]];
    //    cell.imageView = favIcon;
    //}
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sortBy = [sortByControl selectedSegmentIndex];
    NSArray *sessions = [TXLFSessionStore allSessions:NO];
    NSMutableArray *sessionsForSection = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < sessions.count; i++) {
         NSDate* slot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
        if (sortBy == 0) {
            // if sorting by slots
            if ([slot isEqualToDate:[[TXLFSessionStore allSlots] objectAtIndex:[indexPath section]]]) {
                [sessionsForSection addObject:[sessions objectAtIndex:i]];
            }
        } else if (sortBy == 1) {
            /* if sorting by tracks */
            // TODO duplicate code, need to optimize/streamline
            NSString *strack = [[[sessions objectAtIndex:i] sessionLocation] objectForKey:@"roomNumber"];
            NSString *ttrack = [[TXLFSessionStore allTracks] objectAtIndex:[indexPath section]];
            if ([strack isEqualToString:ttrack]) {
                //Insertion Sort - TODO maybe better to use some sort of built-in sorting?
                int n = (int)sessionsForSection.count;
                if (n < 1) {
                    [sessionsForSection addObject:[sessions objectAtIndex:i]];
                } else {
                    while (--n && [slot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedAscending);

                    if([slot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedDescending) {
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n+1];
                    } else {
                        // This should handle both duplicates (e.g. bad input or concurrent sessions) and items that should be inserted at the beginning of the array
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n];
                    }
                }
            }
        } else if (sortBy == 2) {
            /* if sorting by favs */
            if ([[sessions objectAtIndex:i] favorite]) {
                int n = (int)sessionsForSection.count;
                if (n < 1) {
                    [sessionsForSection addObject:[sessions objectAtIndex:i]];
                } else {
                    NSDate *sslot = [[[sessions objectAtIndex:i] sessionSlot] objectForKey:@"startTime"];
                    while (--n && [sslot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedAscending);
                    
                    if([sslot compare:[[[sessionsForSection objectAtIndex:n] sessionSlot] objectForKey:@"startTime"]] == NSOrderedDescending) {
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n+1];
                    } else {
                        // This should handle both duplicates (e.g. bad input or concurrent sessions) and items that should be inserted at the beginning of the array
                        [sessionsForSection  insertObject:[sessions objectAtIndex:i] atIndex:n];
                    }
                }
            }
        } else {
            NSLog(@"There has been an error");
            sortByControl.selectedSegmentIndex = 0;
        }
    }

    TXLFSessionDetailViewController *detailView = [[TXLFSessionDetailViewController alloc] init];
    TXLFSession* session = [sessionsForSection objectAtIndex:[indexPath row]];
    [detailView setSession:session];
    [detailView setSessionTable:sessionTable];
    [[self navigationController] pushViewController:detailView animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger sortBy = [sortByControl selectedSegmentIndex];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    switch (sortBy) {
        case 0:
            /* if sorting by slots */
            [dateFormat setDateFormat:@"EEE - h:mma"];
            return [dateFormat stringFromDate:[[TXLFSessionStore allSlots] objectAtIndex:section]];
            break;
        case 1:
            /* if sorting by tracks */
            return [[TXLFSessionStore allTracks] objectAtIndex:section];
            break;
        case 2:
            /* if sorting by favorites */
            return @"Favorite Sessions";
            break;
        default:
            NSLog(@"There has been an error");
            sortByControl.selectedSegmentIndex = 0;
            break;
    }
    return @"";
}

@end
