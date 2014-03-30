//
//  TXLFSponsorViewController.m
//  TXLF
//
//  Created by George Nixon on 3/27/14.
//  Copyright (c) 2014 Texas Linux Fest. All rights reserved.
//

#import "TXLFSponsorViewController.h"

@interface TXLFSponsorViewController ()

@end

@implementation TXLFSponsorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSURL *regUrl = [NSURL URLWithString:@"http://texaslinuxfest.com/sponsors"];
    //[sponPage loadRequest:[[NSURLRequest alloc] initWithURL:regUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {
    [scrollView setContentSize:imageView.image.size];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
