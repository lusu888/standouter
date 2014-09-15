//
//  playerpage.h
//  standouter2
//
//  Created by zhang on 17/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playerpage : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headerimg;
@property (weak, nonatomic) IBOutlet UIButton *backbtn;
@property (weak,nonatomic) NSString* videourl;
@property int vid;
@end
