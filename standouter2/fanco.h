//
//  fanco.h
//  standouter2
//
//  Created by zhang on 04/03/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fanco : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet   NSDictionary *fansJSON;
@property (weak, nonatomic) IBOutlet   NSString *uid;

@end
