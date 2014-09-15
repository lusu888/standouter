//
//  cameraviewcontroller.m
//  standouter2
//
//  Created by zhang on 06/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "cameraviewcontroller.h"
#import "VideoRecorder/KZCameraView.h"
#import "ALMoviePlayerController/ALMoviePlayerController.h"
#import "FileOps.h"


@interface cameraviewcontroller ()
@property (nonatomic, strong) KZCameraView *cam;
@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;


@end

@implementation cameraviewcontroller{
    UIView *timechooseview;
    UIButton *btn6s;
    UIButton *btn15s;
    UIButton *btn30s;
    
    UIView *finishviews;
    UIButton *submitbtn;
    UIButton *retakebtn;
    UIButton *watchbtn;
    
    UIImageView *playimg;
    
    NSString *videourl;
    


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
        //Create CameraView
	self.cam = [[KZCameraView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) withVideoPreviewFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.cam.maxDuration = 10.0;
    
    self.cam.showCameraSwitch = YES; //Say YES to button to switch between front and back cameras
    //Create "save" button
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveVideo:)];
    
    [self.view addSubview:self.cam];
    
    
    
    
    
    
    
   // [self.cam setHidden:YES];
    [self.cam.recordBtn setHidden:YES];
    [self.cam.camerasSwitchBtn setHidden:YES];
    
    timechooseview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 80)];
    
    
    btn6s=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [btn6s setImage:[UIImage imageNamed:@"z6s.png"] forState:UIControlStateNormal];
    btn6s.frame=CGRectMake(self.view.frame.size.height/6-40, 0, 80, 80);
    [btn6s addTarget:self action:@selector(choosefinish:) forControlEvents:UIControlEventTouchUpInside];
    [btn6s setTag:6];
    [timechooseview addSubview:btn6s];
    
    btn15s=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [btn15s setImage:[UIImage imageNamed:@"z15s.png"] forState:UIControlStateNormal];
    btn15s.frame=CGRectMake(self.view.frame.size.height/2-40, 0, 80, 80);
     [btn15s addTarget:self action:@selector(choosefinish:) forControlEvents:UIControlEventTouchUpInside];
    [btn15s setTag:15];

    [timechooseview addSubview:btn15s];
    
    btn30s=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [btn30s setImage:[UIImage imageNamed:@"z30s.png"] forState:UIControlStateNormal];
    btn30s.frame=CGRectMake(self.view.frame.size.height/6*5-40, 0, 80, 80);
     [btn30s addTarget:self action:@selector(choosefinish:) forControlEvents:UIControlEventTouchUpInside];
    [btn30s setTag:30];

    [timechooseview addSubview:btn30s];
    
    timechooseview.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    timechooseview.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
    //[timechooseview setBackgroundColor:[UIColor whiteColor ]];
    [self.view addSubview:timechooseview];
    
    finishviews= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 80)];
    
    
    submitbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [submitbtn setImage:[UIImage imageNamed:@"submit.png"] forState:UIControlStateNormal];
    submitbtn.frame=CGRectMake(self.view.frame.size.height/6-40, 0, 80, 80);
    [submitbtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitbtn setTag:6];
    [finishviews addSubview:submitbtn];
    
    retakebtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [retakebtn setImage:[UIImage imageNamed:@"retake.png"] forState:UIControlStateNormal];
    retakebtn.frame=CGRectMake(self.view.frame.size.height/2-40, 0, 80, 80);
    [retakebtn addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
    [retakebtn setTag:15];
    
    [finishviews addSubview:retakebtn];
    
    watchbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [watchbtn setImage:[UIImage imageNamed:@"watch.png"] forState:UIControlStateNormal];
    watchbtn.frame=CGRectMake(self.view.frame.size.height/6*5-40, 0, 80, 80);
    [watchbtn addTarget:self action:@selector(playvideo) forControlEvents:UIControlEventTouchUpInside];
    [watchbtn setTag:30];
    
    [finishviews addSubview:watchbtn];
    
    finishviews.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    finishviews.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
    
    [self.view addSubview:finishviews];
    
    [finishviews setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveVideo:) name:@"Notification_stoprecord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinish) name:@"Notification_movefinish" object:nil ];
    
    

    
}
-(void)movieFinish{
    [self.moviePlayer stop];
    [self.moviePlayer setContentURL:nil];
    [self.moviePlayer.view removeFromSuperview];
    [self playerinit];
    [self.moviePlayer dealloc2];
    self.moviePlayer=nil;
}
-(void)playvideo{
    [self playerinit];
    [self.moviePlayer setContentURL:[NSURL URLWithString:videourl]];
    if (!self.moviePlayer.isFullscreen) {
        self.moviePlayer.view.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
        self.moviePlayer.view.frame=CGRectMake(0, 0, 320, 568);
        [self.moviePlayer.controls setFrame:CGRectMake(0, 0, 568, 320)];
        //"frame" is whatever the movie player's frame should be at that given moment
    }
    [self.moviePlayer prepareToPlay];
    
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer play];
    
}
-(void)submit{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_submit" object:nil userInfo:nil];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)retake{
    NSString  *videourl=[ NSString stringWithFormat:@"file://%@/Documents/mergeVideo-1.mov",NSHomeDirectory()];
    
    
    FileOps *readFile = [[FileOps alloc] init];
    BOOL fe=[readFile fileexits:@"mergeVideo-1.mov"];
    if (fe) {
        [self removeFile:[NSURL URLWithString:videourl]];
    }
    [playimg removeFromSuperview];
    [finishviews setHidden:YES];
    
    [self.cam setHidden:NO];
    [self.cam setNeedsDisplay];

    
    [self.cam.recordBtn setHidden:YES];
    [self.cam.camerasSwitchBtn setHidden:YES];
    
    [timechooseview setHidden:NO];
    [timechooseview setNeedsDisplay];
    
    
}
- (void) removeFile:(NSURL *)fileURL
{
    NSString *filePath = [fileURL path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            
        }
    }
}
-(void)choosefinish:(id)sender{
    UIButton *btn=sender;
    self.cam.maxDuration=btn.tag;
    
    [timechooseview setHidden:YES];
    
    [self.cam.recordBtn setHidden:NO];
    [self.cam.camerasSwitchBtn setHidden:NO];
    [self.cam.deleteLastBtn setHidden:YES];
    
    [self.cam.recordBtn setNeedsDisplay];
    [self.cam.camerasSwitchBtn setNeedsDisplay];
    
    

    
}
-(IBAction)saveVideo:(id)sender
{
    [self.cam.recordBtn setHidden:YES];
    [self.cam.camerasSwitchBtn setHidden:YES];
    [self.cam.deleteLastBtn setHidden:YES];

    [self.cam saveVideoWithCompletionBlock:^(BOOL success) {
        if (success)
        {
            NSLog(@"WILL PUSH NEW CONTROLLER HERE");
           // [self performSegueWithIdentifier:@"SavedVideoPush" sender:sender];
            
            //[self.cam removeFromSuperview];
            //self.cam=nil;
            NSThread *playthread= [[NSThread alloc] initWithTarget:self selector:@selector(playrun) object:nil];
            [playthread start];
            playthread=NULL;
            
            
        }
    }];
}
-(void)playrun{
    videourl=[ NSString stringWithFormat:@"file://%@/Documents/mergeVideo-1.mov",NSHomeDirectory()];
    playimg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 568, 320)];
    [playimg setImage:[self fFirstVideoFrame:videourl]];
    playimg.transform=CGAffineTransformMakeRotation(90 * M_PI / 180.0);
    playimg.center=CGPointMake(320/2, 568/2);
    //[playimg setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:playimg];
    [finishviews setHidden:NO];
    [self.cam setHidden:YES];
    [finishviews setNeedsDisplay];
    [self.cam.deleteLastBtn setHidden:YES];

    [self.view bringSubviewToFront:finishviews];
}
-(UIImage *)fFirstVideoFrame:(NSString *)path
{
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc]
                                   initWithContentURL:[NSURL URLWithString:path]];
    UIImage *img = [mp thumbnailImageAtTime:0.0
                                 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [mp stop];
    mp=nil;
    return img;
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
