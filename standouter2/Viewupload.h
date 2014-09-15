//
//  Viewupload.h
//  standouter2
//
//  Created by zhang on 03/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Viewupload : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backbtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerimg;
@property (weak, nonatomic) IBOutlet UITextField *videotitle;
@property (weak, nonatomic) IBOutlet UIView *titleview;
- (IBAction)textFieldDoneEditing:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *categoria;

@end
