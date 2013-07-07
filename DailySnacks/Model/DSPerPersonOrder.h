//
//  DSPerPersonOrder.h
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSConsolidatedOrder, DSPerson, DSSnackOrder;

@interface DSPerPersonOrder : NSManagedObject

@property (nonatomic, retain) DSConsolidatedOrder *consolidatedOrder;
@property (nonatomic, retain) DSPerson *person;
@property (nonatomic, retain) NSSet *snackOrders;

- (NSNumber *) orderTotal;

@end

@interface DSPerPersonOrder (CoreDataGeneratedAccessors)

- (void)addSnackOrdersObject:(DSSnackOrder *)value;
- (void)removeSnackOrdersObject:(DSSnackOrder *)value;
- (void)addSnackOrders:(NSSet *)values;
- (void)removeSnackOrders:(NSSet *)values;

@end
