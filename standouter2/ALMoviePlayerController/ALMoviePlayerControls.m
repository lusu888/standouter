//
//  ALMoviePlayerControls.m
//  ALMoviePlayerController
//
//  Created by Anthony Lobianco on 10/8/13.
//  Copyright (c) 2013 Anthony Lobianco. All rights reserved.
//

#import "ALMoviePlayerControls.h"
#import "ALMoviePlayerController.h"
#import "ALAirplayView.h"
#import "ALButton.h"
#import <tgmath.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "Hengtableview.h"
#import "MBProgressHUD.h"






@implementation UIDevice (ALSystemVersion)

+ (float)iOSVersion {
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

@end

@interface ALMoviePlayerControlsBar : UIView

@property (nonatomic, strong) UIColor *color;

@end

static const inline BOOL isIpad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
static const CGFloat activityIndicatorSize = 40.f;
static const CGFloat iPhoneScreenPortraitWidth = 320.f;

@interface ALMoviePlayerControls () <ALAirplayViewDelegate, ALButtonDelegate> {
    @private
    int windowSubviews;
    BOOL shareout;
    AppDelegate *myDelegate ;
   
}

@property (nonatomic, weak) ALMoviePlayerController *moviePlayer;
@property (nonatomic, assign) ALMoviePlayerControlsState state;
@property (nonatomic, getter = isShowing) BOOL showing;

@property (nonatomic, strong) NSTimer *durationTimer;

@property (nonatomic, strong) UIView *activityBackgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) ALMoviePlayerControlsBar *topBar;
@property (nonatomic, strong) ALMoviePlayerControlsBar *bottomBar;
@property (nonatomic, strong) UISlider *durationSlider;
@property (nonatomic, strong) ALButton *playPauseButton;
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) ALAirplayView *airplayView;
@property (nonatomic, strong) ALButton *fullscreenButton;
@property (nonatomic, strong) UILabel *timeElapsedLabel;
@property (nonatomic, strong) UILabel *timeRemainingLabel;
@property (nonatomic, strong) ALButton *seekForwardButton;
@property (nonatomic, strong) ALButton *seekBackwardButton;
@property (nonatomic, strong) ALButton *scaleButton;


@property (nonatomic, strong) ALButton *sharebtn;
@property (nonatomic, strong) ALButton *votebtn;
@property (nonatomic, strong) ALButton *fbsharebtn;
@property (nonatomic, strong) ALButton *whatsappbtn;
//@property (nonatomic, strong) UIImageView * ownerbtn;
@property (strong, nonatomic) ALButton * ownername;
@property (nonatomic, strong) UILabel * vtitlelable;
@property (nonatomic, strong) UIImageView * shadowup;






@property (nonatomic, strong) Hengtableview *hengtable;



@end

@implementation ALMoviePlayerControls
# pragma mark - Construct/Destruct

- (id)initWithMoviePlayer:(ALMoviePlayerController *)moviePlayer style:(ALMoviePlayerControlsStyle)style {
    self = [super init];
    if (self) {
        
        myDelegate = [[UIApplication sharedApplication] delegate];

        self.backgroundColor = [UIColor clearColor];
        
        _moviePlayer = moviePlayer;
        _style = style;
        _showing = NO;
        _fadeDelay = 5.0;
        _timeRemainingDecrements = NO;
        _barColor = [[UIColor blackColor] colorWithAlphaComponent:.0f];
        
        //in fullscreen mode, move controls away from top status bar and bottom screen bezel. I think the iOS7 control center gestures interfere with the uibutton touch events. this will alleviate that a little (correct me if I'm wrong and/or adjust if necessary).
        _barHeight = [UIDevice iOSVersion] >= 7.0 ? 50.f : 30.f;
        
        _seekRate = 3.f;
        _state = ALMoviePlayerControlsStateIdle;
        
        [self setup];
        [self addNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chagedir) name:@"Notification_chagedir" object:nil];
        
       
       
        
    }
    return self;
}

-(void)chagedir{
    //[self hideControls:nil];
    if(self.frame.size.height==180){
        _sharebtn.frame = CGRectMake(-self.frame.size.width/4,self.frame.size.height/2-self.frame.size.width/8,self.frame.size.width/4,self.frame.size.width/4);
        _votebtn.frame = CGRectMake(self.frame.size.width, self.frame.size.height/2-self.frame.size.width/8, self.frame.size.width/4, self.frame.size.width/4);
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
        // _ownername.frame=CGRectMake(10,10 , 40,40);
        
        
        　_sharebtn.alpha = 0;
        　_votebtn.alpha = 0;
        
        _sharebtn.frame = CGRectMake(-self.sharebtn.frame.size.width,_sharebtn.frame.origin.y , self.sharebtn.frame.size.width,self.sharebtn.frame.size.height);
        _votebtn.frame = CGRectMake(self.frame.size.width,_votebtn.frame.origin.y , self.votebtn.frame.size.width,self.votebtn.frame.size.height);
        　_fbsharebtn.alpha = 0;
        _whatsappbtn.alpha=0;
        _ownername.alpha=0;
        _vtitlelable.alpha=0;
        
        _shadowup.alpha=0;
        
        _fbsharebtn.frame = CGRectMake(0, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
        _whatsappbtn.frame = CGRectMake(0, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
        _hengtable.alpha=0;
        _hengtable.frame=CGRectMake(0,320,self.frame.size.width,80);
        shareout=false;

       
        [_ownername removeFromSuperview];
        
    }else{
        _ownername.enabled=YES;
        _sharebtn.frame = CGRectMake(-self.frame.size.width/6,self.frame.size.height/2-self.frame.size.width/12,self.frame.size.width/6,self.frame.size.width/6);
        _votebtn.frame = CGRectMake(self.frame.size.width, self.frame.size.height/2-self.frame.size.width/12, self.frame.size.width/6, self.frame.size.width/6);
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
        _ownername.frame=CGRectMake(20,20 , self.frame.size.width/2-20,40);
        
        [self addSubview:_ownername];
        [_ownername setHidden:NO];
        [_ownername setNeedsDisplay];
        
        _vtitlelable.frame=CGRectMake(self.frame.size.width/2,20 , self.frame.size.width/2-20,40);
        [_vtitlelable setHidden:NO];
        [_vtitlelable setNeedsDisplay];
        
        [_shadowup setHidden:NO];
        [_shadowup setNeedsDisplay];
        
        
    }

    
      // [self hideControls:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_durationTimer invalidate];
    [self nilDelegates];
}



# pragma mark - Construct/Destruct Helpers

- (void)setup {
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;

  
    
    //top bar
    _topBar = [[ALMoviePlayerControlsBar alloc] init];
    _topBar.color = _barColor;
    _topBar.alpha = 0.f;
    [self addSubview:_topBar];
    
    //bottom bar
    _bottomBar = [[ALMoviePlayerControlsBar alloc] init];
    _bottomBar.color = _barColor;
    _bottomBar.alpha = 0.f;
    [self addSubview:_bottomBar];
    [_bottomBar setHidden:YES];
    
    _durationSlider = [[UISlider alloc] init];
    _durationSlider.value = 0.f;
    _durationSlider.continuous = YES;
    [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [_durationSlider  setMinimumTrackTintColor:[UIColor colorWithRed:2555/255 green:50/255 blue:0 alpha:1]];
    [_durationSlider setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateNormal];
    [_durationSlider setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateSelected];

    _timeElapsedLabel = [[UILabel alloc] init];
    _timeElapsedLabel.backgroundColor = [UIColor clearColor];
    _timeElapsedLabel.font = [UIFont systemFontOfSize:12.f];
    _timeElapsedLabel.textColor = [UIColor lightTextColor];
    _timeElapsedLabel.textAlignment = NSTextAlignmentRight;
    _timeElapsedLabel.text = @"0:00";
    _timeElapsedLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _timeElapsedLabel.layer.shadowRadius = 1.f;
    _timeElapsedLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _timeElapsedLabel.layer.shadowOpacity = 0.8f;
    
    _timeRemainingLabel = [[UILabel alloc] init];
    _timeRemainingLabel.backgroundColor = [UIColor clearColor];
    _timeRemainingLabel.font = [UIFont systemFontOfSize:12.f];
    _timeRemainingLabel.textColor = [UIColor lightTextColor];
    _timeRemainingLabel.textAlignment = NSTextAlignmentLeft;
    _timeRemainingLabel.text = @"0:00";
    _timeRemainingLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _timeRemainingLabel.layer.shadowRadius = 1.f;
    _timeRemainingLabel.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _timeRemainingLabel.layer.shadowOpacity = 0.8f;
    
    if (_style == ALMoviePlayerControlsStyleFullscreen || (_style == ALMoviePlayerControlsStyleDefault && _moviePlayer.isFullscreen)) {
        [_topBar addSubview:_durationSlider];
        [_topBar addSubview:_timeElapsedLabel];
        [_topBar addSubview:_timeRemainingLabel];
        
        _fullscreenButton = [[ALButton alloc] init];
        [_fullscreenButton setTitle:@"Done" forState:UIControlStateNormal];
        [_fullscreenButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        _fullscreenButton.titleLabel.shadowOffset = CGSizeMake(1.f, 1.f);
        [_fullscreenButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        _fullscreenButton.delegate = self;
        [_fullscreenButton addTarget:self action:@selector(fullscreenPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:_fullscreenButton];
        
        _scaleButton = [[ALButton alloc] init];
        _scaleButton.delegate = self;
        [_scaleButton setImage:[UIImage imageNamed:@"movieFullscreen.png"] forState:UIControlStateNormal];
        [_scaleButton setImage:[UIImage imageNamed:@"movieEndFullscreen.png"] forState:UIControlStateSelected];
        [_scaleButton addTarget:self action:@selector(scalePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:_scaleButton];
        
        _volumeView = [[MPVolumeView alloc] init];
        [_volumeView setShowsRouteButton:NO];
        [_volumeView setShowsVolumeSlider:YES];
        [_bottomBar addSubview:_volumeView];
        [_bottomBar setHidden:YES];

        
        _seekForwardButton = [[ALButton alloc] init];
        [_seekForwardButton setImage:[UIImage imageNamed:@"movieForward.png"] forState:UIControlStateNormal];
        [_seekForwardButton setImage:[UIImage imageNamed:@"movieForwardSelected.png"] forState:UIControlStateSelected];
        _seekForwardButton.delegate = self;
        [_seekForwardButton addTarget:self action:@selector(seekForwardPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:_seekForwardButton];
        
        _seekBackwardButton = [[ALButton alloc] init];
        [_seekBackwardButton setImage:[UIImage imageNamed:@"movieBackward.png"] forState:UIControlStateNormal];
        [_seekBackwardButton setImage:[UIImage imageNamed:@"movieBackwardSelected.png"] forState:UIControlStateSelected];
        _seekBackwardButton.delegate = self;
        [_seekBackwardButton addTarget:self action:@selector(seekBackwardPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:_seekBackwardButton];
    }
    
    else if (_style == ALMoviePlayerControlsStyleEmbedded || (_style == ALMoviePlayerControlsStyleDefault && !_moviePlayer.isFullscreen)) {
        [_bottomBar addSubview:_durationSlider];
        [_bottomBar addSubview:_timeElapsedLabel];
        [_bottomBar addSubview:_timeRemainingLabel];
        
        _fullscreenButton = [[ALButton alloc] init];
        [_fullscreenButton setImage:[UIImage imageNamed:@"movieFullscreen.png"] forState:UIControlStateNormal];
        [_fullscreenButton addTarget:self action:@selector(fullscreenPressed:) forControlEvents:UIControlEventTouchUpInside];
        _fullscreenButton.delegate = self;
        //[_bottomBar addSubview:_fullscreenButton];
    }
    
    
    
    //static stuff
    _playPauseButton = [[ALButton alloc] init];
    [_playPauseButton setImage:[UIImage imageNamed:@"moviePause.png"] forState:UIControlStateNormal];
    [_playPauseButton setImage:[UIImage imageNamed:@"moviePlay.png"] forState:UIControlStateSelected];
    [_playPauseButton setSelected:_moviePlayer.playbackState == MPMoviePlaybackStatePlaying ? NO : YES];
    [_playPauseButton addTarget:self action:@selector(playPausePressed:) forControlEvents:UIControlEventTouchUpInside];
    _playPauseButton.delegate = self;
    [_bottomBar addSubview:_playPauseButton];
    
    _airplayView = [[ALAirplayView alloc] init];
    _airplayView.delegate = self;
    [_bottomBar addSubview:_airplayView];
    
    _activityBackgroundView = [[UIView alloc] init];
    [_activityBackgroundView setBackgroundColor:[UIColor blackColor]];
    _activityBackgroundView.alpha = 0.f;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.alpha = 0.f;
    _activityIndicator.hidesWhenStopped = YES;
    
    _sharebtn = [[ALButton alloc] init];
    [_sharebtn setImage:[UIImage imageNamed:@"sharea.png"] forState:UIControlStateNormal];
    _sharebtn.delegate = self;
    _sharebtn.frame=CGRectMake(-80, 50, 80, 80);
    _sharebtn.alpha=0;
    [_sharebtn addTarget:self  action:@selector(sharerun) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_sharebtn];
    
    _fbsharebtn = [[ALButton alloc] init];
    [_fbsharebtn setImage:[UIImage imageNamed:@"FACEBOOK2.png"] forState:UIControlStateNormal];
    _fbsharebtn.delegate = self;
    _fbsharebtn.frame=CGRectMake(0, 50, 80, 80);
    _fbsharebtn.alpha=0;
    [_fbsharebtn addTarget:self  action:@selector(fbsharerun) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _whatsappbtn = [[ALButton alloc] init];
    [_whatsappbtn setImage:[UIImage imageNamed:@"WHATSAPP2.png"] forState:UIControlStateNormal];
    _whatsappbtn.delegate = self;
    _whatsappbtn.frame=CGRectMake(0, 50, 80, 80);
    _whatsappbtn.alpha=0;
    [_whatsappbtn addTarget:self  action:@selector(wpsharerun) forControlEvents:UIControlEventTouchUpInside];
    
    
   
    
    [_sharebtn bringSubviewToFront:self];

    shareout=false;
    
    _votebtn = [[ALButton alloc] init];
    [_votebtn setImage:[UIImage imageNamed:@"sa.png"] forState:UIControlStateNormal];
    _votebtn.delegate = self;
    _votebtn.frame=CGRectMake(320, 50, 80, 80);
    _votebtn.alpha=0;
    [self addSubview:_votebtn];
    [_votebtn addTarget:self  action:@selector(voterun) forControlEvents:UIControlEventTouchUpInside];

    shareout=false;
    NSLog(@"SDFD%d",_ownerid);
    _ownername = [[ALButton alloc] init];
    _vtitlelable= [[UILabel alloc]init];
    NSString *ownername=[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"ownerName"];
    NSString *ownersurname=[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"ownerSurname"];
    [_ownername  setTitle:[NSString stringWithFormat: @"%@ %@", ownername, ownersurname] forState:UIControlStateNormal] ;
    _vtitlelable.text=[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"title"];
    
    _ownername.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25];
    _vtitlelable.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    _vtitlelable.textColor=[UIColor whiteColor];
    _ownername.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _ownername.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _ownername.frame=CGRectMake(20, 5, 140, 40);
    _vtitlelable.frame=CGRectMake(320, 5, 140, 40);
    [_ownername setFont:[UIFont fontWithName:@"Oswald-Regular" size:25]];
    [_vtitlelable setFont:[UIFont fontWithName:@"Oswald-Light" size:25]];
    
    _shadowup= [[UIImageView alloc]init];
    _shadowup.frame=CGRectMake(0,0, 568, 80);
    [_shadowup setImage:[UIImage imageNamed:@"shadowup.png"]];
    
    

    _ownername.alpha=0;
    _vtitlelable.alpha=0;
    [_ownername setHidden:YES];
    
    //[_shadowup setHidden:YES];

    [_vtitlelable setHidden:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickowner) ];
    [_ownername addGestureRecognizer:singleTap];
    _ownername.userInteractionEnabled=YES;
    [self addSubview:_shadowup];
    //[self addSubview:_ownername];
    [self addSubview:_vtitlelable];
    [_hengtable removeFromSuperview];
    _hengtable=[[Hengtableview alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self hengtableinit];
    
    [self addSubview:_hengtable];
    _ownername.userInteractionEnabled=NO;
    
    [_shadowup setAlpha:0];

}
-(void)hengtableinit{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            _hengtable.myJson=_resultJSON;
            [_hengtable reloadData];
            _hengtable.showsVerticalScrollIndicator=NO;
            _hengtable.showsHorizontalScrollIndicator=NO;
            _hengtable.alpha=0;
            [_hengtable setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
            _hengtable.frame=CGRectMake(0,320,self.frame.size.width,80);
            
        });
    });
}
-(void)onClickowner{
    NSInteger ownerid=[[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"ownerId"]integerValue];
    NSString *temp=[[NSString alloc] initWithFormat:@"%d", ownerid];
    myDelegate.profileid=temp;
    temp=nil;
    
   // myDelegate.profileid=[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"ownerId"];
    switch ([myDelegate.page intValue]) {
            
        case 1:
            NSLog(@"1");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotoprofile1" object:nil];
            break;
        case 2:
            NSLog(@"2");

            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotoprofile2" object:nil];
            break;
            
        default:
            break;
    }
}


-(void)sharerun{
    
    NSLog([[NSString alloc] initWithFormat:@"share%d", 21]);
    if ([myDelegate.selfid isEqualToString:@"-1"]) {
       
        myDelegate.loginmode=@"nomal";
        switch ([myDelegate.page intValue]) {
            case 1:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotologin" object:nil];
                break;
            case 2:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotologin2" object:nil];
                break;
                
            default:
                break;
        }

        
        }else{
        
        //NSLog([[NSString alloc] initWithFormat:@"share %d", playno]);
        
            _fbsharebtn.frame = CGRectMake(_fbsharebtn.frame.origin.x,_fbsharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
            _whatsappbtn.frame = CGRectMake(_whatsappbtn.frame.origin.x,_whatsappbtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
        if (shareout) {
           
            
            [UIView animateWithDuration:0.4f
             　　delay:0
             　　options:UIViewAnimationOptionCurveEaseIn
             　　animations:^{
                 　　_fbsharebtn.alpha = 0;
                _whatsappbtn.alpha=0;
                 _fbsharebtn.frame = CGRectMake(_sharebtn.frame.origin.x, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
                 _whatsappbtn.frame = CGRectMake(_sharebtn.frame.origin.x, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
                 
                 　　}
             　　completion:^(BOOL finished) {
                 shareout=false;
                 [_fbsharebtn removeFromSuperview];
                 [_whatsappbtn removeFromSuperview];
                 　　}];
            
        }
        else{
           [self addSubview:_fbsharebtn];
           [self addSubview:_whatsappbtn];
           
            
            
            [UIView animateWithDuration:0.4f
             　　delay:0
             　　options:UIViewAnimationOptionCurveEaseIn
             　　animations:^{
                 　　_fbsharebtn.alpha = 1;
                 _whatsappbtn.alpha=1;
                 if (self.frame.size.height==180) {
                     _fbsharebtn.frame = CGRectMake(_sharebtn.frame.size.width, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
                     _whatsappbtn.frame = CGRectMake(7*_sharebtn.frame.size.width/4, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
                 }else{
                     _fbsharebtn.frame = CGRectMake(_sharebtn.frame.size.width+20, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
                     _whatsappbtn.frame = CGRectMake(7*_sharebtn.frame.size.width/4+20, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
                 }
               
                 
                 　　}
             　　completion:^(BOOL finished) {
                 
                 　　}];
            shareout=true;
            
        }
    }

}

-(void)voterun{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    
    
   // NSLog([[NSString alloc] initWithFormat:@"vote%d", playno]);
    if ([myDelegate.selfid isEqualToString:@"-1"]) {
       
        myDelegate.loginmode=@"nomal";
        switch ([myDelegate.page intValue]) {
            case 1:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotologin" object:nil];
                break;
            case 2:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotologin2" object:nil];
                break;
                
            default:
                break;
        }
    }else{
      //  NSLog([[NSString alloc] initWithFormat:@"vote%d", playno]);
        
        //int videoidno=(int)[[[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"id"] integerValue];
        
        NSString *voteurl=[[NSString alloc] initWithFormat:@"%@/video/vote?ri=%d&vt=STANDOUT",myDelegate.webaddress, _videoidno];
        
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
           // alert.transform= CGAffineTransformRotate(alert.transform, degreesToRadian(90));
            [MBProgressHUD hideHUDForView:self animated:YES];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"EXIT",nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self animated:YES];
            
            return;
        }];
        
        
    }
    
    
    
}

-(void)fbsharerun{
    
    if ([[FBSession activeSession]isOpen]==false) {
        myDelegate.loginmode=@"purefblogin";
        switch ([myDelegate.page intValue]) {
            case 1:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotologin" object:nil];
                break;
            case 2:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_gotologin2" object:nil];
                break;
                
            default:
                break;
        }
        return;
        
    }
    
    NSLog(@"RUN FBSHARE");
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    
    
   // NSString *videotitle= [[[resultJSON objectForKey:@"items"] objectAtIndex:playno] objectForKey:@"title"];
    NSString *messagefbshare=[[NSString alloc] initWithFormat:@"I like the video %@ in standouter.", _videotitle];
    
    NSString *sharelink=[[NSString alloc] initWithFormat:@"%@/video?ri=%d",myDelegate.sharesite, self.videoidno];
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString *fbshareurl=[[NSString alloc] initWithFormat:@"https://graph.facebook.com/me/feed?access_token=%@", fbAccessToken];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            messagefbshare, @"message",sharelink,@"link",
                            nil
                            ];
    
    [myDelegate.manager POST:fbshareurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [MBProgressHUD hideHUDForView:self animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"facebookshare"
                                                        message:@"You have share this video on Facebook."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
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


-(NSString *)htmltostring:(NSString*)briefdescription{
    NSRange range;
    briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"Ã¨" withString:@"è"];
    briefdescription = [briefdescription stringByReplacingOccurrencesOfString:@"Ã" withString:@"à"];
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
- (void)resetViews {
    [self stopDurationTimer];
    [self nilDelegates];
    [_activityBackgroundView removeFromSuperview];
    [_activityIndicator removeFromSuperview];
    [_topBar removeFromSuperview];
    [_bottomBar removeFromSuperview];
}

- (void)nilDelegates {
    _airplayView.delegate = nil;
    _playPauseButton.delegate = nil;
    _fullscreenButton.delegate = nil;
    _seekForwardButton.delegate = nil;
    _seekBackwardButton.delegate = nil;
    _scaleButton.delegate = nil;
}

# pragma mark - Setters

- (void)setStyle:(ALMoviePlayerControlsStyle)style {
    if (_style != style) {
        BOOL flag = _style == ALMoviePlayerControlsStyleDefault;
        [self hideControls:^{
            [self resetViews];
            _style = style;
            [self setup];
            if (_style != ALMoviePlayerControlsStyleNone) {
                double delayInSeconds = 0.2;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self setDurationSliderMaxMinValues];
                    [self monitorMoviePlayback]; //resume values
                    [self startDurationTimer];
                    [self showControls:^{
                        if (flag) {
                            //put style back to default
                            _style = ALMoviePlayerControlsStyleDefault;
                        }
                    }];
                    
                });
            } else {
                if (flag) {
                    //put style back to default
                    _style = ALMoviePlayerControlsStyleDefault;
                }
            }
        }];
    }
}

- (void)setState:(ALMoviePlayerControlsState)state {
    if (_state != state) {
        _state = state;
        
        switch (state) {
            case ALMoviePlayerControlsStateLoading:
                [self showLoadingIndicators];
               
                break;
            case ALMoviePlayerControlsStateReady:
                [self hideLoadingIndicators];
                NSLog(@"LOADFINISH");
                if ([self.moviePlayer.view isHidden]) {
                    NSLog(@"LOADFINISH OK");
                    [self.moviePlayer stop];
                    [self.moviePlayer setContentURL:nil];

                }
                break;
            case ALMoviePlayerControlsStateIdle:
            default:
                break;
        }
    }
}

- (void)setBarColor:(UIColor *)barColor {
    if (_barColor != barColor) {
        _barColor = barColor;
        [self.topBar setColor:barColor];
        [self.bottomBar setColor:barColor];
        //[self.bottomBar setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    }
}

# pragma mark - UIControl/Touch Events

- (void)durationSliderTouchBegan:(UISlider *)slider {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
    [self.moviePlayer pause];
}

- (void)durationSliderTouchEnded:(UISlider *)slider {
    [self.moviePlayer pause];

    [self.moviePlayer setCurrentPlaybackTime:floor(slider.value)];
    //[self.moviePlayer pause];
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)durationSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.moviePlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)buttonTouchedDown:(UIButton *)button {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
}

- (void)buttonTouchedUpOutside:(UIButton *)button {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)buttonTouchCancelled:(UIButton *)button {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)airplayButtonTouchedDown {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
}

- (void)airplayButtonTouchedUpOutside {
   [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)airplayButtonTouchFailed {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)airplayButtonTouchedUpInside {
    //TODO iphone
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    if (isIpad()) {
        windowSubviews = keyWindow.layer.sublayers.count;
        [keyWindow addObserver:self forKeyPath:@"layer.sublayers" options:NSKeyValueObservingOptionNew context:NULL];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![keyPath isEqualToString:@"layer.sublayers"]) {
        return;
    }
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    if (keyWindow.layer.sublayers.count == windowSubviews) {
        [keyWindow removeObserver:self forKeyPath:@"layer.sublayers"];
        [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
    }
}

- (void)windowDidResignKey:(NSNotification *)note {
    UIWindow *resignedWindow = (UIWindow *)[note object];
    if ([self isAirplayShowingInView:resignedWindow]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidResignKeyNotification object:nil];
        [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
    }
}

- (void)windowDidBecomeKey:(NSNotification *)note {
    UIWindow *keyWindow = (UIWindow *)[note object];
    if ([self isAirplayShowingInView:keyWindow]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignKey:) name:UIWindowDidResignKeyNotification object:nil];
    }
}

- (BOOL)isAirplayShowingInView:(UIView *)view {
    BOOL actionSheet = NO;
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIActionSheet class]]) {
            actionSheet = YES;
        } else {
            actionSheet = [self isAirplayShowingInView:subview];
        }
    }
    return actionSheet;
}

- (void)playPausePressed:(UIButton *)button {
    self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying ? [self.moviePlayer pause] : [self.moviePlayer play];
   // [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)fullscreenPressed:(UIButton *)button {
    if (self.style == ALMoviePlayerControlsStyleDefault) {
        self.style = self.moviePlayer.isFullscreen ? ALMoviePlayerControlsStyleEmbedded : ALMoviePlayerControlsStyleFullscreen;
    }
    if (self.moviePlayer.currentPlaybackRate != 1.f) {
        self.moviePlayer.currentPlaybackRate = 1.f;
    }
    [self.moviePlayer setFullscreen:!self.moviePlayer.isFullscreen animated:YES];
   [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)scalePressed:(UIButton *)button {
    button.selected = !button.selected;
    [self.moviePlayer setScalingMode:button.selected ? MPMovieScalingModeAspectFill : MPMovieScalingModeAspectFit];
}

- (void)seekForwardPressed:(UIButton *)button {
    self.moviePlayer.currentPlaybackRate = !button.selected ? self.seekRate : 1.f;
    button.selected = !button.selected;
    self.seekBackwardButton.selected = NO;
    if (!button.selected) {
       [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
    }
}

- (void)seekBackwardPressed:(UIButton *)button {
    self.moviePlayer.currentPlaybackRate = !button.selected ? -self.seekRate : 1.f;
    button.selected = !button.selected;
    self.seekForwardButton.selected = NO;
    if (!button.selected) {
        [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;
    self.isShowing ? [self hideControls:nil] : [self showControls:nil];
}

# pragma mark - Notifications

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieContentURLDidChange:) name:ALMoviePlayerContentURLDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDurationAvailable:) name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    
}

- (void)movieFinished:(NSNotification *)note {
    self.playPauseButton.selected = YES;
    [self.durationTimer invalidate];
    [self.moviePlayer setCurrentPlaybackTime:0.0];
    
    [self monitorMoviePlayback]; //reset values
    [self showControls:nil];
    //[self hideControls:nil];
    
    //self.moviePlayer.view.alpha=0.3;
    //self.alpha=1;
    self.state = ALMoviePlayerControlsStateIdle;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_movefinish" object:nil];
    
}

- (void)movieLoadStateDidChange:(NSNotification *)note {
    switch (self.moviePlayer.loadState) {
        case MPMovieLoadStatePlayable:
        case MPMovieLoadStatePlaythroughOK:
           // [self showControls:nil];
            self.state = ALMoviePlayerControlsStateReady;
            break;
        case MPMovieLoadStateStalled:
        case MPMovieLoadStateUnknown:
            break;
        default:
            break;
    }
}

- (void)moviePlaybackStateDidChange:(NSNotification *)note {
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            self.playPauseButton.selected = NO;
            [self startDurationTimer];
            
            //local file
            if ([self.moviePlayer.contentURL.scheme isEqualToString:@"file"]) {
                [self setDurationSliderMaxMinValues];
                [self showControls:nil];
            }
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
            self.state = ALMoviePlayerControlsStateReady;
            break;
        case MPMoviePlaybackStateInterrupted:
            self.state = ALMoviePlayerControlsStateLoading;
            break;
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped:
            self.state = ALMoviePlayerControlsStateIdle;
            self.playPauseButton.selected = YES;
            [self stopDurationTimer];
            break;
        default:
            break;
    }
}

- (void)movieDurationAvailable:(NSNotification *)note {
    [self setDurationSliderMaxMinValues];
}

- (void)movieContentURLDidChange:(NSNotification *)note {
    [self hideControls:^{
        //don't show loading indicator for local files
        self.state = [self.moviePlayer.contentURL.scheme isEqualToString:@"file"] ? ALMoviePlayerControlsStateReady : ALMoviePlayerControlsStateLoading;
    }];
}

# pragma mark - Internal Methods

- (void)startDurationTimer {
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorMoviePlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer {
    [self.durationTimer invalidate];
}

- (void)showControls:(void(^)(void))completion {
   
    if (!self.isShowing) {
        
        if (self.willshow) {
            [UIView animateWithDuration:0.4f
             　　delay:0
             　　options:UIViewAnimationOptionCurveEaseIn
             　　animations:^{
                 　_sharebtn.alpha = 1;
                 　_votebtn.alpha = 1;
                 
                 if (self.frame.size.width!=320) {
                     _hengtable.alpha=1.f;
                     _hengtable.frame=CGRectMake(0,210,self.frame.size.width,110);
                     _sharebtn.frame = CGRectMake(20,_sharebtn.frame.origin.y , self.sharebtn.frame.size.width,self.sharebtn.frame.size.height);
                     _votebtn.frame = CGRectMake(self.frame.size.width-self.votebtn.frame.size.height-20,_votebtn.frame.origin.y , self.votebtn.frame.size.width,self.votebtn.frame.size.height);
                     _ownername.alpha=1;
                     _vtitlelable.alpha=1;
                     _shadowup.alpha=1;
                     
                     
                 }
                 else{
                     _sharebtn.frame = CGRectMake(0,_sharebtn.frame.origin.y , self.sharebtn.frame.size.width,self.sharebtn.frame.size.height);
                     _votebtn.frame = CGRectMake(self.frame.size.width-self.votebtn.frame.size.height,_votebtn.frame.origin.y , self.votebtn.frame.size.width,self.votebtn.frame.size.height);
                     _ownername.alpha=0;
                     _shadowup.alpha=0;
                     
                     
                     
                 }
                 　　}
             　　completion:^(BOOL finished) {
                 
                 
                 
                 　　}];
            
            
        }

        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        if (self.style == ALMoviePlayerControlsStyleFullscreen || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
            [self.topBar setNeedsDisplay];
        }
        [self.bottomBar setNeedsDisplay];
        //[self.bottomBar setBackgroundColor:[UIColor blackColor]];
        [self.moviePlayer pause];
        self.bottomBar.backgroundColor=[UIColor clearColor];
       // self.bottomBar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];

        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            if (self.style == ALMoviePlayerControlsStyleFullscreen || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
                self.topBar.alpha = .7f;
            }
            self.bottomBar.alpha = 1.f;
            
            
            
        } completion:^(BOOL finished) {
            _showing = YES;
            if (completion)
                completion();
            //[self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
        }];
    } else {
        if (completion)
            completion();
    }
    
    //_sharebtn.alpha=_sharebtn.alpha;
    //_sharebtn.frame = CGRectMake(_sharebtn.frame.origin.x,(self.frame.size.height-_sharebtn.frame.size.height)/2,self.frame.size.width/4,self.frame.size.width/4);
   // _votebtn.alpha=_votebtn.alpha;
   // _votebtn.frame = CGRectMake(_votebtn.frame.origin.x, (self.frame.size.height-_sharebtn.frame.size.height)/2, self.frame.size.width/4, self.frame.size.width/4);
    NSString *ownername=[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"ownerName"];
    NSString *ownersurname=[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"ownerSurname"];
    [_ownername  setTitle:[NSString stringWithFormat: @"%@ %@", ownername, ownersurname] forState:UIControlStateNormal] ;
    _vtitlelable.text=[[[_resultJSON objectForKey:@"items"] objectAtIndex:myDelegate.playno] objectForKey:@"title"];
   
    
    
   
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_showcontrols" object:nil];
}


- (void)hideControls:(void(^)(void))completion {
    if (self.isShowing) {
        
        [UIView animateWithDuration:0.4f
         　　delay:0
         　　options:UIViewAnimationOptionCurveEaseIn
         　　animations:^{
             　_sharebtn.alpha = 0;
             　_votebtn.alpha = 0;
             
             _sharebtn.frame = CGRectMake(-self.sharebtn.frame.size.width,_sharebtn.frame.origin.y , self.sharebtn.frame.size.width,self.sharebtn.frame.size.height);
             _votebtn.frame = CGRectMake(self.frame.size.width,_votebtn.frame.origin.y , self.votebtn.frame.size.width,self.votebtn.frame.size.height);
             　_fbsharebtn.alpha = 0;
             _whatsappbtn.alpha=0;
             _ownername.alpha=0;
             _vtitlelable.alpha=0;
             
             _shadowup.alpha=0;
             
             _fbsharebtn.frame = CGRectMake(0, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
             _whatsappbtn.frame = CGRectMake(0, _sharebtn.frame.origin.y, _sharebtn.frame.size.width,  _sharebtn.frame.size.height);
             _hengtable.alpha=0;
             _hengtable.frame=CGRectMake(0,320,self.frame.size.width,80);
             shareout=false;
             　　}
         　　completion:^(BOOL finished) {
             [_fbsharebtn removeFromSuperview];
             [_whatsappbtn removeFromSuperview];
             　　}];

        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            if (self.style == ALMoviePlayerControlsStyleFullscreen || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
                self.topBar.alpha = 0.f;
            }
            self.bottomBar.alpha = 0.f;
        } completion:^(BOOL finished) {
            _showing = NO;
            if (completion)
                completion();
        }];
        
    } else {
        if (completion)
            completion();
    }
    

    [self.moviePlayer play];

    
       //_sharebtn.frame = CGRectMake(-self.sharebtn.frame.size.width,_sharebtn.frame.origin.y , self.sharebtn.frame.size.width,self.sharebtn.frame.size.height);
    //_votebtn.frame = CGRectMake(self.frame.size.width,_votebtn.frame.origin.y , self.votebtn.frame.size.width,self.votebtn.frame.size.height);
    

     //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_hidecontrols" object:nil];
}

- (void)showLoadingIndicators {
    [self addSubview:_activityBackgroundView];
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    [UIView animateWithDuration:0.2f animations:^{
        _activityBackgroundView.alpha = 1.f;
        _activityIndicator.alpha = 1.f;
    }];
}

- (void)hideLoadingIndicators {
    [UIView animateWithDuration:0.2f delay:0.0 options:0 animations:^{
        self.activityBackgroundView.alpha = 0.0f;
        self.activityIndicator.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.activityBackgroundView removeFromSuperview];
        [self.activityIndicator removeFromSuperview];
    }];
}

- (void)setDurationSliderMaxMinValues {
    CGFloat duration = self.moviePlayer.duration;
    self.durationSlider.minimumValue = 0.f;
    self.durationSlider.maximumValue = duration;
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    self.timeElapsedLabel.text = [NSString stringWithFormat:@"%.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining;
    double secondsRemaining;
    if (self.timeRemainingDecrements) {
        minutesRemaining = floor((totalTime - currentTime) / 60.0);
        secondsRemaining = fmod((totalTime - currentTime), 60.0);
    } else {
        minutesRemaining = floor(totalTime / 60.0);
        secondsRemaining = floor(fmod(totalTime, 60.0));
    }
    self.timeRemainingLabel.text = self.timeRemainingDecrements ? [NSString stringWithFormat:@"-%.0f:%02.0f", minutesRemaining, secondsRemaining] : [NSString stringWithFormat:@"%.0f:%02.0f", minutesRemaining, secondsRemaining];
}

- (void)monitorMoviePlayback {
    double currentTime = floor(self.moviePlayer.currentPlaybackTime);
    double totalTime = floor(self.moviePlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.durationSlider.value = ceil(currentTime);

}

- (void)layoutSubviews {
    [super layoutSubviews];
            
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;
    
    //common sizes
    CGFloat paddingFromBezel = self.frame.size.width <= iPhoneScreenPortraitWidth ? 10.f : 20.f;
    CGFloat paddingBetweenButtons = self.frame.size.width <= iPhoneScreenPortraitWidth ? 10.f : 30.f;
    CGFloat paddingBetweenPlaybackButtons = self.frame.size.width <= iPhoneScreenPortraitWidth ? 20.f : 30.f;
    CGFloat paddingBetweenLabelsAndSlider = 10.f;
    CGFloat sliderHeight = 34.f; //default height
    CGFloat volumeHeight = 20.f;
    CGFloat volumeWidth = isIpad() ? 210.f : 120.f;
    CGFloat seekWidth = 36.f;
    CGFloat seekHeight = 20.f;
    CGFloat airplayWidth = 30.f;
    CGFloat airplayHeight = 22.f;
    CGFloat playWidth = 25.f;
    CGFloat playHeight = 25.f;
    CGFloat labelWidth = 30.f;
    
    if (self.style == ALMoviePlayerControlsStyleFullscreen || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
        //top bar
        CGFloat fullscreenWidth = 0.f;
        CGFloat fullscreenHeight = self.barHeight;
        CGFloat scaleWidth = 28.f;
        CGFloat scaleHeight = 28.f;
        self.topBar.frame = CGRectMake(0, 0, self.frame.size.width, self.barHeight);
        self.fullscreenButton.frame = CGRectMake(paddingFromBezel, self.barHeight/2 - fullscreenHeight/2, fullscreenWidth, fullscreenHeight);
        self.timeElapsedLabel.frame = CGRectMake(self.fullscreenButton.frame.origin.x + self.fullscreenButton.frame.size.width + paddingBetweenButtons, 0, labelWidth, self.barHeight);
        self.scaleButton.frame = CGRectMake(self.topBar.frame.size.width - paddingFromBezel - scaleWidth, self.barHeight/2 - scaleHeight/2, scaleWidth, scaleHeight);
        self.timeRemainingLabel.frame = CGRectMake(self.scaleButton.frame.origin.x - paddingBetweenButtons - labelWidth, 0, labelWidth, self.barHeight);
        
        //bottom bar

        self.bottomBar.frame = CGRectMake(0, self.frame.size.height - self.barHeight, self.frame.size.width, self.barHeight);
        self.playPauseButton.frame = CGRectMake(self.bottomBar.frame.size.width/2 - playWidth/2, self.barHeight/2 - playHeight/2, playWidth, playHeight);
        self.seekForwardButton.frame = CGRectMake(self.playPauseButton.frame.origin.x + self.playPauseButton.frame.size.width + paddingBetweenPlaybackButtons, self.barHeight/2 - seekHeight/2 + 1.f, seekWidth, seekHeight);
        self.seekBackwardButton.frame = CGRectMake(self.playPauseButton.frame.origin.x - paddingBetweenPlaybackButtons - seekWidth, self.barHeight/2 - seekHeight/2 + 1.f, seekWidth, seekHeight);
        
        //hide volume view in iPhone's portrait orientation
        if (self.frame.size.width <= iPhoneScreenPortraitWidth) {
            self.volumeView.alpha = 0.f;
        } else {
            self.volumeView.alpha = 1.f;
            self.volumeView.frame = CGRectMake(paddingFromBezel, self.barHeight/2 - volumeHeight/2, volumeWidth, volumeHeight);
        }
        
        self.airplayView.frame = CGRectMake(self.bottomBar.frame.size.width - paddingFromBezel - airplayWidth, self.barHeight/2 - airplayHeight/2, airplayWidth, airplayHeight);
    }
    
    else if (self.style == ALMoviePlayerControlsStyleEmbedded || (self.style == ALMoviePlayerControlsStyleDefault && !self.moviePlayer.isFullscreen)) {
        self.bottomBar.frame = CGRectMake(0, self.frame.size.height - self.barHeight, self.frame.size.width, self.barHeight);
        
        //left side of bottom bar
        self.playPauseButton.frame = CGRectMake(paddingFromBezel, self.barHeight/2 - playHeight/2, playWidth, playHeight);
        self.timeElapsedLabel.frame = CGRectMake(self.playPauseButton.frame.origin.x + self.playPauseButton.frame.size.width, 0, labelWidth, self.barHeight);
        
        //right side of bottom bar
        CGFloat fullscreenWidth = 0.f;
        CGFloat fullscreenHeight = fullscreenWidth;
        self.fullscreenButton.frame = CGRectMake(self.bottomBar.frame.size.width - paddingFromBezel - fullscreenWidth, self.barHeight/2 - fullscreenHeight/2, fullscreenWidth, fullscreenHeight);
        self.airplayView.frame = CGRectMake(self.fullscreenButton.frame.origin.x - paddingBetweenButtons - airplayWidth, self.barHeight/2 - airplayHeight/2, airplayWidth, airplayHeight);
        self.timeRemainingLabel.frame = CGRectMake(self.frame.size.width - labelWidth, 0, labelWidth, self.barHeight);
    }
    
    //duration slider
    CGFloat timeRemainingX = self.timeRemainingLabel.frame.origin.x;
    CGFloat timeElapsedX = self.timeElapsedLabel.frame.origin.x;
    CGFloat sliderWidth = ((timeRemainingX - paddingBetweenLabelsAndSlider) - (timeElapsedX + self.timeElapsedLabel.frame.size.width + paddingBetweenLabelsAndSlider));
    self.durationSlider.frame = CGRectMake(timeElapsedX + self.timeElapsedLabel.frame.size.width + paddingBetweenLabelsAndSlider, self.barHeight/2 - sliderHeight/2, sliderWidth, sliderHeight);
    //self.durationSlider setThumbImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    
    if (self.state == ALMoviePlayerControlsStateLoading) {
        [_activityBackgroundView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_activityIndicator setFrame:CGRectMake((self.frame.size.width / 2) - (activityIndicatorSize / 2), (self.frame.size.height / 2) - (activityIndicatorSize / 2), activityIndicatorSize, activityIndicatorSize)];
    }
}


@end

# pragma mark - ALMoviePlayerControlsBar

@implementation ALMoviePlayerControlsBar

- (id)init {
    if ( self = [super init] ) {
        self.opaque = NO;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [_color CGColor]);
    CGContextFillRect(context, rect);
}




@end
