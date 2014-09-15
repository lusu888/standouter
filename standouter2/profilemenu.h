//
//  profilemenu.h
//  standouter2
//
//  Created by zhang on 20/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface profilemenu : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *profiletableview;

@end
