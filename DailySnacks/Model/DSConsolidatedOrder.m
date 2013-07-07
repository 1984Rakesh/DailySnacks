//
//  DSConsolidatedOrder.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSConsolidatedOrder.h"
#import "DSPerPersonOrder.h"

#import "DSSnack.h"


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

- (NSNumber *) totalOrdersForSnack:(DSSnack *)snack {
    NSPredicate *predicateSnack = [NSPredicate predicateWithFormat:@"snack == %@",snack];
    NSPredicate *predicateConsolidateOrder = [NSPredicate predicateWithFormat:@"personOrder.consolidatedOrder == %@",self];
    NSPredicate *mainPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicateConsolidateOrder,predicateSnack,nil]];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"count"];
    NSExpression *sumSnackCountExpression = [NSExpression expressionForFunction:@"sum:"
                                                                      arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    
    NSExpressionDescription *expresionDescription = [[NSExpressionDescription alloc] init];
    [expresionDescription setName:@"sumSnackCount"];
    [expresionDescription setExpression:sumSnackCountExpression];
    [expresionDescription setExpressionResultType:NSInteger16AttributeType];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"DSSnackOrder"
                                                         inManagedObjectContext:[self managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:mainPredicate];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:expresionDescription,nil]];
    [fetchRequest setResultType:NSDictionaryResultType];

    NSNumber *count = nil;
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if( error == nil ){
        NSLog(@"%@ :: %@",[snack name],objects);
        if( [objects count] > 0 ){
            NSDictionary *dict = [objects objectAtIndex:0];
            count = [dict objectForKey:@"sumSnackCount"];
        }
    }

    return count;
}

@end
