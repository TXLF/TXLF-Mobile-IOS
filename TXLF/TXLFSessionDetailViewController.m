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
    NSDictionary* presenter = [session sessionPresenter];
    NSString* name = [presenter objectForKey:@"firstName"];
    name = [name stringByAppendingString:@" "];
    name = [name stringByAppendingString:[presenter objectForKey:@"lastName"]];
    [dPresenter setText:name];
    
    NSString* biography = [presenter objectForKey:@"bio"];
    [bio setText:biography ];
    
    NSString* session_title = [session sessionTitle];
    [dtitle setText:session_title];
    
    UIImage* ppic = [presenter objectForKey:@"picture"];
    [pic setImage:ppic];
    
    NSString* session_abstract = [[session sessionPresentation] objectForKey:@"abstract"];
    [abstract setText:session_abstract];
    
}


@end
