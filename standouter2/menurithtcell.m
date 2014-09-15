//
//  menurithtcell.m
//  standouter2
//
//  Created by zhang on 07/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "menurithtcell.h"


@implementation menurithtcell
@synthesize menurightimage = _menurightimage;


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
