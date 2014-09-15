//
//  AppDelegate.h
//  standouter2
//
//  Created by zhang on 05/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFHTTPRequestOperationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //全局变量
    NSString *profileid;
    NSString *page;
    NSString *jessionid;
    NSString *SPRING_SECURITY_REMEMBER_ME_COOKIE;
    NSString *selfid;
    AFHTTPRequestOperationManager *manager;
    NSString *page1page;
    NSString *loginmode;
    NSString *contextname;
    NSString *website;
    NSString *sharesite;

    NSInteger playno;
    NSString *webaddress;
    NSString *profileadd;

   NSDictionary *contestlistjson;
   NSDictionary *channellistjson;

    UIColor *menucolor;
    NSDictionary *briefjson;
    
    
    
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *profileid;
@property (nonatomic, retain) NSString *page;
@property (nonatomic, retain) NSString *jessionid;
@property (nonatomic, retain) NSString *SPRING_SECURITY_REMEMBER_ME_COOKIE;
@property (nonatomic, retain) NSString *selfid;
@property (retain, nonatomic) NSString *loginmode;
@property (retain, nonatomic) NSString *page1page;
@property (retain, nonatomic) NSString *contextname;
@property (retain, nonatomic) NSString *website;
@property  NSDictionary *briefjson;

@property int playno;
@property  NSString *webaddress;
@property  NSString *sharesite;

@property  NSString *profileadd;
@property NSDictionary *contestlistjson;
@property NSDictionary *channellistjson;
@property     UIColor *menucolor;










@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;
@end