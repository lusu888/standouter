//
//  Viewupload.m
//  standouter2
//
//  Created by zhang on 03/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "Viewupload.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Viewuploadask.h"
#include "Viewuploadupload.h";
#import <MediaPlayer/MPMoviePlayerController.h>
#import "cameraviewcontroller.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking/AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"

#import "ASIFormDataRequest.h"



@interface Viewupload ()

@end

@implementation Viewupload{
    AppDelegate *myDelegate;
    NSArray *tableData;
    Viewuploadask *uploadaskview;
    Viewuploadupload *uploaduploadview;
    NSData *fileData;
    NSURL *fileurl;
    NSDictionary *linkjson;
    NSString *videoPath ;
    NSString *videokey;
    NSString *urlstring;
    NSString *categoriacode;

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
    myDelegate = [[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view.
    [self.backbtn addTarget:self  action:@selector(backtomain) forControlEvents:UIControlEventTouchUpInside];
    [self.categoria addTarget:self  action:@selector(choosecategoria) forControlEvents:UIControlEventTouchUpInside];

    if (![myDelegate.contextname isEqualToString:@"tuborg"]) {
        [self.categoria removeFromSuperview];
    }
    int mainpage= [myDelegate.page1page integerValue]-1;
    if(mainpage==-1) mainpage=0;
    
    NSString* imgstring=[myDelegate.briefjson objectForKey:@"backgroundImageUrlMobile"];
    urlstring=[[NSString alloc] initWithFormat:@"%@%@", myDelegate.webaddress,imgstring];
    [self.headerimg setImageWithURL:urlstring];
    
    //[self.headerimg setImage:[UIImage imageNamed:urlstring]];

    [self.titleview setHidden:YES];
    //uploadaskview=[[Viewuploadask alloc] initWithFrame:CGRectMake(0, 200, 320, 330)];
    uploadaskview=(Viewuploadask *)[[[NSBundle mainBundle] loadNibNamed:@"Viewuploadask"owner:self options:nil]objectAtIndex:0];
    [uploadaskview setFrame:CGRectMake(0, 100, 320, 330)];

    [uploadaskview.ipbtn addTarget:self  action:@selector(getvfromip) forControlEvents:UIControlEventTouchUpInside];
    [uploadaskview.camerabtn addTarget:self  action:@selector(getcamera) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:uploadaskview];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submit) name:@"Notification_submit" object:nil];

}
-(void)submit{
     videoPath = [ NSString stringWithFormat:@"%@/Documents/mergeVideo-1.mov",NSHomeDirectory()];
    fileData = [NSData dataWithContentsOfFile:videoPath];
    fileurl=[NSURL URLWithString:videoPath];
    NSLog( [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding]);
    [uploadaskview setHidden:YES];
    
    uploaduploadview=(Viewuploadupload *)[[[NSBundle mainBundle] loadNibNamed:@"Viewuploadupload"owner:self options:nil]objectAtIndex:0];
    [uploaduploadview setFrame:CGRectMake(0, 220, 320, 330)];
    [uploaduploadview.uploadimg setImage: [self fFirstVideoFrame:videoPath]];
    [uploaduploadview.cancelbtn addTarget:self action: @selector(goBacktouploadask) forControlEvents:UIControlEventTouchUpInside];
    [uploaduploadview.uploadbtn addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    [self.categoria setTitle:@"scegliere la Categoria" forState:UIControlStateNormal];
    categoriacode=nil;
    [self.view addSubview:uploaduploadview];
    [self.titleview setHidden:NO];
    [self.titleview setNeedsDisplay];

    
}
-(void)choosecategoria{

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Categoria"
                                                             delegate:self
                                                    cancelButtonTitle:@"CANCEL"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"#ENJOYTUBORG - hiphop crew",@"#LOVETUBORG – beatbox",@"#PLAYTUBORG - urban art",@"#LIVETUBORG - parkour",@"#SHARETUBORG - amazing skills", nil];
                                  
    
        [actionSheet showInView:self.view];

    
    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //將按鈕的Title當作判斷的依據
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"#ENJOYTUBORG - hiphop crew"]) {
        [self.categoria setTitle:title forState:UIControlStateNormal];
        categoriacode=@"ENJOYTUBORG";
    }
    
    else if([title isEqualToString:@"#LOVETUBORG – beatbox"]) {
        [self.categoria setTitle:title forState:UIControlStateNormal];
        categoriacode=@"LOVETUBORG";

        
    }
    
    else if([title isEqualToString:@"#PLAYTUBORG - urban art"]) {
        [self.categoria setTitle:title forState:UIControlStateNormal];
        categoriacode=@"PLAYTUBORG";

        
    }
    else if([title isEqualToString:@"#LIVETUBORG - parkour"]) {
        [self.categoria setTitle:title forState:UIControlStateNormal];
        categoriacode=@"LIVETUBORG";

        
    }else if([title isEqualToString:@"#SHARETUBORG - amazing skills"]) {
        [self.categoria setTitle:title forState:UIControlStateNormal];
        categoriacode=@"SHARETUBORG";
    }
}
-(void)upload{

    
    if([self.videotitle.text isEqualToString:@""]||self.videotitle.text==nil ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UPLOAD"
                                                        message:@"The title can not be enmry."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
   
    }else if(categoriacode==nil&&[myDelegate.contextname isEqualToString:@"tuborg"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UPLOAD"
                                                        message:@"The categoria can not be enmry."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
        
    }else{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

     NSThread *preuploadthread=[[NSThread alloc] initWithTarget:self selector:@selector(preuploadrun) object:@"mj"];
     [preuploadthread start];
     preuploadthread=nil;
    }
}
-(void)preuploadrun{
    
    
    NSDictionary *parameters;
    if ([myDelegate.contextname isEqualToString:@"tuborg"]) {
        parameters = @{@"resumable":@"false",@"title":self.videotitle.text,@"category":categoriacode};
    }
    else{
        parameters = @{@"resumable":@"false",@"title":self.videotitle.text};

    }
    urlstring=[ NSString stringWithFormat:@"%@/contest/%@/prepare_upload?",myDelegate.webaddress, myDelegate.contextname] ;
    
    [myDelegate.manager POST:urlstring parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        NSLog(@"JSON: %@", responseObject);
        linkjson=responseObject;
        
        if ([[linkjson objectForKey:@"status"]isEqualToString:@"error"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"upload" message:[linkjson objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert=nil;
            [MBProgressHUD hideAllHUDsForView: self.view animated:YES];
            [self  goBacktouploadask];
        }
        else{
            [self performSelectorOnMainThread:@selector(uploadtaskzz) withObject:nil waitUntilDone:YES];
            
        }

       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
/**********************************
    [ myDelegate.manager GET:[ NSString stringWithFormat:@"%@/contest/%@/prepare_upload?resumable=false&title=%@",myDelegate.webaddress, myDelegate.contextname,self.videotitle.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog( [NSString stringWithFormat:@"%@/contest/%@/prepare_upload?resumable=false&title=%@",myDelegate.webaddress, myDelegate.contextname,self.videotitle.text]);
        NSLog(@"JSON: %@", responseObject);
        linkjson=responseObject;
        
        if ([[linkjson objectForKey:@"status"]isEqualToString:@"error"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"upload" message:[linkjson objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert=nil;
            [MBProgressHUD hideAllHUDsForView: self.view animated:YES];
            [self  goBacktouploadask];
        }
        else{
            [self performSelectorOnMainThread:@selector(uploadtaskzz) withObject:nil waitUntilDone:YES];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
 
   */
}
-(void)uploadtaskzz{
    NSLog(@"ZZUPLOAD");
    NSThread *uploadthread=[[NSThread alloc] initWithTarget:self selector:@selector(uploadrun) object:@"mj"];
    [uploadthread start];
    uploadthread=nil;
}
-(void)uploadrun{
    NSString *saveprotocol=[[linkjson objectForKey:@"link"]objectForKey:@"protocol" ];
    NSString *saveadress=[[linkjson objectForKey:@"link"]objectForKey:@"address" ];
    NSString *savepath=[[linkjson objectForKey:@"link"]objectForKey:@"path" ];
    NSString *savekey=[[[linkjson objectForKey:@"link"]objectForKey:@"query"]objectForKey:@"key"];
    NSString *saveid=[[linkjson objectForKey:@"link"]objectForKey:@"session_id"];
    NSString *saveurl = [ NSString stringWithFormat:@"%@://%@%@?api_format=json&key=%@",saveprotocol,saveadress,savepath,savekey];

    videokey=savekey;
    if ([saveid isEqualToString:@"<null>"]|| saveid==nil ) {
        NSString* savetoken=[[[linkjson objectForKey:@"link"]objectForKey:@"query"]objectForKey:@"token"];
        saveurl = [ NSString stringWithFormat:@"%@&token=%@",saveurl,savetoken];

    }
    NSLog(saveid);
    NSLog(saveurl);
    
    NSDictionary *parameters = @{@"enctype":@"multipart/form-data"};

   // NSURL *filePath = [NSURL fileURLWithPath: [ NSString stringWithFormat:@"%@/Documents/mergeVideo-1.mov",NSHomeDirectory()]];
    NSLog(@"ZHANG");
   // NSLog([filePath absoluteString]);
   // NSString *string =@"http://myimageurkstrn.com/img/myimage.png";
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:saveurl]];
    
    [request setDelegate:self];
    
    
    [request setRequestMethod:@"POST"];
    
    
    [request setFile:videoPath forKey:@"file"];
    
    
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
    
   
}



-(void)getcamera{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     cameraviewcontroller *cameraview= [storyboard instantiateViewControllerWithIdentifier:@"cameraview"];
    [self presentModalViewController:cameraview animated:YES];

    
}

-(void)getvfromip{
    NSLog(@"IPHONE");

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    [self presentModalViewController:imagePicker animated:YES];
}
- (void)uploadRequestFinished:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    
    // Store incoming data into a string
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Server response:%@", response);
    
    
    NSString *urlstring= [NSString stringWithFormat:@"%@/contest/%@/end_upload.json?video_key=%@",myDelegate.webaddress,myDelegate.contextname,videokey];
    [myDelegate.manager GET:urlstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"upload finisher." message:[ NSString stringWithFormat:@"Il tuo video è stato caricato con successo e sarà valutato, entro 24h, dalla redazione di Standouter.Se sarà selezionato e pubblicato, riceverai un' email di conferma!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert=nil;
        
        [MBProgressHUD hideAllHUDsForView: self.view animated:YES];
        
        [self  goBacktouploadask];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
   // [self backtomain];
}


- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@"[TWDEBUG] Error - upload failed: \"%@\"",[[request error] localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backtomain{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            
            if (![self.presentedViewController isBeingDismissed]) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_backtomain" object:nil userInfo:nil];
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });
}


#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];
        fileData = UIImageJPEGRepresentation(img, 1.0);
    } else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        fileurl=[NSURL URLWithString:videoPath];

        fileData = [NSData dataWithContentsOfFile:videoPath];
        NSLog(videoPath);
        [uploadaskview setHidden:YES];
        
        uploaduploadview=(Viewuploadupload *)[[[NSBundle mainBundle] loadNibNamed:@"Viewuploadupload"owner:self options:nil]objectAtIndex:0];
        [uploaduploadview setFrame:CGRectMake(0, 220, 320, 330)];
        [uploaduploadview.uploadimg setImage: [self fFirstVideoFrame:videoPath]];
        [uploaduploadview.cancelbtn addTarget:self action: @selector(goBacktouploadask) forControlEvents:UIControlEventTouchUpInside];
        [uploaduploadview.uploadbtn addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
        [self.categoria setTitle:@"scegliere la Categoria" forState:UIControlStateNormal];
        categoriacode=nil;
        [self.view addSubview:uploaduploadview];

        [self.titleview setHidden:NO];
        [self.titleview setNeedsDisplay];

        
    }
    [self.view setBackgroundColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [picker dismissModalViewControllerAnimated:YES];
    
}

-(void)goBacktouploadask{
    [uploaduploadview removeFromSuperview];
    uploaduploadview=nil;
    [uploadaskview setHidden:NO];
    [uploadaskview setNeedsDisplay];
    [self.titleview setHidden:YES];

    
}
-(UIImage *)fFirstVideoFrame:(NSString *)path
{
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc]
                                   initWithContentURL:[NSURL fileURLWithPath:path]];
    UIImage *img = [mp thumbnailImageAtTime:0.0
                                 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [mp stop];
    mp=nil;
    return img;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
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
- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}


@end
