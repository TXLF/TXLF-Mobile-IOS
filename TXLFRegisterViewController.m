//
//  TXLFRegisterViewController.m
//  TXLF
//
//  Created by George Nixon on 12/22/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFRegisterViewController.h"

@interface TXLFRegisterViewController ()

@end

@implementation TXLFRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Move to init and add to resource file
    NSURL *regUrl = [NSURL URLWithString:@"https://register.texaslinuxfest.org/reg6/checkin/"];
    [regPage loadRequest:[[NSURLRequest alloc] initWithURL:regUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
