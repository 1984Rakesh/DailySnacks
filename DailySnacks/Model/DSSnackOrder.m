//
//  DSSnackOrder.m
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSSnackOrder.h"
#import "DSPerPersonOrder.h"
#import "DSSnack.h"


@implementation DSSnackOrder

@dynamic count;
@dynamic snack;
@dynamic personOrder;

- (NSNumber *) total {
    float total = [[[self snack] price] floatValue] * [[self count] intValue];
    return [NSNumber numberWithFloat:total];
}

@end
