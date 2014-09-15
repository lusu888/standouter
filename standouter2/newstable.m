//
//  newstable.m
//  standouter2
//
//  Created by zhang on 06/03/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "newstable.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "AppDelegate.h"

@implementation newstable{
    NSData *data;
    AppDelegate *myDelegate ;
    
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
        [self setRowHeight:80.f];
        NSURL *url = [NSURL URLWithString:@"http://fakeimg.pl/80x80/?text=Wait&font=lobster" ];
        data = [NSData dataWithContentsOfURL:url];
        
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSince1970];
        
        
        NSString *url2=[NSString stringWithFormat: @"%@/notifications_as_read?ui=%@&ts=%.0f&t=%.0f",myDelegate.webaddress, myDelegate.selfid,sec*1000,sec*1000];
        
        NSLog(url2);
        [myDelegate.manager GET:url2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"noteJSON: %@", responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            return;
        }];
    }
   
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.newsJson objectForKey:@"total"] integerValue];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.backgroundColor=[UIColor blackColor];
    
    
    NSString *ownername=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"authorName"];
    NSString *ownersurname=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"authorSurname"];
    NSString *imgurl=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"authorProfileImageUrl"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", myDelegate.webaddress ,imgurl ]];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    
    [cell.imageView setImageWithURL:url placeholderImage:[[UIImage alloc] initWithData:data ]];
    
    
    cell.textLabel.text =[NSString stringWithFormat: @"%@ %@", ownername, ownersurname]  ;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.detailTextLabel.text=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"customMessage"];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:20.f]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:12.f]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该方法响应列表中行的点击事件
    
    
    
    int vidno=(int)[[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"authorId"] integerValue];
    NSString *vidnos=[[NSString alloc] initWithFormat:@"%d", vidno];
    NSString *newstype=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"type"];
    NSString *newsrow=[NSString stringWithFormat: @"%d", indexPath.row];
   
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: vidnos,@"row", newstype,@"type",newsrow, @"newsrow",nil];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_newschoose" object:nil userInfo:dictionary];
    
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
