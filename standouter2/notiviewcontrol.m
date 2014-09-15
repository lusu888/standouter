//
//  notiviewcontrol.m
//  standouter2
//
//  Created by zhang on 01/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "notiviewcontrol.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "AFNetworking/AFHTTPRequestOperation.h"
#import "notitablecell.h"

@interface notiviewcontrol ()

@end

@implementation notiviewcontrol{
    int a;
   AppDelegate *myDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         myDelegate = [[UIApplication sharedApplication] delegate];
        self.uid= myDelegate.profileid;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    a=[[self.newsJson objectForKey:@"total"] integerValue];
    return a;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    a=[[self.newsJson objectForKey:@"total"] integerValue];
    
   

    
    static NSString *simpleTableIdentifier = @"notitablecell";
    
    notitablecell *cell = (notitablecell *)[tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"notitablecell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    // Configure the cell...
    
    cell.backgroundColor=[UIColor blackColor];
    
    
    NSString *ownername=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"authorName"];
    NSString *ownersurname=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"authorSurname"];
    NSString *imgurl=[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"authorProfileImageUrl"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@",myDelegate.webaddress, imgurl ]];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    
   // [cell.imageView setImageWithURL:url];
    
    
   // cell.textLabel.text =[NSString stringWithFormat: @"%@ %@", ownername, ownersurname];
    NSLog(cell.textLabel.text);
    //cell.textLabel.textColor=[UIColor whiteColor];
    NSString *temp =[[[self.newsJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"customMessage"];
   // cell.detailTextLabel.textColor=[UIColor whiteColor];
    [cell.noticellimg setImageWithURL:url];
    cell.notidetal.text=[NSString stringWithFormat: @"%@ %@ %@", ownername, ownersurname, temp];
    cell.notidetal.textColor=[UIColor whiteColor];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    myDelegate = [[UIApplication sharedApplication] delegate];
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSince1970];
    

    NSString *url=[NSString stringWithFormat: @"%@/notifications_as_read?ui=%@&ts=%.0f&t=%.0f",myDelegate.webaddress, myDelegate.selfid,sec*1000,sec*1000];

    NSLog(url);
    [myDelegate.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"noteJSON: %@", responseObject);
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"%d", indexPath.row] forKey:@"row"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_notitableview" object:nil userInfo:dictionary];
        //该方法响应列表中行的点击事件
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        return;
    }];
    
   
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
