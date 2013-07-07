//
//  DSSnackOrderCell.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSSnackOrderCellDelegate;

@interface DSSnackOrderCell : UITableViewCell {
}
@property (weak, nonatomic) IBOutlet UILabel *lblSnackCount;
@property (weak, nonatomic) IBOutlet UILabel *lblSnackName;
@property (weak, nonatomic) IBOutlet UIStepper *stepperSnackCount;
@property (nonatomic, assign) id<DSSnackOrderCellDelegate> delegate;

@end

@protocol DSSnackOrderCellDelegate <NSObject>

- (void) sanckOrderCell:(DSSnackOrderCell *)cell snackCountStepperValueChanged:(UIStepper *)stepper;

@end
