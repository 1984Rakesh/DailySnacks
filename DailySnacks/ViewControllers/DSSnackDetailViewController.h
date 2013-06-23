//
//  DSSnackDetailViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSnack.h"

@interface DSSnackDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) DSSnack *snack;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveButtonAction:(id)sender;

@end
