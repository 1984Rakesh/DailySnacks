//
//  DSSnackPrice.h
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSSnack;

@interface DSSnackPrice : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) DSSnack *snack;

@end
