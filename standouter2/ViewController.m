//
//  ViewController.m
//  standouter2
//
//  Created by zhang on 06/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "FileOps.h"
#import "ALMoviePlayerController/ALMoviePlayerController.h"
#import "Profileview.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager+Timeout.h"
#import "leftmenumain.h"
#import "EGORefreshTableHeaderView.h"
#import "footerview.h"
#import "notepage.h"
#import "FPPopoverController.h"
#import "notiviewcontrol.h"
#import "noteshadow.h"
#include "APService.h"


#define FONT_SOHO_STD(s) [UIFont fontWithName:@"Oswald";size:s]


@interface ViewController ()
@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;
@end

@implementation ViewController{

    NSDictionary *resultJSON;
    NSDictionary *briefJSON;
    NSDictionary *notijson;
    NSInteger S;
    NSURL *url ;
    NSThread *thread;
    NSThread *logoutthread;
    NSURL *briefurl;
   // UIButton *sharebtn;
    //UIButton *votebtn;
    //UIButton *fbsharebtn;
    //UIButton *whatsappbtn;
    int mainpage;
    Boolean pagechange;
    NSThread *thread0;
    AppDelegate *myDelegate;
    BOOL refreshlflag;
    BOOL isLoading;
    NSInteger totaltresults;
    NSInteger loadresults;
    NSThread *loadmorethread;
    NSInteger *playno;
    BOOL shareout;
    NSInteger playery;
    UIStoryboard *storyboard2;
    notiviewcontrol *notiview;
    FPPopoverController *popover;
    
    notepage *notep;
    BOOL playintflag;
    BOOL menuleftflag;
    NSString *oristate;
    NSThread *threadupload;
    BOOL iniflag;
    noteshadow *notes;
    
    bool timeout;
    NSString *urlstring;
    int conno;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];

    NSLog(@"viewWillAppear");
   // thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"mj"]  ;
   // thread.start;
    if (!iniflag) {
        [self run:nil];
        iniflag=true;

        
    }
    

}

-(void)loadnoti{
     NSString *url=[NSString stringWithFormat: @"%@/notifications?ui=%@",myDelegate.webaddress, myDelegate.selfid];
    NSLog(url);
    [myDelegate.manager GET:url parameters:nil  timeoutInterval:5.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        int totalCount=  [[responseObject objectForKey:@"totalCount"] intValue] ;
        if (totalCount>=1) {
            int sid= [[[[responseObject objectForKey:@"items"] objectAtIndex:0] objectForKey:@"authorId"] integerValue];
           
            if(notep!=nil&&!notep.isHidden){
                [notep removeFromSuperview];
                
            }
            notep=[[notepage alloc] initWithFrame:CGRectMake(320-60, 100, 60, 60)];
            [notep setUserInteractionEnabled:YES];
            NSString *temp=[[NSString alloc] initWithFormat:@"%@/avatar/%d/picture",myDelegate.webaddress,sid];
            [notep.notiimg setImageWithURL:[NSURL URLWithString:temp]];
            temp=nil;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notipop)];
            singleTap2.numberOfTapsRequired = 1;
            notep.userInteractionEnabled = YES;
            [notep addGestureRecognizer:singleTap2];
            notep.alpha=0;
            
            [self.revealViewController.view addSubview:notep];
            [UIView animateWithDuration:0.15f
             　　delay:0
             　　options:UIViewAnimationOptionCurveEaseIn
             　　animations:^{
                 notep.alpha=1;
                 　　}
             　　completion:^(BOOL finished) {
                 　　}];
            
            
            //notep=nil;
            singleTap2=nil;
            notep.notiimg=nil;
            storyboard2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            notiview= [storyboard2 instantiateViewControllerWithIdentifier:@"noti"];
            notijson=responseObject;
            notiview.newsJson=responseObject;
            [notiview.notetable reloadData];
            popover = [[FPPopoverController alloc]initWithViewController:notiview];
            
            
            
            notes= [[noteshadow alloc]initWithFrame:CGRectMake(0, 568, 320,100)];
            
            
            [self.view addSubview:notes];
            [self.revealViewController.view bringSubviewToFront:notes];
            [notes setHidden:YES];
            
        }
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self performSelectorOnMainThread:@selector(interneterror) withObject:nil waitUntilDone:YES];
        
        return;        NSLog(@"ERRERRT");
    }];
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    timeout=false;
    iniflag=false;
	// Do any additional setup after loading the view.
    myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.page=@"1";
    loadresults=5;
    isLoading=false;
    //myDelegate.webaddress=@"http://www.standouter.com";
    
   myDelegate.webaddress=@"http://apps.standouter.com";
    myDelegate.profileadd=@"/profile/profileinfo";
    myDelegate.sharesite=@"http://www.standouter.com";
    
    myDelegate.menucolor = [UIColor colorWithRed:205/255.0f green:82/255.0f blue:35/255.0f alpha:1.0f];
   

    
    self.revealViewController.automaticallyAdjustsScrollViewInsets =NO;

    //self.revealViewController.toggleAnimationDuration=0.4f;
    
    /*******************************************************************
     //header
     ******************************************************************/
    
    self.revealViewController.rearViewRevealWidth=80;
    self.revealViewController.rearViewRevealOverdraw=0;
    self.revealViewController.rightViewRevealWidth=80;
    self.revealViewController.rightViewRevealOverdraw = 0.0f;
    

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    [self.menuleftmainbtn addTarget:self.revealViewController  action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.menurightmainbtn addTarget:self.revealViewController  action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
 
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    S=0;
    
    myDelegate.contextname=@"freestyle";
    urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
    url = [NSURL URLWithString:urlstring];
    urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
    briefurl=[NSURL URLWithString:urlstring];

     [self.header setImage: [UIImage imageNamed:@"standouterheader.png" ]];
    
    
    //NSLog([[NSString alloc] initWithFormat:@"%d", S]);
    //self.menuleftmainbtn.imageView.image=[UIImage imageNamed:@"menuwhite.png"];
    //self.menurightmainbtn.imageView.image=[UIImage imageNamed:@"menuwhite.png"];
   

    
    //self.header.image=[UIImage imageNamed:@"goandfunheader.png"];
    NSLog(@"S");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    /*******************************************************************/
    FileOps *files = [[FileOps alloc] init];
    if([files fileexits:@"JSESSIONID.txt"]==
       TRUE){
        
        
        myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE=[files readFromFile:@"SPRING_SECURITY_REMEMBER_ME_COOKIE.txt"];
        myDelegate.jessionid=[files readFromFile:@"JSESSIONID.txt"];
        
        
    }
    else{
        NSLog(@"NO FILE");
    }
    myDelegate.manager = [AFHTTPRequestOperationManager manager];
    
    [myDelegate.manager.requestSerializer setValue:myDelegate.jessionid forHTTPHeaderField:@"Cookie"];
    files=nil;
    /****************************************************/
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableviewmain.bounds.size.height, self.view.frame.size.width, self.tableviewmain.bounds.size.height)];
		view.delegate = self;
		[self.tableviewmain addSubview:view];
		_refreshHeaderView = view;
        
        [_refreshHeaderView setBackgroundColor:[UIColor blackColor]];
        
		//[view release];
		view=nil;
	}
    thread0= [[NSThread alloc]initWithTarget:self selector:@selector(run0) object:@"mj"];
    
    [thread0 start];
    thread0 =nil;
	/****************************************************/
    
    
	

	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];

    [self playerinit];
    
    
    /****************************************************/
    
   
    
     /******************************************************************/
    
    
    
    
    /****************************************************/
    /****************************************************/
    /****************************************************/
    /****************************************************/
    
    // create a movie player
        // add movie player to your view
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinish:) name:@"Notification_movefinish" object:nil];
   //设置视频播放结束后的回调处理
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showcontrol:) name:@"Notification_showcontrols" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddencontrol:) name:@"Notification_hidecontrols" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadtableview:) name:@"Notification_roadtableview" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showbrief:) name:@"Notification_brief" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotologin) name:@"Notification_gotologin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerinit) name:@"Notification_backtomain" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoprofile1) name:@"Notification_gotoprofile1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoprofile3:) name:@"Notification_notitableview" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadnoti) name:@"Notification_noti" object:nil];

    
    /*
    
    sharebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"sharea.png" ]  forState:UIControlStateNormal];
    sharebtn.frame = CGRectMake(0, 100, 50, 50);
    [self.view addSubview:sharebtn];
    [sharebtn addTarget:self  action:@selector(sharerun) forControlEvents:UIControlEventTouchUpInside];
    [sharebtn setHidden:YES];
    sharebtn.alpha=0;
    sharebtn.frame = CGRectMake(-80, sharebtn.frame.origin.y, 80, 80);
    
    fbsharebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fbsharebtn setBackgroundImage:[UIImage imageNamed:@"facebook.jpeg" ]  forState:UIControlStateNormal];
    fbsharebtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 50, 50);
    [self.view addSubview:fbsharebtn];
    [fbsharebtn addTarget:self  action:@selector(fbsharerun) forControlEvents:UIControlEventTouchUpInside];
    [fbsharebtn setHidden:YES];
    fbsharebtn.alpha=0;
    fbsharebtn.frame = CGRectMake(-80, 0, 80, 80);
    
    whatsappbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [whatsappbtn setBackgroundImage:[UIImage imageNamed:@"whatapp.jpg" ]  forState:UIControlStateNormal];
    whatsappbtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 50, 50);
    [self.view addSubview:whatsappbtn];
    [whatsappbtn addTarget:self  action:@selector(wpsharerun) forControlEvents:UIControlEventTouchUpInside];
    [whatsappbtn setHidden:YES];
    whatsappbtn.alpha=0;
    whatsappbtn.frame = CGRectMake(-80, 0, 80, 80);
    
    shareout=false;
    
    
    
    votebtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [votebtn setBackgroundImage:[UIImage imageNamed:@"sa.png" ]  forState:UIControlStateNormal];
    [self.view addSubview:votebtn];
    [votebtn setHidden:YES];
    [votebtn addTarget:self  action:@selector(voterun) forControlEvents:UIControlEventTouchUpInside];
    votebtn.frame = CGRectMake(320, votebtn.frame.origin.y, 80, 80);
    votebtn.alpha=0;
    
    */
    

    menuleftflag=false;
    [self.view setBackgroundColor:[UIColor blackColor]];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:nil];//更新列表

   
}
-(void)notipop{
    NSLog(@"ssd");

    //NSLog(notiview.newsJson);
    [notiview.notetable reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_touchend" object:nil userInfo:nil];
    if (notep.frame.origin.y>468) {
        [notep setHidden:YES];
    }else{
        [popover presentPopoverFromView:notep];
        

    }
    
    CGRect frame = [notep frame];
    if (notep.frame.origin.x>(320-notep.frame.size.width)/2) {
        frame.origin.x=320-notep.frame.size.width;
        
    }
    else{
        frame.origin.x=0;
        
    }
    [UIView animateWithDuration:0.15f
     　　delay:0
     　　options:UIViewAnimationOptionCurveEaseIn
     　　animations:^{
         　　[notep setFrame:frame];
         
         　　}
     　　completion:^(BOOL finished) {
         　　}];
    

   

    
}



-(void)playerinit{
    self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:self.view.frame];
    self.moviePlayer.delegate = self; //IMPORTANT!
    
    self.briefvideoimg.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage:) ];
    [self.briefvideoimg addGestureRecognizer:singleTap];
    
    // create the controls
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleEmbedded];
    
    // optionally customize the controls here...
    /*
     [movieControls setBarColor:[UIColor colorWithRed:195/255.0 green:29/255.0 blue:29/255.0 alpha:0.5]];
     [movieControls setTimeRemainingDecrements:YES];
     [movieControls setFadeDelay:2.0];
     [movieControls setBarHeight:100.f];
     [movieControls setSeekRate:2.f];
     
     */
    [movieControls setBarHeight:30.f];
    // assign the controls to the movie player
    [self.moviePlayer setControls:movieControls];
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer.view setHidden:YES];
    
}
/*
-(void)fbsharerun{
    
    if ([[FBSession activeSession]isOpen]==false) {
        myDelegate.loginmode=@"purefblogin";
        [self performSelectorOnMainThread:@selector(gotologin) withObject:nil waitUntilDone:YES];
        return;

    }

    NSLog(@"RUN FBSHARE");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    NSString *videotitle= [[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"title"];
    NSString *messagefbshare=[[NSString alloc] initWithFormat:@"I like the video %@ in standouter.", videotitle];
    
    NSInteger *videoid= [[[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"id"] integerValue];
    NSString *sharelink=[[NSString alloc] initWithFormat:@"http://demostandouter.zerouno.it/video?ri=%d", videoid];
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString *fbshareurl=[[NSString alloc] initWithFormat:@"https://graph.facebook.com/me/feed?access_token=%@", fbAccessToken];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                             messagefbshare, @"message",sharelink,@"link",
                            nil
                            ];
    
    [myDelegate.manager POST:fbshareurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)wpsharerun{
    NSLog(@"RUN WHATSAPP");
    NSString * msg = @"YOUR MSG";
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)sharerun{
    
    
 NSLog([[NSString alloc] initWithFormat:@"share%d", playno]);
    if ([myDelegate.selfid isEqualToString:@"-1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No login"
                                                        message:@"You must login to share this video."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
        myDelegate.loginmode=@"nomal";
         [self performSelectorOnMainThread:@selector(gotologin) withObject:nil waitUntilDone:YES];
    }else{
       
        NSLog([[NSString alloc] initWithFormat:@"share %d", playno]);
       
        fbsharebtn.alpha=fbsharebtn.alpha;
        fbsharebtn.frame = CGRectMake(fbsharebtn.frame.origin.x, sharebtn.frame.origin.y, 80, 80);
        whatsappbtn.frame = CGRectMake(whatsappbtn.frame.origin.x, sharebtn.frame.origin.y, 80, 80);
        whatsappbtn.alpha=votebtn.alpha;
        if (shareout) {
            
            [UIView animateWithDuration:0.4f
             　　delay:0
             　　options:UIViewAnimationOptionCurveEaseIn
             　　animations:^{
                 　　fbsharebtn.alpha = 0;
                 whatsappbtn.alpha=0;
                 fbsharebtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 80, 80);
                 whatsappbtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 80, 80);
                 
                 　　}
             　　completion:^(BOOL finished) {
                 shareout=false;
                 [fbsharebtn setHidden:YES];
                 [whatsappbtn setHidden:YES];
                 　　}];
           
        }
        else{
            [self.view addSubview:fbsharebtn];
            [self.view addSubview:whatsappbtn];
            [fbsharebtn setHidden:NO];
            [whatsappbtn setHidden:NO];
            [fbsharebtn setNeedsDisplay];
            [whatsappbtn setNeedsDisplay];
          
            
            [UIView animateWithDuration:0.4f
             　　delay:0
             　　options:UIViewAnimationOptionCurveEaseIn
             　　animations:^{
                 　　fbsharebtn.alpha = 1;
                 whatsappbtn.alpha=1;
                 fbsharebtn.frame = CGRectMake(80, sharebtn.frame.origin.y, 80, 80);
                 whatsappbtn.frame = CGRectMake(160, sharebtn.frame.origin.y, 80, 80);
                 
                 　　}
             　　completion:^(BOOL finished) {
                 　　}];
            shareout=true;
            
        }
    }
}
-(void)voterun{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    

    NSLog([[NSString alloc] initWithFormat:@"vote%d", playno]);
    if ([myDelegate.selfid isEqualToString:@"-1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No login"
                                                        message:@"You must login to vote this video."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
        myDelegate.loginmode=@"nomal";

        [self performSelectorOnMainThread:@selector(gotologin) withObject:nil waitUntilDone:YES];
    }else{
        NSLog([[NSString alloc] initWithFormat:@"vote%d", playno]);
        
        int videoidno=(int)[[[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"id"] integerValue];
        
        NSString *voteurl=[[NSString alloc] initWithFormat:@"http://demostandouter.zerouno.it/video/vote?ri=%d&vt=STANDOUT", videoidno];
        
        [myDelegate.manager GET:voteurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *message=[responseObject objectForKey:@"message"];
            message=[self htmltostring:message];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VOTE"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];

           
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"EXIT",nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            return;
        }];

        
    }
    
    
    
}

 */

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
 */


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	return [NSString stringWithFormat:@"Section %i", section];
	
}
 */

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
    [self.tableviewmain setHidden:NO];
    [self.tableviewmain setNeedsDisplay];
    [self.moviePlayer stop];
    [self.moviePlayer.view setHidden:YES];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"mj"]  ;
    //[self hiddencontrol:nil];
    
    //[sharebtn setHidden:YES];
    //[votebtn setHidden:YES];
    if(S==0) S=1;
    
    thread.start;
    thread=nil;
    loadresults=5;
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{

	//  model should call this when its done loading
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableviewmain];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);
    float reload_distance = 10;
    if(y > h + reload_distance) {
        //NSLog(@"load more rows");
        if(!isLoading)
           // [self loadMore];
        {
            NSLog(@"load more rows");
            _refreshFooterView.footertext.text=@"Loading...";
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            [_refreshFooterView.bar setHidesWhenStopped:NO];
            [_refreshFooterView.bar setNeedsDisplay];
            [_refreshFooterView.bar startAnimating];



            isLoading=true;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                [NSThread sleepForTimeInterval:0.75];
                
                if ((totaltresults-loadresults)>5) {
                    loadresults=loadresults+5;
                }else if (totaltresults>loadresults){
                    loadresults=totaltresults;
                }else{
                    loadresults=loadresults;
                }
                
                
                isLoading=true;

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                                        

                    thread = [[NSThread alloc] initWithTarget:self selector:@selector(run2) object:@"mj"]  ;
                    //[self hiddencontrol:nil];
                    
                    if(S==0) S=1;
                    //_refreshFooterView.footertext.text=@"Looded!";
                    
                    thread.start;
                    thread=nil;
                    
                    
                    
                });
            });

          
        }
    }
    
    
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
- (void)viewDidUnload {

	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
    //[super dealloc];
}




-(void) run0{
    
   // NSData *loinstatedate;
    urlstring=[[NSString alloc] initWithFormat:@"%@/login_status.json", myDelegate.webaddress];

    
    [myDelegate.manager GET:urlstring parameters:nil timeoutInterval:5.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"JSON: %@", responseObject);
         int sid=  [[responseObject objectForKey:@"registrationId"] intValue] ;
        NSString *temp=[[NSString alloc] initWithFormat:@"%d", sid];
       myDelegate.selfid= temp;
        temp=nil;
        if ([myDelegate.selfid isEqual:@"-1"]) {
            [APService setTags:nil alias:@"" callbackSelector:nil object:nil];
            
            NSLog(@"nonooooooooo");
            
            
        }else{
            [APService setTags:nil alias:@"" callbackSelector:nil object:nil];
            
            [APService setTags:nil alias:myDelegate.selfid callbackSelector:nil object:nil];
            NSLog(@"nook%@",myDelegate.selfid);
            
        }
       
        NSLog(myDelegate.selfid);
        if ([[responseObject objectForKey:@"status"] isEqual:@"ok"] ) {
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"login"] forKey:@"log"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:dictionary];
            dictionary=nil;
            if ([[responseObject objectForKey:@"authenticated"] integerValue]==1 ){
                NSLog(@"loadnoti");
                [self loadnoti];
            }else{
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"logout"] forKey:@"log"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:dictionary];
                [self logout];
                dictionary=nil;

            }

        }else{
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"logout"] forKey:@"log"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:dictionary];
            [self logout];
            dictionary=nil;
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self performSelectorOnMainThread:@selector(interneterror) withObject:nil waitUntilDone:YES];
        
        return;
    }];
    
    
    
   
    thread0=nil;

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //將按鈕的Title當作判斷的依據
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"EXIT"]) {
        exit(0);
    }
    
    
    
}

-(void)onClickImage:(NSString *)string{
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer dealloc2];
    self.moviePlayer=nil;

    [self playerinit];
    // here, do whatever you wantto do
    NSLog(@"imageview is clicked!");
    [self.tableviewmain setHidden:YES];
    [self.moviePlayer.view setHidden:NO];
    [self.moviePlayer.view setNeedsDisplay];
    NSString *videourl =nil;
    NSString *briefvideocode;
    briefvideocode =[briefJSON objectForKey:@"spotVideoUrl"] ;
    if (S==1||S==0) {
        briefvideocode =@"RAIL0cx5";
    }

    videourl =[NSString stringWithFormat: @"http://content.bitsontherun.com/videos/%@-480.mp4",  briefvideocode];
   // videourl=[ NSString stringWithFormat:@"file://%@/Documents/mergeVideo-1.mov",NSHomeDirectory()];
    NSLog(videourl);
    /************hi from here********************/
    
    [self.moviePlayer.view setHidden:NO];
    [self.moviePlayer.view setNeedsDisplay];
    [self.moviePlayer setstandouter:NO videoid:nil videotitle:nil ownerid2:nil hengjson:nil];

    //set contentURL (this will automatically start playing the movie)
    [self.moviePlayer setContentURL:[NSURL URLWithString:videourl]];
    
    if (!self.moviePlayer.isFullscreen) {
        playery=100;

        [self.moviePlayer setFrame:(CGRect){0, 100, 320, 180}];
        //"frame" is whatever the movie player's frame should be at that given moment
    }
    [self.moviePlayer prepareToPlay];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.tableviewmain setScrollEnabled:NO];
    playintflag=true;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        while (![self.moviePlayer isPreparedToPlay]) {
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            playintflag=false;
            [self.tableviewmain setScrollEnabled:YES];
            
            
            // [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });


}

- (void)run:(NSString *)string {
    NSLog(@"run");
    resultJSON=nil;
    briefJSON=nil;
  
    NSError *error=nil;
    NSData *data=nil;
    NSData *briefdata=nil;
    NSData *conlistdata=nil;
    NSData *chanlistdata=nil;

   // NSLog([[NSString alloc] initWithFormat:@"%d", S]);
    if(S!=0){
        
        
        
        
       data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
       briefdata=[NSData dataWithContentsOfURL:briefurl options:NSDataReadingUncached error:&error];
       
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"EXIT",nil];
            [alert show];
            alert=nil;
            

        }
       

    }else{
        
        if (!iniflag) {
            FileOps *readFile = [[FileOps alloc] init];
            
            
            BOOL fe=[readFile fileexits:@"mytextfile.txt"]&&[readFile fileexits:@"mytextfile2.txt"]&&[readFile fileexits:@"mytextfile3.txt"]&&[readFile fileexits:@"mytextfile4.txt"];
            if (fe) {
                
                NSLog(@"TRUE");
                NSString *myJsonString=[readFile readFromFile:@"mytextfile.txt"];
                //NSLog(myJsonString);
                data=[myJsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSString * myJsonString2=[readFile readFromFile:@"mytextfile2.txt"];
                briefdata=[myJsonString2 dataUsingEncoding:NSUTF8StringEncoding];
                NSString * myJsonString3=[readFile readFromFile:@"mytextfile3.txt"];
                chanlistdata=[myJsonString3 dataUsingEncoding:NSUTF8StringEncoding];
                NSString * myJsonString4=[readFile readFromFile:@"mytextfile4.txt"];
                conlistdata=[myJsonString4 dataUsingEncoding:NSUTF8StringEncoding];
                
                myDelegate.channellistjson=[NSJSONSerialization JSONObjectWithData:chanlistdata options:kNilOptions error:&error];
                myDelegate.contestlistjson=[NSJSONSerialization JSONObjectWithData:conlistdata options:kNilOptions error:&error];
                
                myJsonString=nil;
                myJsonString2=nil;
                myJsonString3=nil;
                myJsonString4=nil;

                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:nil];//更新列表
                
                
                
                
                
            }else{
                NSLog(@"FALSE");
                
                myDelegate.contextname=@"freestyle";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];
                
                data = [NSData dataWithContentsOfURL:url];
                briefdata=[NSData dataWithContentsOfURL:briefurl];
                
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/channellist?ps=25", myDelegate.webaddress];
                chanlistdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring] options:NSDataReadingUncached error:&error];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestlist?ps=25", myDelegate.webaddress];
                conlistdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring] options:NSDataReadingUncached error:&error];
                
                [readFile WriteToStringFile:[[NSString alloc] initWithData:chanlistdata encoding:NSUTF8StringEncoding] andname:@"mytextfile3.txt"];
                [readFile WriteToStringFile:[[NSString alloc] initWithData:conlistdata encoding:NSUTF8StringEncoding] andname:@"mytextfile4.txt"];
                
                
                
                myDelegate.channellistjson=[NSJSONSerialization JSONObjectWithData:chanlistdata options:kNilOptions error:&error];
                myDelegate.contestlistjson=[NSJSONSerialization JSONObjectWithData:conlistdata options:kNilOptions error:&error];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:nil];//更新列表
                
                
                
            }
           
            fe=nil;
            readFile=nil;
        }
        
    }
    if (S==1) {
        FileOps *readFile = [[FileOps alloc] init];
        [readFile WriteToStringFile:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] andname:@"mytextfile.txt"];
        [readFile WriteToStringFile:[[NSString alloc] initWithData:briefdata encoding:NSUTF8StringEncoding] andname:@"mytextfile2.txt"];
        
        urlstring=[[NSString alloc] initWithFormat:@"%@/contest/channellist?ps=25", myDelegate.webaddress];
        chanlistdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring] options:NSDataReadingUncached error:&error];
        urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestlist?ps=25", myDelegate.webaddress];
        conlistdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring] options:NSDataReadingUncached error:&error];
        
        [readFile WriteToStringFile:[[NSString alloc] initWithData:chanlistdata encoding:NSUTF8StringEncoding] andname:@"mytextfile3.txt"];
        [readFile WriteToStringFile:[[NSString alloc] initWithData:conlistdata encoding:NSUTF8StringEncoding] andname:@"mytextfile4.txt"];
        
        
        
        myDelegate.channellistjson=[NSJSONSerialization JSONObjectWithData:chanlistdata options:kNilOptions error:&error];
        myDelegate.contestlistjson=[NSJSONSerialization JSONObjectWithData:conlistdata options:kNilOptions error:&error];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:nil];//更新列表

        
        

        readFile=nil;
    }
    if(data==nil||briefurl==nil){
        [self performSelectorOnMainThread:@selector(interneterror) withObject:nil waitUntilDone:YES];

        return;
        

    }
    conno=[[myDelegate.contestlistjson objectForKey:@"total"] integerValue]+[[myDelegate.channellistjson objectForKey:@"total"]integerValue]+3;

    resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    briefJSON = [NSJSONSerialization JSONObjectWithData:briefdata options:kNilOptions error:&error];
    myDelegate.briefjson=briefJSON;
    NSString* imgstring=[briefJSON objectForKey:@"backgroundImageUrlMobile"];
    urlstring=[[NSString alloc] initWithFormat:@"%@%@", myDelegate.webaddress,imgstring];
    
    NSLog(urlstring);
    [self.header setImageWithURL:[NSURL URLWithString:urlstring] ];
    
    
    [self performSelectorOnMainThread:@selector(run2) withObject:nil waitUntilDone:YES];
    //NSLog(resultJSON);
    data=nil;
    briefdata=nil;
    conlistdata=nil;
    chanlistdata=nil;
    urlstring=nil;
    
}
-(void)interneterror{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                    message:@"You must be connected to the internet to use this app."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"EXIT",nil];
    [alert show];

}
-(void)run2{
    
    

   
    if (isLoading) {
        isLoading=false;
    }
    totaltresults=[[resultJSON objectForKey:@"totalResults"] integerValue];
    NSLog(@"s%d",totaltresults);
    [self.tableviewmain reloadData];

    if (menuleftflag) {
        [self.tableviewmain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        menuleftflag=false;

    }
    if (totaltresults<3) {
        [_refreshFooterView removeFromSuperview];
        [ MBProgressHUD hideHUDForView:self.view animated:YES];

    }else{
        
		//CGRect footerRect = CGRectMake(0, 0, 320, 80);
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"footerview" owner:self options:nil];
        
        
        footerview *view =[nib objectAtIndex:0];
        
		self.tableviewmain.tableFooterView=view;
		_refreshFooterView = self.tableviewmain.tableFooterView;
        totaltresults=[[resultJSON objectForKey:@"totalResults"] integerValue];
        
        if (totaltresults==loadresults) {
            _refreshFooterView.footertext.text=@"all loaded";
        }else{
            _refreshFooterView.footertext.text=@"Load more...";
        }
        //  [_refreshFooterView setBackgroundColor:[UIColor blackColor]];
        [_refreshFooterView.bar setHidesWhenStopped:YES];
		nib=nil;
        view=nil;
        [ MBProgressHUD hideHUDForView:self.view animated:YES];

    }
    
    

    // [_refreshFooterView setFrame:CGRectMake(0.0f, self.tableviewmain.contentSize.height-80, self.view.frame.size.width, 80)];
    
    
    
    //FileOps *files = [[FileOps alloc] init];
    //[files WriteToStringFile:[ [NSString stringWithUTF8String:[briefdata bytes]] mutableCopy ] andname:@"mytextfile2.txt"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"WARNING ZHANG");
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //totaltresults=[[resultJSON objectForKey:@"totalResults"] integerValue];
    if (totaltresults<=5) {
       loadresults=totaltresults;
        [_refreshFooterView removeFromSuperview];
        _refreshFooterView = nil;
    }
    NSLog(@"as%d",totaltresults);
    
    return loadresults;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = NO;
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
                NSString *ownername=[[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerName"];
            NSString *ownersurname=[[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerSurname"];
            [cell.namebtn setTitle:[NSString stringWithFormat: @"%@ %@", ownername, ownersurname] forState:UIControlStateNormal] ;
            //[cell.namebtn.titleLabel setFont:[UIFont fontWithName:@"Bebas" size:20]];
            [cell.namebtn addTarget:self  action:@selector(gotoprofile:)  forControlEvents:UIControlEventTouchUpInside];
            [cell.namebtn setTag:indexPath.row];
    
    UIFont *newFont =[UIFont fontWithName:@"Oswald-Regular" size:24 ];
           [cell.namebtn setFont:newFont];
    //cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
            cell.prepTimeLabel.text = [[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.prepTimeLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:12.f]];
            //[cell.prepTimeLabel setFont:[UIFont fontWithName:@"Bebas" size:13]];
            int vidno=(int)[[[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerId"] integerValue];
            NSString *temp=[[NSString alloc] initWithFormat:@"%d", vidno];
            cell.cellvid=temp;
    
            temp=nil;

            // cell.cellvid=[[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerName"];
            int votecont=(int)[[[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"votesCount"] integerValue];
            temp=[[NSString alloc] initWithFormat:@"%d", votecont];

            cell.votecont.text=temp;
           [cell.votecont setFont:[UIFont fontWithName:@"Oswald-Bold" size:20]];
            temp=nil;
            //cell.nameLabel.textColor=[UIColor whiteColor];
            cell.prepTimeLabel.textColor=[UIColor whiteColor];
            NSString *imageurl = [[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"imageUrl480"];
            [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString: imageurl ]];
            [cell setBackgroundColor:[UIColor blackColor]];
    
    ownername=nil;
    ownersurname=nil;
    temp=nil;
    imageurl=nil;


    if (votecont==0) {
        cell.votecont.alpha=0;
    }else{
        cell.votecont.alpha=1;
    }
    
    
    return cell;

    
}
-(void) gotoprofile3: (NSNotification*) aNotification
{
    
    if (playintflag) {
        return;
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSDictionary *theData = [aNotification userInfo];
            NSInteger showbriefno=0;
            showbriefno= [[theData objectForKey:@"row"] intValue];
            
            
            
            
            [self.moviePlayer stop];
            [self.moviePlayer.view removeFromSuperview];
           
            [self playerinit];
            //  [self hiddencontrol:nil];
            [self.moviePlayer dealloc2];
            self.moviePlayer=nil;
            
            
            
            NSInteger ownerid=[[[[notijson objectForKey:@"items"] objectAtIndex:showbriefno] objectForKey:@"authorId"] integerValue];
            NSString *temp=[[NSString alloc] initWithFormat:@"%d", ownerid];
            myDelegate.profileid=temp;
            temp=nil;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SWRevealViewController *profileview= [storyboard instantiateViewControllerWithIdentifier:@"profileview"];
            //profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
            profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:profileview animated:YES completion:nil];
            storyboard=nil;
            profileview=nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
            });
        });
    
  
    }
    
    //[ self.revealViewController setFrontViewController:profileview];
    //[ self.revealViewController setRightViewController:profileview];
}


-(void) gotoprofile1{
    if (playintflag) {
        return;
    }
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer=nil;
    //  [self hiddencontrol:nil];
    
    
    
    
   // NSInteger ownerid=[[[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"ownerId"] integerValue];
   //NSString *temp=[[NSString alloc] initWithFormat:@"%d", ownerid];
    //myDelegate.profileid=temp;
  //  temp=nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *profileview= [storyboard instantiateViewControllerWithIdentifier:@"profileview"];
    //profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:profileview animated:YES completion:nil];
    storyboard=nil;
    profileview=nil;
    //[ self.revealViewController setFrontViewController:profileview];
    //[ self.revealViewController setRightViewController:profileview];
}
-(void) gotoprofile:(UIButton *)sender{
    if (playintflag) {
        return;
    }
    [self.moviePlayer stop];
    [self.moviePlayer.view setHidden:YES];
    [self.moviePlayer dealloc2];
    self.moviePlayer=nil;
    
  //  [self hiddencontrol:nil];

    

    NSLog(@"tag number is = %d",[sender tag]);
    //In this case the tag number of button will be same as your cellIndex.
    // You can make your cell from this.
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    SimpleTableCell *cell = [self.tableviewmain cellForRowAtIndexPath:indexPath];
    
    myDelegate.profileid= cell.cellvid;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *profileview= [storyboard instantiateViewControllerWithIdentifier:@"profileview"];
    //profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:profileview animated:YES completion:nil];
    storyboard=nil;
    profileview=nil;
       //[ self.revealViewController setFrontViewController:profileview];
    //[ self.revealViewController setRightViewController:profileview];
}

-(void) gotologin{
    
    
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
   
    self.moviePlayer = nil;
    // [self hiddencontrol:nil];
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *profileview= [storyboard instantiateViewControllerWithIdentifier:@"loginview"];
    //profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:profileview animated:YES completion:nil];
    storyboard=nil;
    profileview=nil;
    //[ self.revealViewController setFrontViewController:profileview];
    //[ self.revealViewController setRightViewController:profileview];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer=nil;

    [self playerinit];
        //该方法响应列表中行的点击事件
    CGRect rectInTableView=[tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
    NSString *videourl = [[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"videoUrl480"];
    
   // NSLog([[NSString alloc] initWithFormat:@"%f", rectInSuperview.origin.y]);
    
    if (rectInSuperview.origin.y<100) {
        
        [tableView setContentOffset:CGPointMake(0, indexPath.row*180) animated:YES];
        rectInSuperview =  CGRectMake(0, 100, 80, 80);
       // NSLog([[NSString alloc] initWithFormat:@"hi+%f", rectInSuperview.origin.y]);

        
    }
  
    [self.moviePlayer setContentURL:[NSURL URLWithString:videourl]];
    
    if (!self.moviePlayer.isFullscreen) {
        playery=rectInSuperview.origin.y;
        [self.moviePlayer setFrame:(CGRect){0, playery, 320, 180}];
        //"frame" is whatever the movie player's frame should be at that given moment
        [self.moviePlayer.view setHidden:NO];
        [self.moviePlayer.view setNeedsDisplay];
        
        [self.view bringSubviewToFront:self.moviePlayer.view];
        

    }
    
    [self.moviePlayer prepareToPlay];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // [self.tableviewmain setScrollEnabled:NO];
   // playintflag=true;


    
   
   

    playno=(NSInteger *)indexPath.row;
    myDelegate.playno=playno;
    int videoidno=(int)[[[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"id"] integerValue];
    
    NSString *videotitle= [[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"title"];
    NSInteger ownerid=[[[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"ownerId"] integerValue];

    [self.moviePlayer setstandouter:YES videoid:videoidno videotitle:videotitle ownerid2:ownerid hengjson:resultJSON];

    
   
}



- (void) loadtableview: (NSNotification*) note
{
    loadresults=5;
    NSDictionary *theData = [note userInfo];
    urlstring=nil;
    url=nil;
    briefurl=nil;
    if (theData != nil) {
        S = [[theData objectForKey:@"row"] intValue];
       [[SDImageCache sharedImageCache] clearDisk];
       [[SDImageCache sharedImageCache] clearMemory];
        
        NSLog(@"%d",conno);
       // [self.tableviewmain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        
        if (S==0) {
            
            if ([myDelegate.selfid isEqualToString:@"-1"]) {
                myDelegate.loginmode=@"nomal";
                [self performSelectorOnMainThread:@selector(gotologin) withObject:nil waitUntilDone:YES];
            }else{
                myDelegate.profileid= myDelegate.selfid;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SWRevealViewController *profileview= [storyboard instantiateViewControllerWithIdentifier:@"profileview"];
                
                profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:profileview animated:YES completion:nil];
                storyboard=nil;
                profileview=nil;
                //[self.navigationController  pushViewController:profileview animated:YES];
            }
            myDelegate.page1page=@"1";
            


        }
        
        if (S==conno-1) {
            
            logoutthread = [[NSThread alloc] initWithTarget:self selector:@selector(logout) object:nil];
            logoutthread.start;
            logoutthread=nil;
            NSLog(@"LOGOU");

        }else{
            
            /*
            urlstring=[[NSString alloc] initWithFormat:@"%@header.png", myDelegate.contextname];

            NSLog(urlstring);
            [self.header setImage: [UIImage imageNamed:urlstring]];
            */
            //myDelegate.page1page=@"1";
            //myDelegate.contextname=@"freestyle";
            urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
            url = [NSURL URLWithString:urlstring];
            urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
            briefurl=[NSURL URLWithString:urlstring];
            
            


        }
        /*
        switch (S) {
            case 0:
                
                if ([myDelegate.selfid isEqualToString:@"-1"]) {
                    myDelegate.loginmode=@"nomal";
                    [self performSelectorOnMainThread:@selector(gotologin) withObject:nil waitUntilDone:YES];
                }else{
                    myDelegate.profileid= myDelegate.selfid;
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SWRevealViewController *profileview= [storyboard instantiateViewControllerWithIdentifier:@"profileview"];
                    
                    profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
                    [self presentViewController:profileview animated:YES completion:nil];
                    //[self.navigationController  pushViewController:profileview animated:YES];
                }
                
                [self.header setImage: [UIImage imageNamed:@"standouterheader.png" ]];
                myDelegate.contextname=@"freestyle";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];

                myDelegate.page1page=@"1";
                
                break;
            case 1:
                [self.header setImage: [UIImage imageNamed:@"standouterheader.png" ]];
                
                myDelegate.page1page=@"1";
                myDelegate.contextname=@"freestyle";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];


                break;
            case 2:
                [self.header setImage: [UIImage imageNamed:@"tuborgheader.png" ]];
                 myDelegate.page1page=@"2";
                myDelegate.contextname=@"tuborg";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];

                break;
            case 3:
                [self.header setImage: [UIImage imageNamed:@"universalheader.png" ]];
                
                myDelegate.page1page=@"3";
                myDelegate.contextname=@"universal";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];



                break;
            case 4:
                [self.header setImage: [UIImage imageNamed:@"goandfunheader.png" ]];
                myDelegate.page1page=@"4";
                myDelegate.contextname=@"goandfun";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];


                break;
            case 5:
                [self.header setImage: [UIImage imageNamed:@"volagratisheader.png" ]];
                myDelegate.page1page=@"5";
                myDelegate.contextname=@"volagratis";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];
              
                
                //self.menuleftmainbtn.imageView.image=[UIImage imageNamed:@"menublack.png"];
               // self.menurightmainbtn.imageView.image=[UIImage imageNamed:@"uploadb2.png"];
                
                
                break;

            case 6:
                [self.header setImage: [UIImage imageNamed:@"whoodrooklynheader.png" ]];
               myDelegate.page1page=@"6";
                myDelegate.contextname=@"whoodbrooklyn";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];

                

                break;
            case 7:
                [self.header setImage: [UIImage imageNamed:@"metroheader.png" ]];
                
                myDelegate.page1page=@"7";
                myDelegate.contextname=@"cityselfie";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];


                break;
            case 8:
                [self.header setImage: [UIImage imageNamed:@"metroheader.png" ]];
                 myDelegate.page1page=@"8";
                myDelegate.contextname=@"metro";
                urlstring=[[NSString alloc] initWithFormat:@"%@/video/search?ss=contest&so=most_recent&sp=%@", myDelegate.webaddress,myDelegate.contextname];
                url = [NSURL URLWithString:urlstring];
                urlstring=[[NSString alloc] initWithFormat:@"%@/contest/contestinfo?cc=%@", myDelegate.webaddress,myDelegate.contextname];
                briefurl=[NSURL URLWithString:urlstring];

                
                break;
            case 9:
                
                logoutthread = [[NSThread alloc] initWithTarget:self selector:@selector(logout) object:nil];
                logoutthread.start;
                logoutthread=nil;
               // myDelegate.page1page=@"5";

                break;

                
                
            default:
                //myDelegate.page1page=@"-1";

                break;
        }
         */
         mainpage=0;
        [self.tableviewmain setHidden:NO];
        [self.tableviewmain setNeedsDisplay];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        [self.moviePlayer dealloc2];
        self.moviePlayer=nil;
        
       
        
        if (S!=conno-1&&S!=0) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"mj"]  ;
            // [self hiddencontrol:nil];
            
            
            
            [ thread start];
            thread=nil;

        }
        
    }
}
/*
-(void)showcontrol:(NSNotification*)notification
{
    ALMoviePlayerController *movieController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:movieController];
    //[movieController release]; //释放资源

    if (mainpage!=0||[myDelegate.page isEqual:@"2"]) {
        [self hiddencontrol:nil];

        return;
    }
    [self.view addSubview:sharebtn];
    [self.view addSubview:votebtn];

    [sharebtn setHidden:NO];
    [sharebtn setNeedsDisplay];
    [votebtn setHidden:NO];
    [votebtn setNeedsDisplay];
    sharebtn.alpha=sharebtn.alpha;
    sharebtn.frame = CGRectMake(sharebtn.frame.origin.x, sharebtn.frame.origin.y, 80, 80);
    votebtn.frame = CGRectMake(votebtn.frame.origin.x, votebtn.frame.origin.y, 80, 80);
    votebtn.alpha=votebtn.alpha;

    [UIView animateWithDuration:0.4f
     　　delay:0
     　　options:UIViewAnimationOptionCurveEaseIn
     　　animations:^{
         　　sharebtn.alpha = 1;
            votebtn.alpha=1;
            sharebtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 80, 80);
            votebtn.frame = CGRectMake(320-80, votebtn.frame.origin.y, 80, 80);

         　　}
     　　completion:^(BOOL finished) {
         　　}];
    
}
-(void)hiddencontrol:(NSNotification*)notification
{
    ALMoviePlayerController *movieController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:movieController];
    //[movieController release]; //释放资源
    if (mainpage!=0) {
        [sharebtn setHidden:YES];
        [votebtn setHidden:YES];
        return;
    }
    sharebtn.alpha=sharebtn.alpha;
    sharebtn.frame = CGRectMake(sharebtn.frame.origin.x, sharebtn.frame.origin.y, 80, 80);
    votebtn.frame = CGRectMake(votebtn.frame.origin.x, votebtn.frame.origin.y, 80, 80);
    votebtn.alpha=votebtn.alpha;

    
    [UIView animateWithDuration:0.4f
     　　delay:0
     　　options:UIViewAnimationOptionCurveEaseOut
     　　animations:^{
         　　sharebtn.alpha = 0;
         votebtn.alpha=0;
         sharebtn.frame = CGRectMake(-80, sharebtn.frame.origin.y, 80, 80);
         votebtn.frame = CGRectMake(320, votebtn.frame.origin.y, 80, 80);
         
         　　}
     　　completion:^(BOOL finished) {
         　　}];
    
    
    
    if (shareout) {
        
        [UIView animateWithDuration:0.4f
         　　delay:0
         　　options:UIViewAnimationOptionCurveEaseIn
         　　animations:^{
             　　fbsharebtn.alpha = 0;
             whatsappbtn.alpha=0;
             fbsharebtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 80, 80);
             whatsappbtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 80, 80);
             
             　　}
         　　completion:^(BOOL finished) {
             [fbsharebtn setHidden:YES];
             [whatsappbtn setHidden:YES];
             　　}];
        shareout=false;
        
    }
   

    //[sharebtn setHidden:YES];
    //[votebtn setHidden:YES];
    
   
}
*/
-(void)movieFinish:(NSNotification*)notification
{
    
    //ALMoviePlayerController *movieController = [notification object];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:movieController];
    NSLog(@"FINISH");
    //[movieController release]; //释放资源
  // [movieController.view setHidden:YES];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer dealloc2];
    self.moviePlayer=nil;

    if (pagechange==true ||[myDelegate.page isEqual:@"2"]) {
        return;
    }
    
    /*
    [self.view addSubview:sharebtn];
    [self.view addSubview:votebtn];
    
    
    [sharebtn setHidden:NO];
    [sharebtn setNeedsDisplay];
    [votebtn setHidden:NO];
    [votebtn setNeedsDisplay];
    sharebtn.alpha=sharebtn.alpha;
    sharebtn.frame = CGRectMake(sharebtn.frame.origin.x, sharebtn.frame.origin.y, 80, 80);
    votebtn.frame = CGRectMake(votebtn.frame.origin.x, votebtn.frame.origin.y, 80, 80);
    votebtn.alpha=votebtn.alpha;
    
    [UIView animateWithDuration:0.4f
     　　delay:0
     　　options:UIViewAnimationOptionCurveEaseIn
     　　animations:^{
         　　sharebtn.alpha = 1;
         votebtn.alpha=1;
         sharebtn.frame = CGRectMake(0, sharebtn.frame.origin.y, 80, 80);
         votebtn.frame = CGRectMake(320-80, votebtn.frame.origin.y, 80, 80);
         
         　　}
     　　completion:^(BOOL finished) {
         
         　　}];
    */
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.moviePlayer stop];
    [self.moviePlayer dealloc2];
    if (![self.moviePlayer.view isHidden]) {
        [self.moviePlayer.view setHidden:YES];
        [self.moviePlayer dealloc2];

        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer=nil;

    }
    

    
    
    
   // [self hiddencontrol:nil];

}

-(void)logout{
    
    
    [APService setTags:nil alias:@"" callbackSelector:nil object:nil];

    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:myDelegate.webaddress]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    NSDictionary *parameters = @{@"json_response":@"true"};
    urlstring=[[NSString alloc] initWithFormat:@"%@/logout", myDelegate.webaddress];
    [myDelegate.manager GET:urlstring parameters:parameters timeoutInterval:5.0f success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"JSON: %@", responseObject);
        [myDelegate.manager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
        //myDelegate.manager = [AFHTTPRequestOperationManager manager];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self performSelectorOnMainThread:@selector(interneterror) withObject:nil waitUntilDone:YES];
        
        return;
        

    }];
    myDelegate.selfid=@"-1";
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"logout"] forKey:@"log"];
    [self performSelectorOnMainThread:@selector(fblogout) withObject:nil waitUntilDone:YES];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagefoto" object:nil userInfo:dictionary];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    dictionary=nil;
    
}

-(void) fblogout{
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    
}

-(NSString *)htmltostring:(NSString*)briefdescription{
       NSRange range;
    briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"Ã" withString:@"à"];
    briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"Ã¨" withString:@"è"];

    briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
       briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
        briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        while ((range = [briefdescription rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            briefdescription = [briefdescription stringByReplacingCharactersInRange:range withString:@""];
        
    
    return briefdescription;
}

- (void) showbrief: (NSNotification*) aNotification
{
    if (playintflag) {
        return;
    }
    
    
    NSDictionary *theData = [aNotification userInfo];
    NSInteger showbriefno=0;
    NSString *briefdescription;
    // NSString *videourl =nil;
    NSString *briefimageurl;
    NSString *briefvideocode;
    NSRange range;
    showbriefno= [[theData objectForKey:@"row"] intValue];
    NSLog(@"showbrief");

    if(showbriefno==mainpage)
    {
        pagechange=false;
        return;
    }
    else
        pagechange=true;
    
    NSLog(@"showbrief2");
   /*
    sharebtn.frame = CGRectMake(0, 150, 80, 80);
    votebtn.frame = CGRectMake(320-80, 150, 80, 80);

    [sharebtn setHidden:YES];
    [votebtn setHidden:YES];
    
    */
    [self.tableviewmain setHidden:NO];
    [self.tableviewmain setNeedsDisplay];
    [self.moviePlayer stop];
    [self.moviePlayer.view setHidden:YES];
   

    
    
   
    if (theData != nil) {
        
        switch (showbriefno) {
            case 0:
            {
                NSLog(@"Case 0");
            }
                mainpage=0;
                break;
            case 1:
            {
                NSLog(@"Case 1");
                mainpage=1;
                /*
                 sharebtn.frame = CGRectMake(0, 150, 80, 80);
                 votebtn.frame = CGRectMake(320-80, 150, 80, 80);
                 */
                [self.tableviewmain setHidden:YES];
                
                briefvideocode =[briefJSON objectForKey:@"spotVideoUrl"] ;
                if ([myDelegate.contextname isEqualToString:@"freestyle"]) {
                    briefvideocode =@"RAIL0cx5";
                }
                //videourl =[NSString stringWithFormat: @"http://content.bitsontherun.com/videos/%@-480.mp4",  briefvideocode];
                briefimageurl = [NSString stringWithFormat: @"http://content.bitsontherun.com/thumbs/%@-480.jpg",  briefvideocode ];
                
                
                /************hi from here********************/
                
                [self.briefvideoimg setImageWithURL:[NSURL URLWithString:briefimageurl]];
                
                
                briefdescription=[briefJSON objectForKey:@"description"];
                NSLog(@"zz1");
                
                if ([briefdescription isKindOfClass:[NSNull class]]) {
                    briefdescription=@"...";
                    NSLog(@"zz2");
                    
                }
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[briefdescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                NSLog(@"zz");
                /*
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                 
                 
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                 
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                 briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                 
                 while ((range = [briefdescription rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                 briefdescription = [briefdescription stringByReplacingCharactersInRange:range withString:@""];
                 */
                
               [self.brieftext setTextColor:[UIColor whiteColor]];

                
                self.brieftext.attributedText=attributedString;
                 [self.brieftext setFont:[UIFont fontWithName:@"Oswald-Light" size:16]];
               // [self.brieftext setTextColor:[UIColor whiteColor]];
                //self.brieftext.text=[briefJSON objectForKey:@"description"] ;
                // [self.moviePlayer.view setHidden:NO];
                // [self.moviePlayer.view setNeedsDisplay];
                // [self.view addSubview:self.moviePlayer.view];
                //set contentURL (this will automatically start playing the movie)
                //[self.moviePlayer setContentURL:[NSURL URLWithString:videourl]];
                
            }
                
                
                break;
                
            case 2:
            {
                NSLog(@"Case 2");
            }
                
                [self gotoupload];
                
                
                break;
                
           
        }
        
    }

}

-(void)gotoupload{
   
    
    if ([myDelegate.selfid isEqualToString:@"-1"]) {
        myDelegate.loginmode=@"nomal";
        
        [self performSelectorOnMainThread:@selector(gotologin) withObject:nil waitUntilDone:YES];
    }else{
        //  [self performSelectorOnMainThread:@selector(gotoupload) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *leggepage= [storyboard instantiateViewControllerWithIdentifier:@"uploadpage"];
            //profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
            
            
            leggepage.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
            storyboard=nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                
                [self presentViewController:leggepage animated:YES completion:nil];
                
                
            });
        });
        
        mainpage=3;
        
    }
}

/*

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
 
    //宣告一個UIDevice指標，並取得目前Device的狀況
    // Return YES for supported orientations
   // return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft); // 只支持向左横向, YES 表示支持所有方向
 
    　　NSLog(@"视图旋转完成之后自动调用");
    
    UIDevice *device = [UIDevice currentDevice] ;
    
    //取得當前Device的方向，來當作判斷敘述。（Device的方向型態為Integer）
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"螢幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"螢幕朝下平躺");
            
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"螢幕向左橫置");
            
        self.textview.frame=CGRectMake(320, 20, 248, 300);
         self.brieftext.frame=CGRectMake(10, 20, 228, 270);
         //  self.view.frame=CGRectMake(0, 0, 568, 320);
            //[self.view setBackgroundColor:[UIColor blackColor]];
         //  self.tableviewmain.frame=CGRectMake(0, 100, 320, 220);
            //self.brieftext.frame=CGRectMake(320, -260, 248, 300);
            
           // [MBProgressHUD hideHUDForView: self.view animated:YES];
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"螢幕向右橫置");
            
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"螢幕直立");
        self.textview.frame=CGRectMake(0, 280, 200, 288);
        self.brieftext.frame=CGRectMake(0, 10, 320, 270);
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"螢幕直立，上下顛倒");
            
            break;
            
        default:
            NSLog(@"無法辨識");
            break;
    }

}
 */
-(void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    　　switch (orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"螢幕朝上平躺");
          

            oristate=@"螢幕朝上平躺";
            
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"螢幕朝下平躺");
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
            
            //[self.moviePlayer setFullscreen:YES animated:YES];
            self.moviePlayer.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
            // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 500)];
            
            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, self.view.frame.size.height,self.view.frame.size.width)];
            
            if ([oristate isEqual:@"螢幕朝下平躺"]) {
                ;
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];
            
            oristate=@"螢幕朝下平躺";

            
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
            
            //[self.moviePlayer setFullscreen:YES animated:YES];
            self.moviePlayer.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
            // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 500)];
            
            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, self.view.frame.size.height,self.view.frame.size.width)];
            
            if ([oristate isEqual:@"未知方向"]) {
                ;
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];
            
            oristate=@"未知方向";
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"螢幕向左橫置");
           
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
            
            //[self.moviePlayer setFullscreen:YES animated:YES];
            self.moviePlayer.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
           // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 500)];

            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, self.view.frame.size.height,self.view.frame.size.width)];
            
            if ([oristate isEqual:@"螢幕向左橫置"]) {
                ;
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];

            oristate=@"螢幕向左橫置";

            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"螢幕向右橫置");
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(-90 * M_PI / 180.0);

            self.moviePlayer.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
            // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 500)];
            
            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, self.view.frame.size.height,self.view.frame.size.width)];
            
            if ([oristate isEqual:@"螢幕向右橫置"]) {
                ;
            }else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];

            oristate=@"螢幕向右橫置";

            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"螢幕直立");

            [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];


            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(0 * M_PI / 180.0);
           // self.moviePlayer.view.frame=CGRectMake(0, playery, 320, 180);
            [self.moviePlayer setFrame:CGRectMake(0, playery, 320, 180)];
            if ([oristate isEqual:@"螢幕直立"]) {
                ;
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];
            oristate=@"螢幕直立";

            
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"螢幕直立，上下顛倒");
            NSLog(@"螢幕直立，上下顛倒");
            
            
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(0 * M_PI / 180.0);
            // self.moviePlayer.view.frame=CGRectMake(0, playery, 320, 180);
            [self.moviePlayer setFrame:CGRectMake(0, playery, 320, 180)];
            if ([oristate isEqual:@"螢幕直立，上下顛倒"]) {
                ;
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];
            oristate=@"螢幕直立，上下顛倒";
            
            break;
            
        default:
            NSLog(@"無法辨識");
            break;
    }
    
    


    
}




@end
