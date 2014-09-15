//
//  leftmenumain.m
//  standouter2
//
//  Created by zhang on 07/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "leftmenumain.h"
#import "menuleftCell.h"
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "menurightmain.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface leftmenumain ()

@end

@implementation leftmenumain{
    NSInteger simple;
    AppDelegate *myDelegate;
    NSString *urlstring;
    int coono;

    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"Notification_login" object:nil];

}
-(void) login:(NSNotification*) aNotification{
     NSDictionary *theData = [aNotification userInfo];
     NSString *state=[theData objectForKey:@"log"];
     [self.tableView reloadData];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该方法响应列表中行的点击事
    if(indexPath.row==0){
        
    }else
    if(indexPath.row==1){
        myDelegate.contextname =@"freestyle";
    }else{
        
        if (indexPath.row!=[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+[[myDelegate.channellistjson objectForKey:@"total"]integerValue]+3-1) {
            if (indexPath.row==[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+[[myDelegate.channellistjson objectForKey:@"total"]integerValue]+2){
                
            }else {
                if(indexPath.row<[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+2){
                    myDelegate.contextname =[[[myDelegate.contestlistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2] objectForKey:@"code"];
                    
                }else{
                    myDelegate.contextname =[[[myDelegate.channellistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2-[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]] objectForKey:@"code"];
                }
                
                NSLog(myDelegate.contextname);
            }

            
        }
        
        
        

        
    }
    
     myDelegate.menucolor = [UIColor colorWithRed:240/255.0f green:78/255.0f blue:42/255.0f alpha:1.0f];
    
    if ([myDelegate.contextname isEqualToString:@"freestyle"]) {
        myDelegate.menucolor = [UIColor colorWithRed:240/255.0f green:78/255.0f blue:42/255.0f alpha:1.0f];
    }
    
    if ([myDelegate.contextname isEqualToString:@"volagratis"]) {
        myDelegate.menucolor =[UIColor whiteColor];
    }
    if ([myDelegate.contextname isEqualToString:@"universal"]) {
        myDelegate.menucolor =[UIColor whiteColor];
    }
    if ([myDelegate.contextname isEqualToString:@"cityselfie"]) {
        myDelegate.menucolor =[UIColor colorWithRed:2/255.0f green:120/255.0f blue:43/255.0f alpha:1.0f];

    }
    if ([myDelegate.contextname isEqualToString:@"tuborg"]) {
        myDelegate.menucolor =[UIColor colorWithRed:0/255.0f green:61/255.0f blue:34/255.0f alpha:1.0f];
    }
    if ([myDelegate.contextname isEqualToString:@"grock"]) {
        myDelegate.menucolor =[UIColor colorWithRed:217/255.0f green:68/255.0f blue:16/255.0f alpha:1.0f];
    }
    if ([myDelegate.contextname isEqualToString:@"goandfun"]) {
        myDelegate.menucolor =[UIColor colorWithRed:172/255.0f green:202/255.0f blue:88/255.0f alpha:1.0f];
    }
    if ([myDelegate.contextname isEqualToString:@"metro"]) {
        myDelegate.menucolor =[UIColor colorWithRed:2/255.0f green:120/255.0f blue:43/255.0f alpha:1.0f];

    }
    if ([myDelegate.contextname isEqualToString:@"whoodbrooklyn"]) {
        myDelegate.menucolor =[UIColor colorWithRed:107/255.0f green:9/255.0f blue:22/255.0f alpha:1.0f];
        
    }
    
    
    
    
    /*
    switch (indexPath.row) {
        case 0:
            myDelegate.menucolor = [UIColor colorWithRed:255/255.0f green:50/255.0f blue:0/255.0f alpha:1.0f];
            break;
            
        case 1:
            myDelegate.menucolor =[UIColor colorWithRed:255/255.0f green:50/255.0f blue:0/255.0f alpha:1.0f];

            break;
        case 2:
            // tableData = [NSArray arrayWithObjects:@"tuborg.png",@"brief.png",@"upload.png", nil];

            
            myDelegate.menucolor =[UIColor whiteColor];

            break;
            
        case 3:
            // tableData = [NSArray arrayWithObjects:@"universal.png",@"briefb.png",@"uploadb.png", nil];
            
            myDelegate.menucolor =[UIColor whiteColor];
            break;
        case 4:
            // tableData = [NSArray arrayWithObjects:@"goandfun.png",@"brief.png",@"upload.png", nil];
            
            
            myDelegate.menucolor =[UIColor colorWithRed:2/255.0f green:120/255.0f blue:43/255.0f alpha:1.0f];

            break;
        case 5:
            //tableData = [NSArray arrayWithObjects:@"volagratis.png",@"briefb.png",@"uploadb.png", nil];
            
            
            myDelegate.menucolor =[UIColor colorWithRed:0/255.0f green:61/255.0f blue:34/255.0f alpha:1.0f];

            break;
        case 6:
            //tableData = [NSArray arrayWithObjects:@"whoodbrooklyn.png",@"brief.png",@"upload.png", nil];
            
            myDelegate.menucolor =[UIColor colorWithRed:217/255.0f green:68/255.0f blue:16/255.0f alpha:1.0f];
            break;
        case 7:
            // tableData = [NSArray arrayWithObjects:@"metro.jpg",@"brief.png",@"upload.png", nil];
            
            myDelegate.menucolor =[UIColor colorWithRed:172/255.0f green:202/255.0f blue:88/255.0f alpha:1.0f];

            
            break;
        case 8:
            // tableData = [NSArray arrayWithObjects:@"metro.jpg",@"brief.png",@"upload.png", nil];
            
            myDelegate.menucolor =[UIColor colorWithRed:2/255.0f green:120/255.0f blue:43/255.0f alpha:1.0f];
            break;
            
        default:
            break;
    }

    */
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"%d", indexPath.row] forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_roadtableview" object:nil userInfo:dictionary];
    SWRevealViewController *revealController =self.revealViewController;
    
    [revealController revealToggleAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([myDelegate.selfid isEqual:@"-1"]){
                coono=[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+[[myDelegate.channellistjson objectForKey:@"total"]integerValue]+2;
        
    }
    else{
                 coono=[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+[[myDelegate.channellistjson objectForKey:@"total"]integerValue]+3;
        
    }
    return coono;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *simpleTableIdentifier = @"menuleftcell";
    
    
    menuleftCell *cell = (menuleftCell *)[tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"menuleftcell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    
    [cell setBackgroundColor:[UIColor blackColor]];
    
    
    
   
    
    
    
    
    
    if ([myDelegate.selfid isEqual:@"-1"]) {
        
        if (indexPath.row==0) {
            [cell.menuimage setImage:[UIImage imageNamed:@"defaultavatar.png"]];
        }else{
             if (indexPath.row==1) {
             [cell.menuimage setImage:[UIImage imageNamed:@"freestyle.png"]];
             [cell.Cstate setImage:[UIImage imageNamed:@"contestopen"]];

             }else{ if(indexPath.row<[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+2){
                 NSString* imgstring=[[[myDelegate.contestlistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2] objectForKey:@"logoUrl"];
                 urlstring=[[NSString alloc] initWithFormat:@"%@%@", myDelegate.webaddress,imgstring];

                 [cell.menuimage setImageWithURL:[NSURL URLWithString:urlstring] ];
                // NSString* imgstring=[[[myDelegate.contestlistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2] objectForKey:@"code"];
                 
                // urlstring=[[NSString alloc] initWithFormat:@"%@.png", imgstring];
                 //[cell.menuimage setImage:[UIImage imageNamed:urlstring]];
                 if ([[[[myDelegate.contestlistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2] objectForKey:@"contestState"] isEqualToString:@"OPEN"]) {
                     [cell.Cstate setImage:[UIImage imageNamed:@"contestopen"]];
                 }else{
                     [cell.Cstate setImage:[UIImage imageNamed:@"contestclose"]];

                 }
                 
             }else{
                 
                 NSString* imgstring=[[[myDelegate.channellistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2-[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]] objectForKey:@"logoUrl"];
                 urlstring=[[NSString alloc] initWithFormat:@"%@%@", myDelegate.webaddress,imgstring];
                 
                 [cell.menuimage setImageWithURL:[NSURL URLWithString:urlstring] ];
                 /*
                 NSString* imgstring=[[[myDelegate.channellistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2-[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]] objectForKey:@"code"];
                 urlstring=[[NSString alloc] initWithFormat:@"%@.png", imgstring];
                 [cell.menuimage setImage:[UIImage imageNamed:urlstring]];
                  */
                 if ([[[[myDelegate.channellistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2-[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]] objectForKey:@"contestState"] isEqualToString:@"OPEN"]) {
                     [cell.Cstate setImage:[UIImage imageNamed:@"contestopen"]];
                 }else{
                     [cell.Cstate setImage:[UIImage imageNamed:@"contestclose"]];
                     
                 }

             }
                 
                 
             }
        }
        
        //[cell.menuimage setImage:[UIImage imageNamed:[tableData objectAtIndex:indexPath.row]]];
        
    }
    else
    {
        if (indexPath.row==coono-1) {
            [cell.menuimage setImage:[UIImage imageNamed:@"logout.png"]];
        }else{
        if (indexPath.row==0) {
            urlstring=[NSString stringWithFormat:@"%@/avatar/%@/picture",myDelegate.webaddress,myDelegate.selfid];
            [cell.menuimage setImageWithURL:[NSURL URLWithString:urlstring]];
        }else{
            
            if (indexPath.row==1) {
                [cell.menuimage setImage:[UIImage imageNamed:@"freestyle.png"]];
                [cell.Cstate setImage:[UIImage imageNamed:@"contestopen"]];
                
            }else{ if(indexPath.row<[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+2){
                 NSString* imgstring=[[[myDelegate.contestlistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2] objectForKey:@"logoUrl"];
                urlstring=[[NSString alloc] initWithFormat:@"%@%@", myDelegate.webaddress,imgstring];
                
                [cell.menuimage setImageWithURL:[NSURL URLWithString:urlstring] ];
                //NSString* imgstring=[[[myDelegate.contestlistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2] objectForKey:@"code"];
                //urlstring=[[NSString alloc] initWithFormat:@"%@.png", imgstring];
                //[cell.menuimage setImage:[UIImage imageNamed:urlstring]];
                if ([[[[myDelegate.contestlistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2] objectForKey:@"contestState"] isEqualToString:@"OPEN"]) {
                    [cell.Cstate setImage:[UIImage imageNamed:@"contestopen"]];
                }else{
                    [cell.Cstate setImage:[UIImage imageNamed:@"contestclose"]];
                    
                }
                
            }else{
                
                 NSString* imgstring=[[[myDelegate.channellistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2-[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]] objectForKey:@"logoUrl"];
                 urlstring=[[NSString alloc] initWithFormat:@"%@%@", myDelegate.webaddress,imgstring];
                 
                 [cell.menuimage setImageWithURL:[NSURL URLWithString:urlstring] ];
                
                //NSString* imgstring=[[[myDelegate.channellistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2-[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]] objectForKey:@"code"];
               // urlstring=[[NSString alloc] initWithFormat:@"%@.png", imgstring];
                //[cell.menuimage setImage:[UIImage imageNamed:urlstring]];
                if ([[[[myDelegate.channellistjson objectForKey:@"items"] objectAtIndex:indexPath.row-2-[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]] objectForKey:@"contestState"] isEqualToString:@"OPEN"]) {
                    [cell.Cstate setImage:[UIImage imageNamed:@"contestopen"]];
                }else{
                    [cell.Cstate setImage:[UIImage imageNamed:@"contestclose"]];
                    
                }
                
            }
                
                
            }
            
        }
        }

    }
    return cell;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
