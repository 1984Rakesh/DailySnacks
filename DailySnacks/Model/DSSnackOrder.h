//
//  DSSnackOrder.h
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSPerPersonOrder, DSSnack;

@interface DSSnackOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) DSSnack *snack;
@property (nonatomic, retain) DSPerPersonOrder *personOrder;

- (NSNumber *) total;

@end
