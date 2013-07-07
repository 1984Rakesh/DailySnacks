//
//  DSPersonListViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPerson.h"

@protocol DSPersonListViewControllerDelegate;

@interface DSPersonListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    __unsafe_unretained id<DSPersonListViewControllerDelegate> delegate;
}
@property (nonatomic, unsafe_unretained) IBOutlet id<DSPersonListViewControllerDelegate> delegate;

@end


@protocol DSPersonListViewControllerDelegate <NSObject>

- (void) personListViewController:(DSPersonListViewController *)personListViewController didSelectPerson:(DSPerson *)person;

@end