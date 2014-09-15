//
//  loginview.m
//  standouter2
//
//  Created by zhang on 24/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "loginview.h"
#import "AFHTTPRequestOperationManager.h"
#import "FileOps.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "APService.h"




@interface loginview ()
- (IBAction)buttonClicked:(id)sender;
@end

@implementation loginview{
    AppDelegate *myDelegate;
    NSThread *loginthread;
    NSThread *pwdthread;
    NSDictionary *loginjson;
    NSDictionary *pwdjson;
    NSString* urlstring;
    NSString *fbAccessToken;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Create a FBLoginView to log the user in with basic, email and likes permissions
        // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
        
        
    }
    return self;
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    //self.profilePictureView.profileID = user.id;
    //self.usernametext.text = user.name;
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //將按鈕的Title當作判斷的依據
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(title);
    if([title isEqualToString:@"CONTINUE"]) {
        NSLog(fbAccessToken);
        NSString *fbregistration =[NSString stringWithFormat: @"%@/fbregistration?accessToken=%@",myDelegate.sharesite,  fbAccessToken];

        NSURL *url=[NSURL URLWithString:fbregistration];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    if([title isEqualToString:@"Recupera"])
    {
        
        NSString *pwdemail = [alertView textFieldAtIndex:0].text;
        NSLog(@"Username: %@\n",pwdemail);
        
        
        pwdthread=[[NSThread alloc]initWithTarget:self selector:@selector(getregisterjson:) object:pwdemail];
        
        pwdthread.start;
        
    }
    
    
    
    
    
}

-(void)getregisterjson:(NSString*)pwdemail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    
    urlstring=[[NSString alloc] initWithFormat:@"%@/pwd?t=%@", myDelegate.webaddress,pwdemail];
    
    [myDelegate.manager GET:urlstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        pwdjson=responseObject;
        NSLog(@"JSON: %@", pwdjson);


        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        [self performSelectorOnMainThread:@selector(pwdalert) withObject:nil waitUntilDone:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}

-(void)pwdalert{
    
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recupera Password"
                                                        message:[pwdjson objectForKey:@"message"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert=NULL;
    
    
}





// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(fbAccessToken);

    
    if ([myDelegate.loginmode isEqualToString:@"nomal"]) {
        // self.passwordtext.text = @"You're logged in as";
       
        // self.usernametext.text = fbAccessToken;
        __block NSString *setcookie;
        
        NSString *FBloginurl =[NSString stringWithFormat: @"%@/fbaccess?accessToken=%@",myDelegate.webaddress,  fbAccessToken];
        //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [myDelegate.manager POST:FBloginurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            
            loginjson=responseObject;
            
            if([[loginjson objectForKey:@"logged"] integerValue] ==0 ){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"login"
                                                                message:@"Please register first!"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"CONTINUE",nil];
                [alert show];
                alert=NULL;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }else{
                int sid=  [[[loginjson objectForKey:@"loginStatus"] objectForKey:@"registrationId"] integerValue] ;
                myDelegate.selfid= [[NSString alloc] initWithFormat:@"%d", sid];
                NSLog(myDelegate.selfid);
                if ([myDelegate.selfid isEqualToString:@"-1"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"login"
                                                                    message:@"login faild."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"TRY AGAIN"
                                                          otherButtonTitles:nil];
                    [alert show];
                    alert=NULL;
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                }else{
                    
                    NSDictionary *header = operation.response.allHeaderFields;
                    
                    setcookie=[header objectForKey:@"Set-Cookie"];
                    NSArray *explodeArray = [setcookie componentsSeparatedByString:@";"];
                    NSLog(setcookie);
                    FileOps *files = [[FileOps alloc] init];
                    [files WriteToStringFile:explodeArray[0] andname:@"SPRING_SECURITY_REMEMBER_ME_COOKIE.txt"];
                    myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE=explodeArray[0];
                    
                    
                    NSArray *explodeArray2 = [explodeArray[3] componentsSeparatedByString:@", "];
                    [files WriteToStringFile:explodeArray2[1] andname:@"JSESSIONID.txt"];
                    myDelegate.jessionid=explodeArray2[1];
                    
                    NSLog(@"JSON: %@", responseObject);
                    
                    NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"login"] forKey:@"log"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:dictionary];
                    
                    
                    NSLog( myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE);
                    NSLog( myDelegate.jessionid);
                    NSString *cookiestring =[NSString stringWithFormat: @"%@;%@",myDelegate.jessionid,  myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE];
                    
                    
                    [myDelegate.manager.requestSerializer setValue:cookiestring forHTTPHeaderField:@"Cookie"];
                    
                    
                    
                    [APService setTags:nil alias:myDelegate.selfid callbackSelector:nil object:nil];
                    
                    
                    [self performSelectorOnMainThread:@selector(backtomain) withObject:nil waitUntilDone:YES];
                    
                    if([files fileexits:@"JSESSIONID.txt"]==TRUE){
                        
                        
                        
                    }
                    //
                    
                    files=NULL;
                }

                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }
            

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSelectorOnMainThread:@selector(backtomain) withObject:nil waitUntilDone:YES];

            NSLog(@"Error: %@", error);
        }];
        

    }else{
       
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self performSelectorOnMainThread:@selector(backtomain) withObject:nil waitUntilDone:YES];

    }

     }



// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    //self.profilePictureView.profileID = nil;
    self.usernametext.text = @"";
    NSLog(@"s");

    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
     myDelegate = [[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view.
    self.usernametext.placeholder=@"Usename";
    
    self.passwordtext.placeholder=@"Password";
    [self.usernametext setFont:[UIFont fontWithName:@"Oswald-Light" size:18.f]];
    [self.passwordtext setFont:[UIFont fontWithName:@"Oswald-Light" size:18.f]];
    [self.backtomainbtn addTarget:self  action:@selector(backtomain) forControlEvents:UIControlEventTouchUpInside];
    [self.longinbtn addTarget:self  action:@selector(logins) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setFont:[UIFont fontWithName:@"Oswald-Bold" size:18.f]];
    
     [self.Recupera addTarget:self  action:@selector(registerstep1) forControlEvents:UIControlEventTouchUpInside];
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile",@"user_friends", @"email", @"user_likes"]];
    
    // Set this loginUIViewController to be the loginView button's delegate
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectMake(60,220,200, 50);
    loginView.center=CGPointMake (self.view.frame.size.width/2, self.loginsview.frame.origin.y
    -40);
    // Align the button in the center vertically
    //loginView.center = self.view.center;
    
    // Add the button to the view
    if ([myDelegate.loginmode isEqualToString:@"nomal"]) {
        [self.loginsview setHidden:NO];
        [self.loginsview setNeedsDisplay];
    }
    else{
        [self.loginsview setHidden:YES];
    }
    [self.view addSubview:loginView];
}
// You need to override loginView:handleError in order to handle possible errors that can occur during login


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(void)getloginjson{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSLog(self.usernametext.text);
    NSLog(self.passwordtext.text);
    
    NSString *username = self.usernametext.text;
    NSString *password = self.passwordtext.text;
    __block NSString *setcookie;
    
    NSDictionary *parameters = @{@"json_response":@"true",@"j_username":username,@"j_password":password};
    urlstring=[[NSString alloc] initWithFormat:@"%@/j_spring_security_check", myDelegate.webaddress];

    [myDelegate.manager POST:urlstring parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        loginjson=responseObject;
        int sid=  [[responseObject objectForKey:@"registrationId"] intValue] ;
        myDelegate.selfid= [[NSString alloc] initWithFormat:@"%d", sid];
        
        if ([myDelegate.selfid isEqualToString:@"-1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"login"
                                                            message:@"login faild."
                                                           delegate:nil
                                                  cancelButtonTitle:@"TRY AGAIN"
                                                  otherButtonTitles:nil];
            [alert show];
            alert=NULL;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

           
        }else{
            
            NSDictionary *header = operation.response.allHeaderFields;
            
            setcookie=[header objectForKey:@"Set-Cookie"];
            NSArray *explodeArray = [setcookie componentsSeparatedByString:@";"];
            NSLog(setcookie);
            FileOps *files = [[FileOps alloc] init];
            [files WriteToStringFile:explodeArray[0] andname:@"SPRING_SECURITY_REMEMBER_ME_COOKIE.txt"];
            
            myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE=explodeArray[0];
            
            NSArray *explodeArray2 = [explodeArray[3] componentsSeparatedByString:@", "];
            [files WriteToStringFile:explodeArray2[1] andname:@"JSESSIONID.txt"];
            
            myDelegate.jessionid=explodeArray2[1];

            NSLog(@"JSON: %@", responseObject);
            
                        NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [[NSString alloc] initWithFormat:@"login"] forKey:@"log"];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_login" object:nil userInfo:dictionary];
            [APService setTags:nil alias:myDelegate.selfid callbackSelector:nil object:nil];

            
            
            NSLog( myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE);
            NSLog( myDelegate.jessionid);
            NSString *cookiestring =[NSString stringWithFormat: @"%@;%@",myDelegate.jessionid,  myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE];

            
            [myDelegate.manager.requestSerializer setValue:cookiestring forHTTPHeaderField:@"Cookie"];
            [self performSelectorOnMainThread:@selector(backtomain) withObject:nil waitUntilDone:YES];
            if([files fileexits:@"JSESSIONID.txt"]==TRUE){
                /*
                
                myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE=[files readFromFile:@"SPRING_SECURITY_REMEMBER_ME_COOKIE.txt"];
                myDelegate.jessionid=[files readFromFile:@"JSESSIONID.txt"];
                NSLog( myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE);
                NSLog( myDelegate.jessionid);

                
               [myDelegate.manager.requestSerializer setValue:myDelegate.jessionid forHTTPHeaderField:@"Cookie"];
               [self performSelectorOnMainThread:@selector(backtomain) withObject:nil waitUntilDone:YES];
                */
                
            }
            files=NULL;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

          //
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
}
-(void)logins{
    
    loginthread=[[NSThread alloc]initWithTarget:self selector:@selector(getloginjson) object:@"mj"];

    loginthread.start;
    
    loginthread=NULL;


}

-(void)registerstep1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Inserisci la tua Email"
                                                   delegate:self
                                          cancelButtonTitle:@"CANCEL"
                                          otherButtonTitles:@"Recupera",nil];
    alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    
    [alert show];
    
}


-(void)backtomain{
    FileOps *files = [[FileOps alloc] init];
   
    if([files fileexits:@"setcookie.txt"]==TRUE){
   
    
    myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE=[files readFromFile:@"SPRING_SECURITY_REMEMBER_ME_COOKIE.txt"];
    myDelegate.jessionid=[files readFromFile:@"JSESSIONID.txt"];
        NSLog( myDelegate.SPRING_SECURITY_REMEMBER_ME_COOKIE);
        NSLog( myDelegate.jessionid);

    }
    files=NULL;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}


@end
