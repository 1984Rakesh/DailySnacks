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
#import "DSSnackOrder.h"
#import "DSSnack.h"

typedef NS_ENUM( NSInteger, ListSortType) {
    kSortListByPerson = 0,
    kSortListBySnacks = 1
};

@interface DSConsolidatedOrderViewController () {
    ListSortType listSortType;
}
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTotal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segcSortListType;
@property (nonatomic, retain) NSFetchedResultsController *sortListByPersonFetchedResultController;
@property (nonatomic, retain) NSFetchedResultsController *sortListBySnackFetchedResultController;

- (NSFetchedResultsController *) perPersonOrderFetchedResultsController;
- (NSManagedObjectContext *) managedObjectContext;
- (NSPredicate *) fetchPredicate;
- (DSPerPersonOrder *) perPersonOrderAtIndexPath:(NSIndexPath *)indexPath;
- (void) updateFetchResultController;

- (void) setListSortType:(ListSortType)type;
- (void) updateHeaderView;
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DSConsolidatedOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    if( [[self sortListByPersonFetchedResultController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching People :: %@",[error localizedDescription]);
    }
    
    if( [[self sortListBySnackFetchedResultController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching People :: %@",[error localizedDescription]);
    }
    
    [self setListSortType:[[self segcSortListType] selectedSegmentIndex]];
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

#pragma mark - Actions
- (IBAction)segcSortListTypeChanged:(id)sender {
    [self setListSortType:[(UISegmentedControl *)sender selectedSegmentIndex]];
}

#pragma mark - Private
- (NSManagedObjectContext *) managedObjectContext {
    return [[DSDataModelManager sharedManager] managedObjectContext];
}

- (NSPredicate *)fetchPredicate {
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"consolidatedOrder == %@",[self consolidatedOrder]];
    return fetchPredicate;
}

- (void) updateFetchResultController {
}

- (NSFetchedResultsController *) perPersonOrderFetchedResultsController {
    NSFetchedResultsController *returnFetchedResultsController = nil;
    
    switch (listSortType) {
        case kSortListByPerson:
            returnFetchedResultsController = [self sortListByPersonFetchedResultController];
            break;
            
        case kSortListBySnacks:
            returnFetchedResultsController = [self sortListBySnackFetchedResultController];
            break;
    }
    
    return returnFetchedResultsController;
    

}

-(NSFetchedResultsController *)sortListByPersonFetchedResultController {
    if( _sortListByPersonFetchedResultController == nil ){

        NSPredicate *fetchPredicate = [self fetchPredicate];
        NSSortDescriptor *fetchSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"person.name"
                                                                              ascending:YES];


        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DSPerPersonOrder"];
        [fetchRequest setPredicate:fetchPredicate];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:fetchSortDescriptor]];


        _sortListByPersonFetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                   managedObjectContext:[[DSDataModelManager sharedManager] managedObjectContext]
                                                                                     sectionNameKeyPath:nil
                                                                                              cacheName:nil];
        [_sortListByPersonFetchedResultController setDelegate:self];
    }
    
    return _sortListByPersonFetchedResultController;
}

-(NSFetchedResultsController *)sortListBySnackFetchedResultController {
    if( _sortListBySnackFetchedResultController == nil ){
        
        NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"personOrder.consolidatedOrder == %@",[self consolidatedOrder]];
        NSSortDescriptor *fetchSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"snack.name"
                                                                              ascending:YES];
        
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DSSnackOrder"];
        [fetchRequest setPredicate:fetchPredicate];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:fetchSortDescriptor]];
        
        
        _sortListBySnackFetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                       managedObjectContext:[[DSDataModelManager sharedManager] managedObjectContext]
                                                                                         sectionNameKeyPath:@"snack.name"
                                                                                                  cacheName:nil];
        [_sortListBySnackFetchedResultController setDelegate:self];
    }
    
    return _sortListBySnackFetchedResultController;
}

- (DSPerPersonOrder *) perPersonOrderAtIndexPath:(NSIndexPath *)indexPath {
    DSPerPersonOrder *perPersonOrder = nil;
    switch (listSortType) {
        case kSortListByPerson:
            perPersonOrder = [[self sortListByPersonFetchedResultController] objectAtIndexPath:indexPath];
            break;
            
        case kSortListBySnacks: {
            DSSnackOrder *snackOrder = [[self sortListBySnackFetchedResultController] objectAtIndexPath:indexPath];
            perPersonOrder = [snackOrder personOrder];
        }
            break;
    }
    return perPersonOrder;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if( listSortType == kSortListByPerson ){
        DSPerPersonOrder *perPersomOrder = [[self perPersonOrderFetchedResultsController] objectAtIndexPath:indexPath];
        [[cell textLabel] setText:[[perPersomOrder person] name]];
        [[cell detailTextLabel] setText:[[perPersomOrder orderTotal] stringValue]];
    }
    else {
        DSSnackOrder *snackOrder = [[self perPersonOrderFetchedResultsController] objectAtIndexPath:indexPath];
        [[cell textLabel] setText:[[[snackOrder personOrder] person] name]];
        [[cell detailTextLabel] setText:[[snackOrder count] stringValue]];
    }
}

- (void)updateHeaderView {
    NSString *perOrderTotal = [[[self consolidatedOrder] orderTotal] stringValue];
    perOrderTotal = [@"Order Total :: " stringByAppendingString:perOrderTotal];
    [[self lblOrderTotal] setText:perOrderTotal];
}

- (void) setListSortType:(ListSortType)type {
    listSortType = type;
    [[self tableView] reloadData];
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"editPerPersonOrder"] == YES ){
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:(UITableViewCell *)sender];
        DSPerPersonOrder *perPersonOrder = [self perPersonOrderAtIndexPath:indexPath];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = nil;
    if( listSortType == kSortListBySnacks ){
        id<NSFetchedResultsSectionInfo> sectionInfo = [[[self perPersonOrderFetchedResultsController] sections] objectAtIndex:section];
        DSSnack *snack = [(DSSnackOrder *)[[sectionInfo objects] objectAtIndex:0] snack];
        sectionTitle = [sectionInfo name];
        NSNumber *totalOrderForSnack = [[self consolidatedOrder] totalOrdersForSnack:snack];
        sectionTitle = [sectionTitle stringByAppendingFormat:@" :: %@",[totalOrderForSnack stringValue]];
    }
    return sectionTitle;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if( [controller isEqual:[self perPersonOrderFetchedResultsController]] == YES ){
        [[self tableView] beginUpdates];
    }
}

- (void) controller:(NSFetchedResultsController *)controller
   didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
            atIndex:(NSUInteger)sectionIndex
      forChangeType:(NSFetchedResultsChangeType)type {
    if( [controller isEqual:[self perPersonOrderFetchedResultsController]] == NO ){
        return;
    }
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
    if( [controller isEqual:[self perPersonOrderFetchedResultsController]] == NO ){
        return;
    }
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
    if( [controller isEqual:[self perPersonOrderFetchedResultsController]] == NO ){
        return;
    }
    [self updateHeaderView];
    [[self tableView] endUpdates];
}


@end
