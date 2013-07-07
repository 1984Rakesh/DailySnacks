//
//  DSConsolidatedOrder.h
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSPerPersonOrder;
@class DSSnack;

@interface DSConsolidatedOrder : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSSet *perPersonOrders;

- (NSNumber *) orderTotal;
- (NSNumber *) totalOrdersForSnack:(DSSnack *)snack;

@end

@interface DSConsolidatedOrder (CoreDataGeneratedAccessors)

- (void)addPerPersonOrdersObject:(DSPerPersonOrder *)value;
- (void)removePerPersonOrdersObject:(DSPerPersonOrder *)value;
- (void)addPerPersonOrders:(NSSet *)values;
- (void)removePerPersonOrders:(NSSet *)values;

@end
