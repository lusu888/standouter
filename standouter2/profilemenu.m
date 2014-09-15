//
//  profilemenu.m
//  standouter2
//
//  Created by zhang on 20/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "profilemenu.h"
#import "Profilemenucell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"


@interface profilemenu ()

@end

@implementation profilemenu{
    NSArray *tableData;
    NSInteger menu1  ;
    NSString *uid;
    AppDelegate *myDelegate;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myDelegate = [[UIApplication sharedApplication] delegate];
    uid= myDelegate.profileid;
    
	// Do any additional setup after loading the view.
    NSLog(@"SS");
    
    
    if ([myDelegate.profileid isEqualToString:myDelegate.selfid]) {
        tableData = [NSArray arrayWithObjects:@"defaultavatar.png",@"portfolio.png",@"fans.png", @"news.png",@"logout.png",nil];
    }else{
        tableData = [NSArray arrayWithObjects:@"defaultavatar.png",@"portfolio.png",@"fans.png", nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changefoto) name:@"Notification_chagefoto" object:nil];
    [self setExtraCellLineHidden:self.profiletableview];

}
-(void)changefoto{
    if ([uid isEqualToString:myDelegate.selfid]) {
        tableData = [NSArray arrayWithObjects:@"defaultavatar.png",@"portfolio.png",@"fans.png", @"news.png",@"logout.png",nil];
    }else{
        tableData = [NSArray arrayWithObjects:@"defaultavatar.png",@"portfolio.png",@"fans.png", nil];
    }
    
    [self.profiletableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([myDelegate.profileid isEqualToString:myDelegate.selfid]) {
         return 5;
    }else{
       return 3;
    }
   // return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableView.separatorStyle = NO;

    static NSString *simpleTableIdentifier = @"Profilemenucell";
    
    
    Profilemenucell *cell = (Profilemenucell *)[tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Profilemenucell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *profileimgurl=[NSString stringWithFormat: @"%@/avatar/%@/picture",myDelegate.webaddress, myDelegate.profileid ];
    
    if(indexPath.row==0){
        [cell.profilemenuimg setImageWithURL:[NSURL URLWithString:profileimgurl]];
        
    }else
    {
        [cell.profilemenuimg setImage:[UIImage imageNamed:[tableData objectAtIndex:indexPath.row]]];
    }
    
   // [cell setBackgroundColor:[UIColor blackColor]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该方法响应列表中行的点击事件
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"%d", indexPath.row] forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_profilemenu" object:nil userInfo:dictionary];
    SWRevealViewController *revealController =self.revealViewController;
    [revealController rightRevealToggleAnimated:YES];
    
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    view=nil;
 }


@end
