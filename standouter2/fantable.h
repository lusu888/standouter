//
//  fantable.h
//  standouter2
//
//  Created by zhang on 21/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fantable : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet   NSDictionary *fansJSON;
@property (weak, nonatomic) IBOutlet   NSString *uid;




@end
