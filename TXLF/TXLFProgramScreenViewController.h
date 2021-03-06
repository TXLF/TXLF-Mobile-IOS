//
//  TXLFProgramScreenViewController.h
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXLFSessionDetailViewController.h"

@interface TXLFProgramScreenViewController : UITableViewController {
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortByControl;
@property (strong, nonatomic) IBOutlet UITableView *sessionTable;

@end
