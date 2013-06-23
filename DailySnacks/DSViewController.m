//
//  DSViewController.m
//  DailySnacks
//
//  Created by Rakesh Patole on 22/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSViewController.h"
#import "DSConsolidatedOrder.h"

#import "DSConsolidatedOrderViewController.h"

@interface DSViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedConsolidatedOrdersResultController;

- (NSManagedObjectContext *) managedObjectContext;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;
    if( [[self fetchedConsolidatedOrdersResultController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching Consolidated Orders :: %@",[error localizedDescription]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (NSManagedObjectContext *) managedObjectContext {
    return [[DSDataModelManager sharedManager] managedObjectContext];
}

- (NSFetchedResultsController *) fetchedConsolidatedOrdersResultController {
    if( _fetchedConsolidatedOrdersResultController != nil ){
        return _fetchedConsolidatedOrdersResultController;
    }
    
    NSString *entityName = NSStringFromClass([DSConsolidatedOrder class]);
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated"
                                                                     ascending:NO];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    _fetchedConsolidatedOrdersResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     managedObjectContext:[self managedObjectContext]
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:[fetchRequest entityName]];
    [_fetchedConsolidatedOrdersResultController setDelegate:self];
    
    return _fetchedConsolidatedOrdersResultController;
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"newConsolidatedOrderSegue"] == YES ){
        DSConsolidatedOrder *consolidatedOrder = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DSConsolidatedOrder class])
                                                                               inManagedObjectContext:[self managedObjectContext]];
        DSConsolidatedOrderViewController *consolidatedOrderViewController = (DSConsolidatedOrderViewController *)[segue destinationViewController];
        [consolidatedOrderViewController setConsolidatedOrder:consolidatedOrder];
    }
    else if ([[segue identifier] isEqualToString:@"editConsolidatedOrderSegue"] == YES ) {
        DSConsolidatedOrder *consolidatedOrder = nil;
        DSConsolidatedOrderViewController *consolidatedOrderViewController = (DSConsolidatedOrderViewController *)[segue destinationViewController];
        [consolidatedOrderViewController setConsolidatedOrder:consolidatedOrder];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedConsolidatedOrdersResultController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedConsolidatedOrdersResultController] sections] objectAtIndex:section];
    NSInteger numberOfRows = [sectionInfo numberOfObjects];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
