//
//  newstable.h
//  standouter2
//
//  Created by zhang on 06/03/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newstable : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet   NSDictionary *newsJson;
@property (weak, nonatomic) IBOutlet   NSString *uid;

@end
