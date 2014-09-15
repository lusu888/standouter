//
//  Profileview.m
//  standouter2
//
//  Created by zhang on 18/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "Profileview.h"
#import "menurightmain.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "infoview.h"
#import "UIImageView+WebCache.h"
#import "SimpleTableCell.h"
#import "ALMoviePlayerController/ALMoviePlayerController.h"
#import "FileOps.h"
#import "AFHTTPRequestOperationManager.h"
#import "fanco.h"
#import "newstable.h"
#import "playerpage.h"
#import "CollectionCell.h"




@interface Profileview ()
@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;

@end

@implementation Profileview{
    NSString *uid;
    NSThread *getinfothread;
    NSThread *portfoliothread;
    NSThread *playlistthread;
    NSThread *fansthread;
    NSThread *newsthread;
    NSDictionary *infoJSON;
    NSDictionary *fansJson;
    NSDictionary *prolistjson;
    NSDictionary *newsJson;
    infoview *info;
    int S;
    
    BOOL pagechange;
    int mainpage;

    fanco *fansco;
    NSThread *logoutthread;
    AppDelegate *myDelegate;
    NSInteger *playno;
    
    newstable *newstableview;
    float playery;
    NSString *oristate;
    NSString *urlstring;
    

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CollectionCell";
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        //cell = [[[MultipleCell alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
    }
    //点击后背景图片
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:180];
    NSString *fansid = [[[fansJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"profileImageUrl"];
   
    NSString *url=[NSString stringWithFormat: @"%@%@", myDelegate.webaddress, fansid];
    

    [recipeImageView setImageWithURL:[NSURL URLWithString: url ]];

    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[fansJson objectForKey:@"total"] integerValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog([[NSString alloc] initWithFormat:@"%d", indexPath.row]);
    int vidno=(int)[[[[fansJson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
    NSString *vidnos=[[NSString alloc] initWithFormat:@"%d", vidno];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: vidnos forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_fanchoose" object:nil userInfo:dictionary];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger totaltresults=[[prolistjson objectForKey:@"totalResults"] integerValue];
    if (totaltresults>5) {
        //  totaltresults=5;
    }
    
    return totaltresults;
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
    
    
    
    NSString *imageurl = [[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"imageUrl480"];
    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString: imageurl ]];
    NSString *ownername=[[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerName"];
    NSString *ownersurname=[[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerSurname"];
    [cell.namebtn setTitle:[NSString stringWithFormat: @"%@ %@", ownername, ownersurname] forState:UIControlStateNormal] ;
    
    [cell.namebtn addTarget:self  action:@selector(gotoprofile:)  forControlEvents:UIControlEventTouchUpInside];
    [cell.namebtn setTag:indexPath.row];
    //cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    cell.prepTimeLabel.text = [[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    int vidno=(int)[[[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerId"] integerValue];
    cell.cellvid=[[NSString alloc] initWithFormat:@"%d", vidno];
    
    
    // cell.cellvid=[[[resultJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"ownerName"];
    int votecont=(int)[[[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"votesCount"] integerValue];
    cell.votecont.text=[[NSString alloc] initWithFormat:@"%d", votecont];
    
    //cell.nameLabel.textColor=[UIColor whiteColor];
    cell.prepTimeLabel.textColor=[UIColor whiteColor];
    [cell setBackgroundColor:[UIColor blackColor]];
    if (S==1) {
        [cell.namebtn setHidden:YES];
    }
    else{
        [cell.namebtn setHidden:NO];
        [cell.namebtn setNeedsDisplay];
    }
    
    [cell.namebtn setFont:[UIFont fontWithName:@"Oswald-Bold" size:25.f]];
    [cell.prepTimeLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:12.f]];
    [cell.votecont setFont:[UIFont fontWithName:@"Oswald-Bold" size:20.f]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer dealloc2];
    self.moviePlayer=nil;
    [self playerinit];
    //该方法响应列表中行的点击事件
    CGRect rectInTableView=[tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
    NSString *videourl = [[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"videoUrl480"];
    
 //   NSLog([[NSString alloc] initWithFormat:@"%f", rectInSuperview.origin.y]);
    
    if (rectInSuperview.origin.y<100) {
        
        [tableView setContentOffset:CGPointMake(0, indexPath.row*180) animated:YES];
        rectInSuperview =  CGRectMake(0, 100, 80, 80);
        videourl = [[[prolistjson objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"videoUrl480"];
       // NSLog([[NSString alloc] initWithFormat:@"hi+%f", rectInSuperview.origin.y]);
        
        
    }
   // [self.moviePlayer.view setHidden:NO];
   // [self.moviePlayer.view setNeedsDisplay];
    //[self.view addSubview:self.moviePlayer.view];
    //set contentURL (this will automatically start playing the movie)
    [self.moviePlayer setContentURL:[NSURL URLWithString:videourl]];
    if (!self.moviePlayer.isFullscreen) {
        
        [self.moviePlayer setFrame:(CGRect){0,rectInSuperview.origin.y, 320, 180}];
        playery=rectInSuperview.origin.y;
        [self.moviePlayer.view setHidden:NO];
        [self.moviePlayer.view setNeedsDisplay];
        [self.view bringSubviewToFront:self.moviePlayer.view];

        //"frame" is whatever the movie player's frame should be at that given moment
    }
    
    
    [self.moviePlayer prepareToPlay];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    playno=indexPath.row;
    myDelegate.playno=playno;
    
    NSInteger videoidno2=(int)[[[[prolistjson objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"id"] integerValue];
    
    NSString *videotitle= [[[prolistjson objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"title"];
    
    NSInteger ownerid=[[[[prolistjson objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"ownerId"] integerValue];
    
    [self.moviePlayer setstandouter:YES videoid:videoidno2 videotitle:videotitle ownerid2:ownerid hengjson:prolistjson];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    　　switch (orientation) {
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
            
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
            //[self.moviePlayer setFullscreen:YES animated:YES];
            self.moviePlayer.view.frame=CGRectMake(0, 0, 320, 568);
            // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 500)];
            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, 568, 320)];
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"螢幕向右橫置");
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
            //[self.moviePlayer setFullscreen:YES animated:YES];
            self.moviePlayer.view.frame=CGRectMake(0, 0, 320, 568);
            // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 500)];
            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, 568, 320)];
            
            // self.moviePlayer.view.transform=CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
            // self.moviePlayer.view.frame=CGRectMake(0, 0, 320, 568);
            // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 568)];
            // [self.moviePlayer.controls setFrame:CGRectMake(0, 300, 20, 568)];
            
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"螢幕直立");
            
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(0 * M_PI / 180.0);
            // self.moviePlayer.view.frame=CGRectMake(0, playery, 320, 180);
            [self.moviePlayer setFrame:CGRectMake(0, playery, 320, 180)];
            
            
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"螢幕直立，上下顛倒");
            
            break;
            
        default:
            NSLog(@"無法辨識");
            break;
    }
    
    
}
-(void) gotoprofile2{
        [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];

    [self.moviePlayer dealloc2];
    [self playerinit];

    self.moviePlayer=nil;
    //  [self hiddencontrol:nil];
    
    
    
    
   // NSInteger ownerid=[[[[prolistjson objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"ownerId"] integerValue];
    
   // uid=[[NSString alloc] initWithFormat:@"%d", ownerid];
    //myDelegate.profileid=uid;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ info removeFromSuperview];
    [self.profiletableview setHidden:YES];
    [collectionView_ removeFromSuperview];
    [newstableview removeFromSuperview];
    
    info=nil;
    collectionView_=nil;
    newstableview=nil;
    
    getinfothread=[[NSThread alloc] initWithTarget:self selector:@selector(getinforun) object:nil];
    getinfothread.start;
    getinfothread=nil;
    mainpage=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagefoto" object:nil userInfo:nil];}

-(void) gotoprofile:(UIButton *)sender{
    
    
    
    NSLog(@"tag number is = %d",[sender tag]);
    //In this case the tag number of button will be same as your cellIndex.
    // You can make your cell from this.
    
   

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    SimpleTableCell *cell = [self.profiletableview cellForRowAtIndexPath:indexPath];
    
    myDelegate.profileid= cell.cellvid;
    uid=cell.cellvid;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    [ info removeFromSuperview];
    [self.profiletableview setHidden:YES];
    [collectionView_ removeFromSuperview];
    [newstableview removeFromSuperview];

    getinfothread=[[NSThread alloc] initWithTarget:self selector:@selector(getinforun) object:nil];
    getinfothread.start;
    getinfothread=nil;
    mainpage=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagefoto" object:nil userInfo:nil];
    
    
   
}

-(void)gotofanprofile: (NSNotification*) note{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *theData = [note userInfo];
    
    
    uid = [theData objectForKey:@"row"];
    myDelegate.profileid= uid;
    
    [ info removeFromSuperview];
    [collectionView_ removeFromSuperview];
    [newstableview removeFromSuperview];


    [self.profiletableview setHidden:YES];
    getinfothread=[[NSThread alloc] initWithTarget:self selector:@selector(getinforun) object:nil];
    getinfothread.start;
    getinfothread=nil;
    mainpage=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagefoto" object:nil userInfo:nil];
}


-(void)gotonewsprofile: (NSNotification*) note{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *theData = [note userInfo];
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer dealloc2];
    [self playerinit];

    self.moviePlayer=nil;


    
    uid = [theData objectForKey:@"row"];
    NSString *newstype=   [theData objectForKey:@"type"];
    if ([newstype isEqualToString:@"video_vote"]) {
        NSLog(@"imageview is clicked!");
        NSString *videourl =nil;
        
        NSString *vidcode=[[[newsJson objectForKey:@"items"] objectAtIndex: [[theData objectForKey:@"newsrow"] integerValue]] objectForKey:@"resourceThumbUrl"];
        
        vidcode=[[vidcode componentsSeparatedByString: @"thumbs/"] objectAtIndex:1];
        vidcode=[[vidcode componentsSeparatedByString: @"-120/"] objectAtIndex:0];
        videourl =[NSString stringWithFormat: @"http://content.bitsontherun.com/videos/%@-480.mp4",  vidcode];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        playerpage *playpage= [storyboard instantiateViewControllerWithIdentifier:@"playerpage"];
        //profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
        playpage.vid=[[[[newsJson objectForKey:@"items"] objectAtIndex: [[theData objectForKey:@"newsrow"] integerValue]] objectForKey:@"resourceId"] integerValue];
        playpage.videourl=videourl;

        playpage.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
        
        
        [self presentViewController:playpage animated:YES completion:nil];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


    }
    if ([newstype isEqualToString:@"new_fan"]) {
        myDelegate.profileid= uid;
        [ info removeFromSuperview];
        [collectionView_ removeFromSuperview];
        [newstableview removeFromSuperview];
        
        
        [self.profiletableview setHidden:YES];
        getinfothread=[[NSThread alloc] initWithTarget:self selector:@selector(getinforun) object:nil];
        getinfothread.start;
        getinfothread=nil;
        mainpage=0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagefoto" object:nil userInfo:nil];
    }
    
    
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    mainpage=0;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //self.view.backgroundColor = [UIColor blackColor];
   	// Do any additional setup after loading the view.
    myDelegate = [[UIApplication sharedApplication] delegate];
    uid= myDelegate.profileid;
    myDelegate.page=@"2";
    
    self.revealViewController.automaticallyAdjustsScrollViewInsets =NO;

   // self.revealViewController.toggleAnimationDuration=0.4f;
    self.revealViewController.rightViewRevealWidth=80;
    self.revealViewController.rightViewRevealOverdraw = 0;
    
    [self.profilebackbtn addTarget:self  action:@selector(backtomain) forControlEvents:UIControlEventTouchUpInside];
    [self.profilemenubtn addTarget:self.revealViewController  action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self playerinit];

    
    getinfothread = [[NSThread alloc] initWithTarget:self selector:@selector(getinforun) object:nil];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    getinfothread.start;
    
    getinfothread=nil;
   // [self.profiletableview removeFromSuperview];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showview:) name:@"Notification_profilemenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotofanprofile:) name:@"Notification_fanchoose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotonewsprofile:) name:@"Notification_newschoose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotologin) name:@"Notification_gotologin2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoprofile2) name:@"Notification_gotoprofile2" object:nil];

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
    
    
    
    
   


  }


-(void)playerinit{
    self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:self.view.frame];
    self.moviePlayer.delegate = self; //IMPORTANT!
    
   
    
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
    [movieControls setBarHeight:25.f];
    // assign the controls to the movie player
    [self.moviePlayer setControls:movieControls];
    [self.view addSubview:self.moviePlayer.view];
    
    [self.moviePlayer.view setHidden:YES];
    
}



-(NSString *)htmltostring:(NSString*)briefdescription{
    NSRange range;
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


-(void) gotologin{
    
    
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer dealloc2];
    [self playerinit];

    self.moviePlayer=nil;



    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *profileview= [storyboard instantiateViewControllerWithIdentifier:@"loginview"];
    //profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    profileview.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:profileview animated:YES completion:nil];
    
    //[ self.revealViewController setFrontViewController:profileview];
    //[ self.revealViewController setRightViewController:profileview];
}


-(void)getportfolio{
    NSData *data=nil;
    NSError *error=nil;
    
    NSString *url=[NSString stringWithFormat: @"%@/video/search?ss=artist&so=most_recent&sp=%@",myDelegate.webaddress, uid];
   
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    prolistjson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_loadinfo" object:nil];
    [portfoliothread cancel];
    
    [self performSelectorOnMainThread:@selector(loadportfilio) withObject:nil waitUntilDone:YES];

    
}
-(void)getplaylist{
    NSData *data=nil;
    NSError *error=nil;
    
    NSString *url=[NSString stringWithFormat: @"%@/video/search?ss=home_highlight&so=random",myDelegate.webaddress];
    
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    prolistjson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_loadinfo" object:nil];
    [portfoliothread cancel];
    
    [self performSelectorOnMainThread:@selector(loadportfilio) withObject:nil waitUntilDone:YES];
    
    
}

-(void)loadportfilio{
    
   
   // [self.view addSubview:self.profiletableview];
    [self.profiletableview setNeedsDisplay];
    [self.profiletableview reloadData];
    [self.profiletableview setHidden:NO];
     [MBProgressHUD hideHUDForView: self.view animated:YES];
    
}

- (void) showview: (NSNotification*) note
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *theData = [note userInfo];
    
   
    S = [[theData objectForKey:@"row"] intValue];
    if (S==mainpage) {
        pagechange=false;
        [MBProgressHUD hideHUDForView: self.view animated:YES];

        return;
        
    }else{
        pagechange=false;
    }
    
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer dealloc2];
    [self playerinit];

    self.moviePlayer=nil;


    [ info removeFromSuperview];
    [collectionView_ removeFromSuperview];
    [newstableview removeFromSuperview];

    info=nil;
    collectionView_=nil;
    newsJson=nil;


    [self.profiletableview setHidden:YES];
    if (theData != nil) {
        
        switch (S) {
            case 0:
                
                getinfothread=[[NSThread alloc] initWithTarget:self selector:@selector(getinforun) object:nil];
                getinfothread.start;
                getinfothread=nil;
                mainpage=0;
                break;
            case 1:
                portfoliothread = [[NSThread alloc] initWithTarget:self selector:@selector(getportfolio) object:nil];
                portfoliothread.start;
                portfoliothread=nil;
                mainpage=1;
                break;
            
            case 2:
                fansthread = [[NSThread alloc] initWithTarget:self selector:@selector(getfans) object:nil];
                fansthread.start;
                fansthread=nil;
                mainpage=2;
                break;
            case 3:
                newsthread = [[NSThread alloc] initWithTarget:self selector:@selector(getnews) object:nil];
                newsthread.start;
                newsthread=nil;
                mainpage=3;

                break;
            case 4:
                
                logoutthread = [[NSThread alloc] initWithTarget:self selector:@selector(logout) object:nil];
                logoutthread.start;
                logoutthread=nil;
                mainpage=4;

                break;
            default:
                mainpage=-1;
                [MBProgressHUD hideHUDForView: self.view animated:YES];

                
                break;
        }
        
        
    }
}
-(void)logout{
    
      NSDictionary *parameters = @{@"json_response":@"true"};
    urlstring=[[NSString alloc] initWithFormat:@"%@/logout", myDelegate.webaddress];
    [myDelegate.manager GET:urlstring parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"JSON: %@", responseObject);
        myDelegate.manager = [AFHTTPRequestOperationManager manager];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    myDelegate.selfid=@"-1";

    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"logout"] forKey:@"log"];
      [self performSelectorOnMainThread:@selector(fblogout) withObject:nil waitUntilDone:YES];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:dictionary];
    [self performSelectorOnMainThread:@selector(backtomain) withObject:nil waitUntilDone:YES];
    dictionary=nil;
    
   

    
}

-(void) fblogout{
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    [MBProgressHUD hideHUDForView: self.view animated:YES];

}

-(void) loadinfo{
    info=(infoview *)[[[NSBundle mainBundle] loadNibNamed:@"infoview"owner:self options:nil]objectAtIndex:0];
    info.frame=CGRectMake(0,100, 320, self.view.frame.size.height-100);
    info.infodes.frame=CGRectMake(20, 240, 280, info.frame.size.height-250);

    [self.view addSubview:info];
     //[MBProgressHUD showHUDAddedTo:  self.view animated:YES];
    
    


    self.profiletitle.text=[NSString stringWithFormat: @"%@ %@", [infoJSON objectForKey:@"name"],[infoJSON objectForKey:@"surname"]] ;
    [self.profiletitle setFont:[UIFont fontWithName:@"Oswald-Bold" size:25.f]];
    info.infoname.text=[NSString stringWithFormat: @"%@", [infoJSON objectForKey:@"city"]];
    info.infostylelable.text=[NSString stringWithFormat:@"%@",[infoJSON objectForKey:@"category"]];
    if ([[prolistjson objectForKey:@"totalResults"] integerValue]==0) {
        NSString *imageurl = @"http://fakeimg.pl/320x180/?text=no%20%20%20video&font=lobster";
        [info.infovideoimg setImageWithURL:[NSURL URLWithString: imageurl ]];
        info.infovideoimg.userInteractionEnabled=NO;
        

        
    }else{
    NSString *imageurl = [[[prolistjson objectForKey:@"items"] objectAtIndex:0] objectForKey:@"imageUrl480"];
   [info.infovideoimg setImageWithURL:[NSURL URLWithString: imageurl ]];
        info.infovideoimg.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage:) ];
        [info.infovideoimg addGestureRecognizer:singleTap];
        singleTap=nil;
    }
    [info.infodes setTextColor:[UIColor whiteColor]];
    
    [info.infodes setText:[infoJSON objectForKey:@"biography"]];
  // info.infodes.text=[infoJSON objectForKey:@"biography"];
    //NSLog(info.infodes.text);
    //[info.infodes scrollsToTop];
    [info.infoname setFont:[UIFont fontWithName:@"Oswald-Regular" size:15.f]];
    [info.infostylelable setFont:[UIFont fontWithName:@"Oswald-Regular" size:15.f]];
    [info.infodes setFont:[UIFont fontWithName:@"Oswald-Light" size:15.f]];


   //
       [MBProgressHUD hideHUDForView: self.view animated:YES];
    
    
}

-(void)getnews{
    //NSData *data=nil;
    //NSError *error=nil;
    NSString *url=[NSString stringWithFormat: @"%@/notifications?ui=%@",myDelegate.webaddress, myDelegate.selfid];
    
    // data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    //fansJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    [myDelegate.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
         newsJson=responseObject;
        [self performSelectorOnMainThread:@selector(loadnews) withObject:nil waitUntilDone:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_" object:nil];
    
    
    //[fansthread cancel];
    
}
-(void)loadnews{
    newstableview=[[newstable alloc]initWithFrame:CGRectMake(0, 100, 320, self.view.frame.size.height-100)];
    newstableview.newsJson=newsJson;
    [self.view addSubview:newstableview];
    [newstableview reloadData];

    [MBProgressHUD hideHUDForView: self.view animated:YES];
    

}

-(void)getfans{
    //NSData *data=nil;
    //NSError *error=nil;
    NSString *url=[NSString stringWithFormat: @"%@/fansof?ui=%@",myDelegate.webaddress,uid];
    
   // data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    //fansJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    [myDelegate.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        fansJson=responseObject;
         [self performSelectorOnMainThread:@selector(loadfans) withObject:nil waitUntilDone:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    

    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_loadinfo" object:nil];
    
    
    //[fansthread cancel];

}
-(void) loadfans{
    
    NSLog(@"JSO2N: %@", fansJson);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //UICollectionViewLayoutAttributes *flowLayout=[[UICollectionViewLayoutAttributes alloc]init];
    //每个cell的大小
    [flowLayout setItemSize:CGSizeMake(100,100)];
    
    //设置方向（向下还是向右）垂直Vertical  水平Horizontal
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //设置距离边框的高度
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);//top、lef、bottom、right
    
    
    
    collectionView_  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, 320, self.view.frame.size.height-100) collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView_];
    collectionView_.backgroundColor = [UIColor blackColor];
    collectionView_.delegate = self;
    collectionView_.dataSource = self;
    
    [collectionView_ registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [collectionView_ reloadData];
    
    //[self.view addSubview:layout];
   // NSLog(fansco.fansJSON);

    
    
    //
    [MBProgressHUD hideHUDForView: self.view animated:YES];
    
    
}

-(void)onClickImage:(NSString *)string{
    // here, do whatever you wantto do
    
    NSLog(@"imageview is clicked!");
    NSString *videourl =nil;
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer dealloc2];
    self.moviePlayer =nil;
    [self playerinit];
    videourl =[[[prolistjson objectForKey:@"items"] objectAtIndex:0] objectForKey:@"videoUrl480"];
    
    /************hi from here********************/
    
    [self.moviePlayer.view setHidden:NO];
    [self.moviePlayer.view setNeedsDisplay];
    //set contentURL (this will automatically start playing the movie)
    [self.moviePlayer setContentURL:[NSURL URLWithString:videourl]];
    [self.moviePlayer setstandouter:NO videoid:nil videotitle:nil ownerid2:nil hengjson:nil];

    if (!self.moviePlayer.isFullscreen) {
        playery=100;
        [self.moviePlayer setFrame:(CGRect){0, 100, 320, 180}];
        [self.view bringSubviewToFront:self.moviePlayer.view];
        //"frame" is whatever the movie player's frame should be at that given moment
    }
    
}



-(void)getinforun{
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSError *error=nil;
    NSString *infourl=[NSString stringWithFormat: @"%@%@?id=%@", myDelegate.webaddress,myDelegate.profileadd, uid];
    NSString *videllisturl=[NSString stringWithFormat: @"%@/video/search?ss=artist&so=most_recent&sp=%@",myDelegate.webaddress, uid];
    NSLog(uid);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:infourl]];
    NSData *infodata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    infoJSON=[NSJSONSerialization JSONObjectWithData:infodata options:NSJSONReadingMutableLeaves error:&error];
   // NSLog(infoJSON);

    if ( [[infoJSON objectForKey:@"status"] isEqualToString:@"error"]) {
        NSLog(infoJSON);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Sorry this is not artist."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"GO BACK",nil];
        [alert show];
        return;

    }
    
    NSString *state=[infoJSON objectForKey:@"status"];
    NSLog(state);
    
    
    [myDelegate.manager GET:videllisturl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        prolistjson = responseObject;
        NSLog(@"JSON: %@", prolistjson);
        NSLog(@"2");
        NSLog(@"JSOssN: %@", infoJSON);
        NSLog(@"JSssON: %@", prolistjson);
        
       
        
        [self performSelectorOnMainThread:@selector(loadinfo) withObject:nil waitUntilDone:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"Error: %@", error);
    }];
    
  

   // [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_loadinfo" object:nil];
   
    
   // [self performSelectorOnMainThread:@selector(loadinfo) withObject:nil waitUntilDone:YES];
    
   // [getinfothread cancel];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.moviePlayer stop];
    if (![self.moviePlayer.view isHidden]) {
        [self.moviePlayer.view removeFromSuperview];
        [self.moviePlayer dealloc2];
        [self playerinit];
        self.moviePlayer=nil;
    }
    

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //將按鈕的Title當作判斷的依據
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"GO BACK"]) {
        [self performSelectorOnMainThread:@selector(backtomain) withObject:nil waitUntilDone:YES];
    }
    
    
    
}


-(void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    　　switch (orientation) {
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
            
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
            
            //[self.moviePlayer setFullscreen:YES animated:YES];
            self.moviePlayer.view.frame=CGRectMake(0, 0, 320, 568);
            // [self.moviePlayer setFrame:CGRectMake(0, 0, 320, 500)];
            
            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, 568, 320)];
            
            if ([oristate isEqual:@"螢幕向左橫置"]) {
                ;
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];
            
            oristate=@"螢幕向左橫置";
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"螢幕向右橫置");
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
            
            self.moviePlayer.view.frame=CGRectMake(0, 0, 320, 568);
            [self.moviePlayer.controls setFrame:CGRectMake(0, 0, 568, 320)];
            
            if ([oristate isEqual:@"螢幕向右橫置"]) {
                ;
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_chagedir" object:nil userInfo:nil];
            
            oristate=@"螢幕向右橫置";
            
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"螢幕直立");
            
            
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
            
            break;
            
        default:
            NSLog(@"無法辨識");
            break;
    }
    
    
    
    
    
}






-(void)backtomain{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        [self playerinit];
        [self.moviePlayer dealloc2];
        self.moviePlayer=nil;
       
        myDelegate.page=@"1";
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            
            if (![self.presentedViewController isBeingDismissed]) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_backtomain" object:nil userInfo:nil];
                
            }
            [MBProgressHUD hideHUDForView: self.view animated:YES]; 
            // [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });

    

    //[self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
