//
//  DSPerson.h
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSPerPersonOrder;

@interface DSPerson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *orders;
@end

@interface DSPerson (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(DSPerPersonOrder *)value;
- (void)removeOrdersObject:(DSPerPersonOrder *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
