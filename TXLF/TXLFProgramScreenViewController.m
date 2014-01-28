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
    //id topGuide = self.topLayoutGuide;
    //id myView = self.view;
    //NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (myView, topGuide);
    //[myView addConstraints:
     // [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topGuide]-21-[myView]"
       //                                      options: 0
         //                                    metrics: nil
           //                                    views: viewsDictionary]];
    //[myView layoutSubviews];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //NSLog(@"In viewDidLoad");
     [TXLFSessionStore sharedStore];
    //NSLog(@"Exiting viewDidLoad");
    //TXLFSession* session = [[[TXLFSessionStore sharedStore] allSessions] objectAtIndex:0];
    //NSLog(@"Session: %@", [session sessionName]);
    
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
    
    //id currentObject;
    NSArray* sessions = [TXLFSessionStore allSessions:NO];
    NSMutableArray* uniqueSlots = [[NSMutableArray alloc] init];
    //while (currentObject = [[sessions objectEnumerator] nextObject]) {
    for(NSInteger i = 0; i < sessions.count; i++) {
        NSNumber* slot = [[[sessions objectAtIndex:i] sessionDateTime] objectAtIndex:5];
        if (![uniqueSlots containsObject:slot]) {
            [uniqueSlots addObject:slot];
        }
    }
    //NSLog(@"Number of session slots: %lu", (unsigned long)uniqueSlots.count);
    return uniqueSlots.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // This is duplicated code and should be put in method/optimized/etc.
    NSArray* sessions = [TXLFSessionStore allSessions:NO];
    NSMutableArray* uniqueSlots = [[NSMutableArray alloc] init];
    NSMutableDictionary* slotCount = [[NSMutableDictionary alloc] init];
    //while (currentObject = [[sessions objectEnumerator] nextObject]) {
    for(NSInteger i = 0; i < sessions.count; i++) {
        NSNumber* slot = [[[sessions objectAtIndex:i] sessionDateTime] objectAtIndex:5];
        if (![uniqueSlots containsObject:slot]) {
            [uniqueSlots addObject:slot];
            [slotCount setValue:[NSNumber numberWithInt:1] forKey:[slot stringValue]];
        } else {
            NSInteger c = [[slotCount valueForKey:[slot stringValue]] integerValue];
            c++;
            [slotCount setValue:[NSNumber numberWithInt:c] forKey:[slot stringValue]];
        }
    }

    NSArray *uniqueSlotsSorted = [uniqueSlots sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    //NSLog(@"Number of rows for slot %@ : %@", [uniqueSlotsSorted objectAtIndex:section], [slotCount valueForKey:[[uniqueSlotsSorted objectAtIndex:section] stringValue]]);
    return [[slotCount valueForKey:[[uniqueSlotsSorted objectAtIndex:section] stringValue]] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"sessionCell";
    //TXLFSessionCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        TXLFSessionCell* cell = [[TXLFSessionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    
    
    // This is duplicated code and should be put in method/optimized/etc.
    NSArray* sessions = [TXLFSessionStore allSessions:NO];
    NSMutableArray* uniqueSlots = [[NSMutableArray alloc] init];
    NSMutableDictionary* slotCount = [[NSMutableDictionary alloc] init];
    //while (currentObject = [[sessions objectEnumerator] nextObject]) {
    for(NSInteger i = 0; i < sessions.count; i++) {
        NSNumber* slot = [[[sessions objectAtIndex:i] sessionDateTime] objectAtIndex:5];
        if (![uniqueSlots containsObject:slot]) {
            [uniqueSlots addObject:slot];
            [slotCount setValue:[NSNumber numberWithInt:1] forKey:[slot stringValue]];
        } else {
            NSInteger c = [[slotCount valueForKey:[slot stringValue]] integerValue];
            c++;
            [slotCount setValue:[NSNumber numberWithInt:c] forKey:[slot stringValue]];
        }
    }
    
    NSArray *uniqueSlotsSorted = [uniqueSlots sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    
    
    // Yeah, so again, this whole logic & the data strucctures need to be organized/optimized
    // it's silly to re-do this for every table row
    NSInteger* viewBy = 0;
    NSNumber* slotID = [uniqueSlotsSorted objectAtIndex:[indexPath section]];
    NSMutableArray* sessionsForSection = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [sessions count]; i++) {
        if([[[[sessions objectAtIndex:i] sessionDateTime] objectAtIndex:5] integerValue] == [slotID integerValue]) {
            [sessionsForSection addObject:[sessions objectAtIndex:i]];
        }
        
    }
    
    
    //TXLFSession* session = [[TXLFSessionStore allSessions :NO] objectAtIndex:[indexPath row]];
    //NSLog(@"indexPath row: %ld - Number of Session: %@", (long)[indexPath row], [slotCount valueForKey:[slotID stringValue]]);
    TXLFSession* session = [sessionsForSection objectAtIndex:[indexPath row]];
    cell.textLabel.text = [session sessionName];
    NSString* subtitle = [[session sessionPresenter] objectAtIndex:0];
    subtitle = [subtitle stringByAppendingString:@" " ];
    subtitle = [subtitle stringByAppendingString:[[session sessionPresenter] objectAtIndex:1]];
    NSString* subtitle_1 = [NSDateFormatter localizedStringFromDate:[[session sessionDateTime] objectAtIndex:1] dateStyle:NSDateFormatterNoStyle timeStyle: NSDateFormatterShortStyle];
    subtitle = [subtitle stringByAppendingString:@" " ];
    cell.detailTextLabel.text = [subtitle stringByAppendingString:subtitle_1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXLFSessionDetailViewController *detailView = [[TXLFSessionDetailViewController alloc] init];
    TXLFSession* session = [[TXLFSessionStore allSessions :NO] objectAtIndex:[indexPath row]];
    [detailView setSession:session];
    [[self navigationController] pushViewController:detailView animated:YES];
}



@end
