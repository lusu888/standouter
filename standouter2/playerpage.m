//
//  playerpage.m
//  standouter2
//
//  Created by zhang on 17/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//
#import "MBProgressHUD.h"
#import "playerpage.h"
#import "AppDelegate.h"
#import "ALMoviePlayerController/ALMoviePlayerController.h"

@interface playerpage ()
@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;

@end

@implementation playerpage{
    AppDelegate *myDelegate;
    NSDictionary *vidinfojson;
    NSString *contextcode;
    NSString *oristate;
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

    [self.backbtn addTarget:self  action:@selector(backtomain) forControlEvents:UIControlEventTouchUpInside];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *temp=[[NSString alloc] initWithFormat:@"%@/video/videoinfo?ri=%d",myDelegate.webaddress, self.vid];
    NSLog(temp);
    
    [myDelegate.manager GET:temp parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        vidinfojson=responseObject;
        contextcode=[vidinfojson objectForKey:@"contestCode"];
        NSString *headername=[[NSString alloc] initWithFormat:@"%@header.png", contextcode];
        NSLog(headername);
        [self.headerimg setImage:[UIImage imageNamed:headername]];
        
        [MBProgressHUD hideHUDForView: self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView: self.view animated:YES];

    }];

    

    [self playerinit];
    
    [self.moviePlayer.view setHidden:NO];
    [self.moviePlayer.view setNeedsDisplay];
    [self.view addSubview:self.moviePlayer.view];
    //set contentURL (this will automatically start playing the movie)
    [self.moviePlayer setContentURL:[NSURL URLWithString:self.videourl]];
    if (!self.moviePlayer.isFullscreen) {
        [self.moviePlayer setFrame:(CGRect){0, 100, 320, 180}];
        //"frame" is whatever the movie player's frame should be at that given moment
    }
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
   
    
}

-(void)backtomain{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        
       [self.moviePlayer stop];
        [self playerinit];
        self.moviePlayer=nil;
       // myDelegate.page=@"1";
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            
            if (![self.presentedViewController isBeingDismissed]) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                
            }
            [MBProgressHUD hideHUDForView: self.view animated:YES];
            
        });
    });
    
    
    
}
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
            
            
            self.moviePlayer.view.transform=CGAffineTransformMakeRotation(0 * M_PI / 180.0);
            // self.moviePlayer.view.frame=CGRectMake(0, playery, 320, 180);
            [self.moviePlayer setFrame:CGRectMake(0, 100, 320, 180)];
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
            [self.moviePlayer setFrame:CGRectMake(0, 100, 320, 180)];
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
