//
//  menurightmain.m
//  standouter2
//
//  Created by zhang on 07/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "menurightmain.h"
#import "menurithtcell.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface menurightmain ()

@end

@implementation menurightmain{
    NSArray *tableData;
    NSInteger menu1  ;
    AppDelegate *myDelegate;

    NSString *urlstring;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    myDelegate = [[UIApplication sharedApplication] delegate];

     menu1 = [myDelegate.page1page integerValue];
    
    urlstring=[NSString stringWithFormat:@"%@.png", myDelegate.contextname];
    tableData=[NSArray arrayWithObjects:urlstring,@"brief.png",@"upload.png", nil];
    
    /*
    switch (menu1) {
        case 0:
            tableData = [NSArray arrayWithObjects:@"freestyle.png",@"brief.png",@"upload.png", nil];
            break;
        case 1:
            tableData = [NSArray arrayWithObjects:@"freestyle.png",@"brief.png",@"upload.png", nil];
            break;
        case 2:
            tableData = [NSArray arrayWithObjects:@"tuborg.png",@"brief.png",@"upload.png", nil];
            break;

        case 3:
            tableData = [NSArray arrayWithObjects:@"universal.png",@"briefb.png",@"uploadb.png", nil];
            
            break;
        case 4:
            tableData = [NSArray arrayWithObjects:@"goandfun.png",@"brief.png",@"upload.png", nil];
            
            break;
        case 5:
            tableData = [NSArray arrayWithObjects:@"volagratis.png",@"briefb.png",@"uploadb.png", nil];
            
            break;
        case 6:
            tableData = [NSArray arrayWithObjects:@"whoodbrooklyn.png",@"brief.png",@"upload.png", nil];
            
            break;
        case 7:
            tableData = [NSArray arrayWithObjects:@"metro.jpg",@"brief.png",@"upload.png", nil];
             break;
        case 8:
            tableData = [NSArray arrayWithObjects:@"metro.jpg",@"brief.png",@"upload.png", nil];
            
            break;

            
        default:
            break;
    }
*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadmenutableview:) name:@"Notification_roadtableview" object:nil];

    
}
- (void) loadmenutableview: (NSNotification*) note
{

    NSDictionary *theData = [note userInfo];
    if (theData != nil) {
        urlstring=[NSString stringWithFormat:@"%@.png", myDelegate.contextname];

        tableData=[NSArray arrayWithObjects:urlstring,@"brief.png",@"upload.png", nil];

        [self.menurighttable reloadData];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    menu1 = [myDelegate.page1page integerValue];

    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"menurightcell";
    
    
    menurithtcell *cell = (menurithtcell *)[tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"menurightcell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    

    //cell.menurightimage.image = [UIImage imageNamed:[tableData objectAtIndex:indexPath.row]];
   [cell setBackgroundColor:myDelegate.menucolor];
    if (myDelegate.menucolor==[UIColor whiteColor]) {
        tableData =[NSArray arrayWithObjects:urlstring,@"briefb.png",@"uploadb.png", nil];
    }
    
    if (indexPath.row==0) {
        NSString* imgstring=[myDelegate.briefjson objectForKey:@"logoUrl"];
        urlstring=[[NSString alloc] initWithFormat:@"%@%@", myDelegate.webaddress,imgstring];
        [cell.menurightimage setImageWithURL:urlstring];
    }else{
    [cell.menurightimage setImage:[UIImage imageNamed:[tableData objectAtIndex:indexPath.row]]];
    }
    //[cell setBackgroundColor:[UIColor blackColor]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该方法响应列表中行的点击事件
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"%d", indexPath.row] forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_brief" object:nil userInfo:dictionary];
    SWRevealViewController *revealController =self.revealViewController;
    [revealController rightRevealToggleAnimated:YES];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
