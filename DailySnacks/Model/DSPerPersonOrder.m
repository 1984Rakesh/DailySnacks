//
//  DSPerPersonOrder.m
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSPerPersonOrder.h"
#import "DSConsolidatedOrder.h"
#import "DSPerson.h"
#import "DSSnackOrder.h"


@implementation DSPerPersonOrder

@dynamic consolidatedOrder;
@dynamic person;
@dynamic snackOrders;

#pragma mark - Private
- (NSNumber *) orderTotal {
    NSNumber *total = [[self snackOrders] valueForKeyPath:@"@sum.total"];
    return total;
}

- (DSSnackOrder *) snackOrderForSnack:(DSSnack *)snack {
    return nil;
}

@end
