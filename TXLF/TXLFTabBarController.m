//
//  TXLFTabBarController.m
//  TXLF
//
//  Created by George Nixon on 12/21/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFTabBarController.h"

@interface TXLFTabBarController ()

@end

@implementation TXLFTabBarController

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
    //id topGuide = self.topLayoutGuide;
    //id myView = self.view;
    //NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (myView, topGuide);
    //[myView addConstraints:
    // [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topGuide]-21-[myView]"
      //                                       options: 0
        //                                     metrics: nil
          //                                     views: viewsDictionary]];
    //[myView layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)disableTab:(NSString*)element {
    NSArray* elements = self.tabBar.items;
    for (id item in elements) {
        if([((UIBarItem*)item).title isEqualToString:element]) {
            ((UIBarItem*)item).enabled = false;
        }
    }
}

@end
