//
//  SimpleTableCell.m
//  standouter2
//
//  Created by zhang on 05/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell
@synthesize namebtn = _namebtn;
@synthesize prepTimeLabel = _prepTimeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize votecont=_votecont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
