//
//  Hengtableview.h
//  standouter2
//
//  Created by zhang on 14/03/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hengtableview : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet   NSDictionary *myJson;


@end
