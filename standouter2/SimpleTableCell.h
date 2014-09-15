//
//  SimpleTableCell.h
//  standouter2
//
//  Created by zhang on 05/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell{
    NSString *cellvid;
}
@property (weak, nonatomic) IBOutlet UIButton *namebtn;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *votecont;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, retain) IBOutlet NSString *cellvid;
@end
