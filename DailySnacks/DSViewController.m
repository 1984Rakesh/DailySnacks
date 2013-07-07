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
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSDateFormatter *) longStyleDateFormatter;

@end

@implementation DSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    if( [[self fetchedConsolidatedOrdersResultController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching Consolidated Orders :: %@",[error localizedDescription]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private
- (NSDateFormatter *) longStyleDateFormatter {
    static NSDateFormatter *longStyleDateFormatter = nil;
    if( longStyleDateFormatter == nil ){
        longStyleDateFormatter = [[NSDateFormatter alloc] init];
        [longStyleDateFormatter setDateStyle:NSDateFormatterLongStyle];
        [longStyleDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return longStyleDateFormatter;
}

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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    DSConsolidatedOrder *consolidatedOrder = [[self fetchedConsolidatedOrdersResultController] objectAtIndexPath:indexPath];
    
    NSDateFormatter *mediumStyleDateFormatter = [self longStyleDateFormatter];
    NSString *dateCreated = [mediumStyleDateFormatter stringFromDate:[consolidatedOrder dateCreated]];
    
    [[cell textLabel] setText:dateCreated];
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
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:(UITableViewCell *)sender];
        DSConsolidatedOrder *consolidatedOrder = [[self fetchedConsolidatedOrdersResultController] objectAtIndexPath:indexPath];
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
    static NSString *CellIdentifier = @"DSConsolidatedOrderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller
   didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
            atIndex:(NSUInteger)sectionIndex
      forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}

@end
