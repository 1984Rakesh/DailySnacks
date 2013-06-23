//
//  DSConsolidatedOrderViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSConsolidatedOrderViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

@end
