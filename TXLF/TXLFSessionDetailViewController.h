//
//  TXLFSessionDetailViewController.h
//  TXLF
//
//  Created by George Nixon on 12/21/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXLFSession;

@interface TXLFSessionDetailViewController : UIViewController
{
    __weak IBOutlet UILabel *dPresenter;
    __weak IBOutlet UITextView *bio;
    __weak IBOutlet UILabel *dtitle;
    __weak IBOutlet UIImageView *pic;
    __weak IBOutlet UISwitch *fav;
    __weak IBOutlet UITextView *abstract;
    __weak IBOutlet UIProgressView *dexperience;
}

@property (nonatomic, strong) TXLFSession *session;

@end
