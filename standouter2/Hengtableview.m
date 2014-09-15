//
//  Hengtableview.m
//  standouter2
//
//  Created by zhang on 14/03/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "Hengtableview.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"


@implementation Hengtableview{
    AppDelegate *myDelegate;

    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDelegate:self];
        [self setDataSource:self];
        self.transform=CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
        [self setRowHeight:183];
        myDelegate = [[UIApplication sharedApplication] delegate];


       
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle=NO;
    
    // Return the number of rows in the section.
    int n=[[self.myJson objectForKey:@"totalResults"] integerValue];
    if (n>10) {
        n=10;
    }
    return n;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    cell.backgroundColor=[UIColor clearColor];

    
    NSString *imgurl=[[[_myJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"imageUrl480"];;
    NSURL *url = [NSURL URLWithString:imgurl ];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImageView *s=[[UIImageView alloc]initWithFrame:CGRectMake(15,15,213,120)];
    [s setImageWithURL:url];
    s.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
    s.frame=CGRectMake(5,5,100,178);
    [cell addSubview:s];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该方法响应列表中行的点击事件
    
    int vidno=indexPath.row;
    NSString *vidnos=[[NSString alloc] initWithFormat:@"%d", vidno];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: vidnos forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_playv" object:nil userInfo:dictionary];
    
    myDelegate.playno=indexPath.row;

    NSLog(vidnos);
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
