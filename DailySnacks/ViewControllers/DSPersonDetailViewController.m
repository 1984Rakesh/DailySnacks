//
//  DSPersonDetailViewController.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSPersonDetailViewController.h"

@interface DSPersonDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation DSPersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self nameTextField] setText:[[self person] name]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [[self person] setName:[textField text]];
}

#pragma mark - Button Actions
- (IBAction)saveButtonAction:(id)sender {
    [[self nameTextField] resignFirstResponder];
    NSError *error = nil;
    if( [[self managedObjectContext] save:&error] == NO ){
        NSLog(@"Error Saving Person :: %@",[error localizedDescription]);
    }
}

@end
