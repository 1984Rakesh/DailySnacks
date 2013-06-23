//
//  DSSnackListViewController.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSSnackListViewController.h"
#import "DSSnackDetailViewController.h"
#import "DSSnackDetailCell.h"

@interface DSSnackListViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedSnackResultController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation DSSnackListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    if( [[self fetchedSnackResultController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching Snack :: %@",[error localizedDescription]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private
- (NSManagedObjectContext *) managedObjectContext {
    if( _managedObjectContext != nil ){
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:[[DSDataModelManager sharedManager] persistentStoreCoordinator]];
    
    return _managedObjectContext;
}

- (NSFetchedResultsController *) fetchedSnackResultController {
    if( _fetchedSnackResultController != nil ){
        return _fetchedSnackResultController;
    }
    
    NSString *entityName = NSStringFromClass([DSSnack class]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    _fetchedSnackResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                         managedObjectContext:[self managedObjectContext]
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:entityName];
    [_fetchedSnackResultController setDelegate:self];
    return _fetchedSnackResultController;
}


 #pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"newSnackSegue"] == YES ){
        NSString *entityName = NSStringFromClass([DSSnack class]);
        DSSnack *snack = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                       inManagedObjectContext:[self managedObjectContext]];
        DSSnackDetailViewController *snackDetailViewController = [segue destinationViewController];
        [snackDetailViewController setSnack:snack];
        [snackDetailViewController setManagedObjectContext:[self managedObjectContext]];
    }
    else if ([[segue identifier] isEqualToString:@"editSnackSegue"] == YES ){
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:(UITableViewCell *)sender];
        id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedSnackResultController] sections] objectAtIndex:[indexPath section]];
        DSSnack *snack = [[sectionInfo objects] objectAtIndex:[indexPath row]];
        DSSnackDetailViewController *snackDetailViewController = [segue destinationViewController];
        [snackDetailViewController setSnack:snack];
        [snackDetailViewController setManagedObjectContext:[self managedObjectContext]];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedSnackResultController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedSnackResultController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DSSnackDetailCell";
    DSSnackDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedSnackResultController] sections] objectAtIndex:[indexPath section]];
    DSSnack *snack = [[sectionInfo objects] objectAtIndex:[indexPath row]];
    
    [[cell nameLabel] setText:[snack name]];
    [[cell priceLabel] setText:[[snack price] stringValue]];
    
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
            //            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
            //                    atIndexPath:indexPath];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
