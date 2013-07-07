//
//  DSPerPersonOrderViewController.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSPerPersonOrderViewController.h"
#import "DSSnackOrderViewController.h"

#import "DSConsolidatedOrder.h"
#import "DSSnackOrder.h"
#import "DSSnack.h"

@interface DSPerPersonOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedPersonName;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTotal;
@property (nonatomic, retain) NSFetchedResultsController *snackOrdersFetchedResultsController;

- (DSSnackOrder *) newSnackOrderForSnack:(DSSnack *)snack;

- (void) updateHeaderView;
- (void)configureCell:(DSSnackOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DSPerPersonOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    if( [[self snackOrdersFetchedResultsController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching People :: %@",[error localizedDescription]);
    }
    
    [self updateHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (DSPerPersonOrder *) perPersonOrder {
    if( _perPersonOrder == nil ){
        _perPersonOrder = [NSEntityDescription insertNewObjectForEntityForName:@"DSPerPersonOrder"
                                                        inManagedObjectContext:[[DSDataModelManager sharedManager] managedObjectContext]];
        [[self consolidatedOrder] addPerPersonOrdersObject:_perPersonOrder];
        
    }
    return _perPersonOrder;
}

#pragma mark - Private
- (void) updateHeaderView {
    [[self lblSelectedPersonName] setText:[[[self perPersonOrder] person] name]];
    NSNumber *orderTotal = [[self perPersonOrder] orderTotal];
    [[self lblOrderTotal] setText:[orderTotal stringValue]];
}


- (DSSnackOrder *) newSnackOrderForSnack:(DSSnack *)snack {
    DSSnackOrder *snackOrder = [NSEntityDescription insertNewObjectForEntityForName:@"DSSnackOrder"
                                                             inManagedObjectContext:[[DSDataModelManager sharedManager] managedObjectContext]];
    [snackOrder setSnack:snack];
    return snackOrder;
}

- (NSFetchedResultsController *) snackOrdersFetchedResultsController {
    if( _snackOrdersFetchedResultsController == nil ){
        
        NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"personOrder == %@",[self perPersonOrder]];
        NSSortDescriptor *fetchSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"snack.name"
                                                                              ascending:YES];
        
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DSSnackOrder"];
        [fetchRequest setPredicate:fetchPredicate];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:fetchSortDescriptor]];
        
        
        _snackOrdersFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                   managedObjectContext:[[DSDataModelManager sharedManager] managedObjectContext]
                                                                                     sectionNameKeyPath:nil
                                                                                              cacheName:nil];
        [_snackOrdersFetchedResultsController setDelegate:self];
    }
    
    return _snackOrdersFetchedResultsController;
}

- (void)configureCell:(DSSnackOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    DSSnackOrder *snackOrder = [[self snackOrdersFetchedResultsController] objectAtIndexPath:indexPath];
    [[cell lblSnackName] setText:[[snackOrder snack] name]];
    [[cell lblSnackCount] setText:[[snackOrder count] stringValue]];
    [[cell stepperSnackCount] setValue:[[snackOrder count] doubleValue]];
    [cell setDelegate:self];
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"addSnackSegue"] == YES ){
        DSSnackListViewController *snackListViewController = [segue destinationViewController];
        [snackListViewController setDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"selectPersonSegue"] == YES ){
        DSPersonListViewController *personListViewController = (DSPersonListViewController *)[segue destinationViewController];
        [personListViewController setDelegate:self];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self snackOrdersFetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self snackOrdersFetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DSSnackOrderCell";
    DSSnackOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
    [self updateHeaderView];
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
    [[self tableView] endUpdates];
}

#pragma mark Snack Order Cell Delegate
- (void) sanckOrderCell:(DSSnackOrderCell *)cell snackCountStepperValueChanged:(UIStepper *)stepper {
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
    
    DSSnackOrder *snackOrder = [[self snackOrdersFetchedResultsController] objectAtIndexPath:indexPath];
    [snackOrder setCount:[NSNumber numberWithDouble:[stepper value]]];
    
    [self updateHeaderView];
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Preson List View Controller Delegate
- (void) personListViewController:(DSPersonListViewController *)personListViewController didSelectPerson:(DSPerson *)person {
    [[self perPersonOrder] setPerson:person];
    [self updateHeaderView];
}

#pragma mark - Snack List View Delegate
- (void) snackListViewController:(DSSnackListViewController *)snackListVC didSelectSnack:(DSSnack *)snack {
    DSSnackOrder *newSnackOrder = [self newSnackOrderForSnack:snack];
    [[self perPersonOrder] addSnackOrdersObject:newSnackOrder];
}

@end
