//
//  noteshadow.m
//  standouter2
//
//  Created by zhang on 09/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "noteshadow.h"

@implementation noteshadow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame=CGRectMake(0, 468, 320,100);
        self.shadowimg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sab.jpg" ]];
        self.shadowimg.frame=CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
        [self.shadowimg setImage:[UIImage imageNamed:@"shadoww.png"]];
        [self addSubview:self.self.shadowimg];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchbegan) name:@"Notification_touchbegan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toucheend) name:@"Notification_touchend" object:nil];
    }
    return self;
}
-(void)touchbegan{
    [self setHidden:NO];
    [self setNeedsDisplay];
    [UIView animateWithDuration:0.25f
     　　delay:0
     　　options:UIViewAnimationOptionCurveEaseIn
     　　animations:^{
         self.frame= CGRectMake(0, 468, 320,100);
         　　}
     　　completion:^(BOOL finished) {
         　　}];

}
-(void)toucheend{
    
    [UIView animateWithDuration:0.25f
     　　delay:0
     　　options:UIViewAnimationOptionCurveEaseIn
     　　animations:^{
         self.frame= CGRectMake(0, 568, 320,100);
         　　}
     　　completion:^(BOOL finished) {
         [self setHidden:YES];
         　　}];

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
