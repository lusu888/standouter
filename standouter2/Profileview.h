//
//  Profileview.h
//  standouter2
//
//  Created by zhang on 18/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Profileview : UIViewController<UITableViewDelegate, UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView *collectionView_;
}
-(NSString *)htmltostring:(NSString*)briefdescription;
@property (weak, nonatomic) IBOutlet UIButton *profilebackbtn;
@property (weak, nonatomic) IBOutlet UILabel *profiletitle;
@property (weak, nonatomic) IBOutlet UIButton *profilemenubtn;
@property (weak, nonatomic) IBOutlet UITableView *profiletableview;

@end
