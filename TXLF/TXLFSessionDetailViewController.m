//
//  TXLFSessionDetailViewController.m
//  TXLF
//
//  Created by George Nixon on 12/21/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFSessionDetailViewController.h"
#import "TXLFSession.h"

@interface TXLFSessionDetailViewController ()

@end

@implementation TXLFSessionDetailViewController
@synthesize session;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray* presenter = [session sessionPresenter];
    NSString* name = [presenter objectAtIndex:0];
    name = [name stringByAppendingString:@" "];
    name = [name stringByAppendingString:[presenter objectAtIndex:1]];
    [dPresenter setText:name];
    
    NSString* biography = [presenter objectAtIndex:6];
    [bio setText:biography ];
    
    NSString* session_title = [presenter objectAtIndex:3];
    [dtitle setText:session_title];
    
    UIImage* ppic = [presenter objectAtIndex:7];
    [pic setImage:ppic];
    
    NSString* session_abstract = [session sessionAbstract];
    [abstract setText:session_abstract];
    
}


@end
