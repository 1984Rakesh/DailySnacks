//
//  DSSnackOrderViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSnackListViewController.h"

@class DSPerPersonOrder;

@interface DSSnackOrderViewController : UITableViewController 

@property (nonatomic, retain) DSPerPersonOrder *perPersonOrder;

@end
