//
//  TXLFProgramCell.m
//  TXLF
//
//  Created by George Nixon on 11/11/13.
//  Copyright (c) 2013 Texas Linux Fest. All rights reserved.
//

#import "TXLFSessionCell.h"

@implementation TXLFSessionCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.font = [self.textLabel.font fontWithSize:10.0];
        
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:8.0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
