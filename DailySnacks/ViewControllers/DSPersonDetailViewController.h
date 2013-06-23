//
//  DSPersonDetailViewController.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPerson.h"

@interface DSPersonDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) DSPerson *person;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveButtonAction:(id)sender;

@end
