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
    
    NSString* track = [[session sessionLocation] objectAtIndex:3];
    //NSLog(@"Track: %@", track);
    // This is not general enough, again it needs to be in a downloadaled resource file or generated from JSON
    // Soo much clean-up to do
    if ([track  isEqual: @"Track A - Room 101"]) {
        cell.contentView.backgroundColor = [UIColor greenColor];
    } else if([track  isEqual: @"Track B - Room 102"]) {
        cell.contentView.backgroundColor = [UIColor yellowColor];
    } else if([track  isEqual: @"Track C - Room 105"]) {
        cell.contentView.backgroundColor = [UIColor brownColor];
    } else if([track  isEqual: @"Track D - Room 106"]) {
        cell.contentView.backgroundColor = [UIColor cyanColor];
    } else if([track  isEqual: @"Track E - Room 103"]) {
        cell.contentView.backgroundColor = [UIColor magentaColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

    
    
    
    TXLFSessionDetailViewController *detailView = [[TXLFSessionDetailViewController alloc] init];
    TXLFSession* session = [sessionsForSection objectAtIndex:[indexPath row]];
    [detailView setSession:session];
    [[self navigationController] pushViewController:detailView animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Slot - 1", @"Slot - 1");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Slot - 2", @"Slot - 2");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Slot - 3", @"Slot - 3");
            break;
        case 3:
            sectionName = NSLocalizedString(@"Slot - 4", @"Slot - 4");
            break;
        case 4:
            sectionName = NSLocalizedString(@"Slot - 5", @"Slot - 5");
            break;
        case 5:
            sectionName = NSLocalizedString(@"Slot - 6", @"Slot - 6");
            break;
        case 6:
            sectionName = NSLocalizedString(@"Slot - 7", @"Slot - 7");
            break;
        case 7:
            sectionName = NSLocalizedString(@"Slot - 8", @"Slot - 8");
            break;
        case 8:
            sectionName = NSLocalizedString(@"Slot - 9", @"Slot - 9");
            break;
        case 9:
            sectionName = NSLocalizedString(@"Slot - 10", @"Slot - 10");
            break;
        case 10:
            sectionName = NSLocalizedString(@"Slot - 11", @"Slot - 11");
            break;
        case 11:
            sectionName = NSLocalizedString(@"Slot - 12", @"Slot - 12");
            break;
        case 12:
            sectionName = NSLocalizedString(@"Slot - 13", @"Slot - 13");
            break;
        case 13:
            sectionName = NSLocalizedString(@"Slot - 14", @"Slot - 14");
            break;
        case 14:
            sectionName = NSLocalizedString(@"Slot - 15", @"Slot - 15");
            break;
        case 15:
            sectionName = NSLocalizedString(@"Slot - 16", @"Slot - 16");
            break;
        default:
            sectionName = @"A Slot";
            break;
    }
    return sectionName;
}



@end
