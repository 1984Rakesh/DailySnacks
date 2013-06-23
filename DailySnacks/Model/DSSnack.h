//
//  DSSnack.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSSnackOrder;

@interface DSSnack : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSSet *snackOrders;
@end

@interface DSSnack (CoreDataGeneratedAccessors)

- (void)addSnackOrdersObject:(DSSnackOrder *)value;
- (void)removeSnackOrdersObject:(DSSnackOrder *)value;
- (void)addSnackOrders:(NSSet *)values;
- (void)removeSnackOrders:(NSSet *)values;

@end
