//
//  DSSnackListViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSSnack;
@protocol DSSnackListViewControllerDelegate;

@interface DSSnackListViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
    __unsafe_unretained id<DSSnackListViewControllerDelegate> delegate;
}
@property (nonatomic, unsafe_unretained) IBOutlet id<DSSnackListViewControllerDelegate> delegate;

@end

@protocol DSSnackListViewControllerDelegate <NSObject>

- (void) snackListViewController:(DSSnackListViewController *)snackListVC didSelectSnack:(DSSnack *)snack;

@end
