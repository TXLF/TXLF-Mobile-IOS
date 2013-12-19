//
//  TXLFTopBanner.m
//  TXLF
//
//  Created by George Nixon on 12/18/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFTopBanner.h"

@implementation TXLFTopBanner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self) {
          [self setText:@"Texas Linux Festival 2014"];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
