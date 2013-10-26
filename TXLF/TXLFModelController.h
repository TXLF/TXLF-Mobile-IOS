//
//  TXLFModelController.h
//  TXLF
//
//  Created by George Nixon on 10/26/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXLFDataViewController;

@interface TXLFModelController : NSObject <UIPageViewControllerDataSource>

- (TXLFDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(TXLFDataViewController *)viewController;

@end
