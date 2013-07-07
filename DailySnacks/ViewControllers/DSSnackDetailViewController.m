//
//  DSSnackDetailViewController.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSSnackDetailViewController.h"

@interface DSSnackDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end

@implementation DSSnackDetailViewController

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
    
    [[self nameTextField] setText:[[self snack] name]];
    [[self priceTextField] setText:[[[self snack] price] stringValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public
- (DSSnack *) snack {
    if( _snack == nil ) {
        isNew = YES;
        _snack = [NSEntityDescription insertNewObjectForEntityForName:@"DSSnack"
                                               inManagedObjectContext:[self managedObjectContext]];
    }
    
    return _snack;
}

#pragma mark - UITextFeildDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if( [textField isEqual:[self nameTextField]] == YES ){
        [[self snack] setName:[textField text]];
    }
    else if ([textField isEqual:[self priceTextField]] == YES ){
        float price = [[textField text] floatValue];
        [[self snack] setPrice:[NSNumber numberWithFloat:price]];
    }
}

#pragma mark - Button Actions
- (IBAction)saveButtonAction:(id)sender {
    [[self nameTextField] resignFirstResponder];
    [[self priceTextField] resignFirstResponder];
    NSError *error = nil;
    if( [[self managedObjectContext] save:&error] == NO ){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    if( isNew == YES ){
        [[self managedObjectContext] deleteObject:[self snack]];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
