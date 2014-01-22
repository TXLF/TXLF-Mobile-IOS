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
    NSLog(@"In viewDidLoad");
     [TXLFSessionStore sharedStore];
    NSLog(@"Exiting viewDidLoad");
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
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[TXLFSessionStore sharedStore] allSessions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sessionCell";
    //TXLFSessionCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        TXLFSessionCell* cell = [[TXLFSessionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    TXLFSession* session = [[[TXLFSessionStore sharedStore] allSessions] objectAtIndex:[indexPath row]];
    cell.textLabel.text = [session sessionName];
    [[cell sessionPresenter] setText:[[session sessionDateTime] description]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXLFSessionDetailViewController *detailView = [[TXLFSessionDetailViewController alloc] init];
    TXLFSession* session = [[[TXLFSessionStore sharedStore] allSessions] objectAtIndex:[indexPath row]];
    [detailView setSession:session];
    [[self navigationController] pushViewController:detailView animated:YES];
}

@end
