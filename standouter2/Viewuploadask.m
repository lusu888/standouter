//
//  Viewuploadask.m
//  standouter2
//
//  Created by zhang on 05/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "Viewuploadask.h"

@implementation Viewuploadask

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
        //self=(Viewuploadask *)[[[NSBundle mainBundle] loadNibNamed:@"Viewuploadask"owner:self options:nil]objectAtIndex:0];
        [self.ipbtn addTarget:self  action:@selector(getvfromip) forControlEvents:UIControlEventTouchUpInside];

    }

    return self;
}
-(void)getvfromip{
    NSLog(@"zhangip");
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
