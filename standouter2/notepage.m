//
//  notepage.m
//  standouter2
//
//  Created by zhang on 31/03/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "notepage.h"
#import "UIImageView+WebCache.h"
#import "noteshadow.h"


@implementation notepage{
    CGPoint startLocation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //self.backgroundColor=[UIColor greenColor];
        //self.frame=CGRectMake(0, 0, 80, 80);

       self.notiimg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sab.jpg" ]];
        self.notiimg.frame=CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
        
        self.notiimg.layer.masksToBounds=YES;
        self.notiimg.layer.cornerRadius=self.notiimg.frame.size.width/2;
        self.frame=CGRectMake(320-self.frame.size.width, 100, self.frame.size.width,self.frame.size.height);

        [self addSubview:self.notiimg];
        
    }
    return self;
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_touchbegan" object:nil userInfo:nil];

    
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    // Move relative to the original touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame:frame];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Move relative to the original touch point
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_touchend" object:nil userInfo:nil];

    
    if (self.frame.origin.y>468) {
        [self setHidden:YES];
    }
    
    CGRect frame = [self frame];
    if (self.frame.origin.x>(320-self.frame.size.width)/2) {
        frame.origin.x=320-self.frame.size.width;
        
    }
    else{
        frame.origin.x=0;

    }
    [UIView animateWithDuration:0.15f
     　　delay:0
     　　options:UIViewAnimationOptionCurveEaseIn
     　　animations:^{
         　　[self setFrame:frame];
         
         　　}
     　　completion:^(BOOL finished) {
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
