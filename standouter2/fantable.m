//
//  fantable.m
//  standouter2
//
//  Created by zhang on 21/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "fantable.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"


@implementation fantable{
    NSData *data;
    AppDelegate *myDelegate;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor blackColor];
    if (self) {
        // Initialization code
        [self setDelegate:self];
        [self setDataSource:self];
        
       myDelegate = [[UIApplication sharedApplication] delegate];
        self.uid= myDelegate.profileid;
    }
    [self setRowHeight:80.f];
    NSURL *url = [NSURL URLWithString:@"http://fakeimg.pl/80x80/?text=Wait&font=lobster" ];
    data = [NSData dataWithContentsOfURL:url];
    

    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.fansJSON objectForKey:@"total"] integerValue];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.backgroundColor=[UIColor blackColor];
    
    
    NSString *ownername=[[[self.fansJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *ownersurname=[[[self.fansJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"surname"];
    NSString *imgurl=[[[self.fansJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"imageProfileCustomUrl"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@",myDelegate.webaddress ,imgurl ]];
   // NSData *data = [NSData dataWithContentsOfURL:url];

    [cell.imageView setImageWithURL:url placeholderImage:[[UIImage alloc] initWithData:data ]];

    
    cell.textLabel.text =[NSString stringWithFormat: @"%@ %@", ownername, ownersurname]  ;
    cell.textLabel.textColor=[UIColor whiteColor];

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该方法响应列表中行的点击事件
    
    int vidno=(int)[[[[self.fansJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
    NSString *vidnos=[[NSString alloc] initWithFormat:@"%d", vidno];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: vidnos forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_fanchoose" object:nil userInfo:dictionary];
   
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
