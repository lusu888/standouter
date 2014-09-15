//
//  loginview.h
//  standouter2
//
//  Created by zhang on 24/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface loginview : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backtomainbtn;
@property (weak, nonatomic) IBOutlet UIButton *longinbtn;
@property (weak, nonatomic) IBOutlet UITextField *usernametext;
@property (weak, nonatomic) IBOutlet UITextField *passwordtext;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loginsview;
@property (weak, nonatomic) IBOutlet UIButton *Recupera;

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user;

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error;

@end
