//
//  ViewController.h
//  standouter2
//
//  Created by zhang on 06/02/14.
//  Copyright (c) 2014 standouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "footerview.h"
#import "EGORefreshTableHeaderView.h"


@interface ViewController : UIViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource>{

    
	EGORefreshTableHeaderView *_refreshHeaderView;
    footerview *_refreshFooterView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;


}
@property (weak, nonatomic) IBOutlet UIView *textview;
@property (weak, nonatomic) IBOutlet UITableView *tableviewmain;

@property (weak, nonatomic) IBOutlet UIButton *menuleftmainbtn;
@property (weak, nonatomic) IBOutlet UIButton *menurightmainbtn;
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UIImageView *briefvideoimg;
@property (weak, nonatomic) IBOutlet UITextView *brieftext;
-(NSString *)htmltostring:(NSString*)briefdescription;
-(void) gotologin;
-(void)tableviewinit;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void)playerinit;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;
@end
