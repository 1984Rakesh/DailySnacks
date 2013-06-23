//
//  DSPerPersonOrderViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPerPersonOrder.h"
#import "DSPersonListViewController.h"

@interface DSPerPersonOrderViewController : UITableViewController <DSPersonListViewControllerDelegate>

@property (nonatomic, retain) DSPerPersonOrder *perPersonOrder;

@end
