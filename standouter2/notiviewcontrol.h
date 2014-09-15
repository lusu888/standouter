//
//  notiviewcontrol.h
//  standouter2
//
//  Created by zhang on 01/04/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notiviewcontrol : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet   NSDictionary *newsJson;
@property (weak, nonatomic) IBOutlet   NSString *uid;
@property (weak, nonatomic) IBOutlet UITableView *notetable;

@end
