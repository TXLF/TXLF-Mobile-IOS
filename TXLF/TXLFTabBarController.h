//
//  TXLFTabBarController.h
//  TXLF
//
//  Created by George Nixon on 12/21/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXLFTabBarController : UITabBarController
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (void)disableTab:(NSString*)element;

@end
