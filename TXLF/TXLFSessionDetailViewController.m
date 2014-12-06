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
@synthesize sessionTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [fav addTarget:self
                 action:@selector(toggleFavorite)
       forControlEvents:UIControlEventValueChanged];
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
    
    NSData *imageData = [NSData dataWithContentsOfURL:[presenter objectForKey:@"picture"]];
    UIImage *ppic = [UIImage imageWithData:imageData];
    [pic setImage:ppic];
    
    [abstract setText:[[session sessionPresentation] objectForKey:@"abstract"]];
    
    int experience = [[[session sessionPresentation] objectForKey:@"experience"] intValue];
    switch (experience) {
        case 1:
            dexperience.progressTintColor = [UIColor greenColor];
            break;
        case 2:
            dexperience.progressTintColor = [UIColor blueColor];
            break;
        case 3:
            dexperience.progressTintColor = [UIColor purpleColor];
            break;
        case 4:
            dexperience.progressTintColor = [UIColor yellowColor];
            break;
        case 5:
            dexperience.progressTintColor = [UIColor orangeColor];
            break;
        case 6:
            dexperience.progressTintColor = [UIColor redColor];
            break;
        default:
            dexperience.progressTintColor = [UIColor brownColor];
            break;
    }
    
    dexperience.progress = (float)experience/6;
    
    fav.on = [session favorite];
}

-(void) toggleFavorite {
    [session toggleFavorite];
    [sessionTable reloadData];
}

@end
