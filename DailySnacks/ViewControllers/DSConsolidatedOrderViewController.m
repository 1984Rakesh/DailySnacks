//
//  DSConsolidatedOrderViewController.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSConsolidatedOrderViewController.h"
#import "DSPerPersonOrderViewController.h"


#import "DSConsolidatedOrder.h"

@interface DSConsolidatedOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTotal;

@property (nonatomic, retain) NSFetchedResultsController *perPersonOrderFetchedResultsController;

- (NSManagedObjectContext *) managedObjectContext;

- (void)updateHeaderView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DSConsolidatedOrderViewController

NS_ENUM( NSInteger, ListSortType) {
    kSortListByPerson,
    kSortListBySnacks
};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    if( [[self perPersonOrderFetchedResultsController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching People :: %@",[error localizedDescription]);
    }
    
    [self updateHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public 
- (DSConsolidatedOrder *) consolidatedOrder {
    if( _consolidatedOrder == nil ) {
        _consolidatedOrder = [NSEntityDescription insertNewObjectForEntityForName:@"DSConsolidatedOrder"
                                                           inManagedObjectContext:[self managedObjectContext]];
        isNew = YES;
    }
    
    return _consolidatedOrder;
}

#pragma mark - Private
- (NSManagedObjectContext *) managedObjectContext {
    return [[DSDataModelManager sharedManager] managedObjectContext];
}

- (NSFetchedResultsController *) perPersonOrderFetchedResultsController {
    if( _perPersonOrderFetchedResultsController == nil ){
        
        NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"consolidatedOrder == %@",[self consolidatedOrder]];
        NSSortDescriptor *fetchSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"person.name"
                                                                              ascending:YES];
        
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DSPerPersonOrder"];
        [fetchRequest setPredicate:fetchPredicate];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:fetchSortDescriptor]];
        
        
        _perPersonOrderFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                   managedObjectContext:[[DSDataModelManager sharedManager] managedObjectContext]
                                                                                     sectionNameKeyPath:nil
                                                                                              cacheName:nil];
        [_perPersonOrderFetchedResultsController setDelegate:self];
    }
    
    return _perPersonOrderFetchedResultsController;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    DSPerPersonOrder *perPersomOrder = [[self perPersonOrderFetchedResultsController] objectAtIndexPath:indexPath];
    [[cell textLabel] setText:[[perPersomOrder person] name]];
    [[cell detailTextLabel] setText:[[perPersomOrder orderTotal] stringValue]];
}

- (void)updateHeaderView {
    NSString *perOrderTotal = [[[self consolidatedOrder] orderTotal] stringValue];
    perOrderTotal = [@"Order Total :: " stringByAppendingString:perOrderTotal];
    [[self lblOrderTotal] setText:perOrderTotal];
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"editPerPersonOrder"] == YES ){
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:(UITableViewCell *)sender];
        DSPerPersonOrder *perPersonOrder = [[self perPersonOrderFetchedResultsController] objectAtIndexPath:indexPath];
        DSPerPersonOrderViewController *perPersonOrderViewController = [segue destinationViewController];
        [perPersonOrderViewController setPerPersonOrder:perPersonOrder];
    }
    else if ( [[segue identifier] isEqualToString:@"newPerPersonOrder"] == YES ){
        DSPerPersonOrderViewController *perPersonOrderViewController = [segue destinationViewController];
        [perPersonOrderViewController setConsolidatedOrder:[self consolidatedOrder]];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = [[[self perPersonOrderFetchedResultsController] sections] count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self perPersonOrderFetchedResultsController] sections] objectAtIndex:section];
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
            [self configureCell:(DSSnackOrderCell *)[tableView cellForRowAtIndexPath:indexPath]
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
    [self updateHeaderView];
    [[self tableView] endUpdates];
}


@end
