//
//  DSConsolidatedOrder.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSConsolidatedOrder.h"
#import "DSPerPersonOrder.h"


@implementation DSConsolidatedOrder

@dynamic dateCreated;
@dynamic perPersonOrders;

- (void) awakeFromInsert {
    [self setDateCreated:[NSDate date]];
}

- (NSNumber *) orderTotal {
    NSNumber *orderTotal = [[self perPersonOrders] valueForKeyPath:@"@sum.orderTotal"];
    return orderTotal;
}

@end
