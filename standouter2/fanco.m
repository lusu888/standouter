//
//  fanco.m
//  standouter2
//
//  Created by zhang on 04/03/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import "fanco.h"
#import "AppDelegate.h"
#import "CollectionCell.h"
#import "UIImageView+WebCache.h"


@implementation fanco{
    NSArray *recipeImages;
    
    NSData *data;
        
    AppDelegate *myDelegate ;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        [self setDelegate:self];
        [self setDataSource:self];
        [self setBackgroundColor: [UIColor yellowColor]];
        
        myDelegate = [[UIApplication sharedApplication] delegate];
        self.uid= myDelegate.profileid;
        // KCellID为宏定义 @"CollectionCell"
        
        // KCellID为宏定义 @"CollectionCell"
        NSURL *url = [NSURL URLWithString:@"http://fakeimg.pl/80x80/?text=Wait&font=lobster" ];
        data = [NSData dataWithContentsOfURL:url];
        
        [self registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        NSLog(self.fansJSON);
    }
    return self;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [[self.fansJSON objectForKey:@"total"] integerValue];;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [[self.fansJSON objectForKey:@"total"] integerValue];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    CollectionCell *cell = (CollectionCell *)[cv dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    NSString *imgurl=[[[self.fansJSON objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"imageProfileCustomUrl"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", myDelegate.webaddress, imgurl ]];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    
    [cell.fanfoto setImageWithURL:url placeholderImage:[[UIImage alloc] initWithData:data ]];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
