//
//  DSPerPersonOrderViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPerPersonOrder.h"
#import "DSSnackListViewController.h"
#import "DSPersonListViewController.h"

#import "DSSnackOrderCell.h"

@interface DSPerPersonOrderViewController : UITableViewController <DSPersonListViewControllerDelegate,DSSnackListViewControllerDelegate,NSFetchedResultsControllerDelegate,DSSnackOrderCellDelegate>

@property (nonatomic, retain) DSPerPersonOrder *perPersonOrder;
@property (nonatomic, retain) DSConsolidatedOrder *consolidatedOrder;

@end
