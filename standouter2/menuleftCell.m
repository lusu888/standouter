//
//  menuleftCell.m
//  standouter2
//
//  Created by zhang on 07/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "menuleftCell.h"

@implementation menuleftCell
@synthesize menuimage = _menuimage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
     
}

@end
