//
//  DSSnack.h
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSSnackOrder, DSSnackPrice;

@interface DSSnack : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *previousPrices;
@property (nonatomic, retain) NSSet *snackOrders;
@end

@interface DSSnack (CoreDataGeneratedAccessors)

- (void)addPreviousPricesObject:(DSSnackPrice *)value;
- (void)removePreviousPricesObject:(DSSnackPrice *)value;
- (void)addPreviousPrices:(NSSet *)values;
- (void)removePreviousPrices:(NSSet *)values;

- (void)addSnackOrdersObject:(DSSnackOrder *)value;
- (void)removeSnackOrdersObject:(DSSnackOrder *)value;
- (void)addSnackOrders:(NSSet *)values;
- (void)removeSnackOrders:(NSSet *)values;

@end
