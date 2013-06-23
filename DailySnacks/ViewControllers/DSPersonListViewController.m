//
//  DSPersonListViewController.m
//  DailySnacks
//
//  Created by Rakesh Patole on 23/06/13.
//  Copyright (c) 2013 Rakesh Patole. All rights reserved.
//

#import "DSPersonListViewController.h"
#import "DSPersonDetailViewController.h"
#import "DSPersonCell.h"

@interface DSPersonListViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedPeopleResultController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation DSPersonListViewController

@synthesize delegate;

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
    if( [[self fetchedPeopleResultController] performFetch:&error] == NO ){
        NSLog(@"Error Fetching People :: %@",[error localizedDescription]);
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

- (NSFetchedResultsController *) fetchedPeopleResultController {
    if( _fetchedPeopleResultController != nil ){
        return _fetchedPeopleResultController;
    }
    
    NSString *entityName = NSStringFromClass([DSPerson class]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    _fetchedPeopleResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                         managedObjectContext:[self managedObjectContext]
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:entityName];
    [_fetchedPeopleResultController setDelegate:self];
    return _fetchedPeopleResultController;
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if( [[segue identifier] isEqualToString:@"newPersonSegue"] == YES ){
         DSPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"DSPerson"
                                                          inManagedObjectContext:[self managedObjectContext]];
         DSPersonDetailViewController *personDetailViewController = [segue destinationViewController];
         [personDetailViewController setPerson:person];
         [personDetailViewController setManagedObjectContext:[self managedObjectContext]];
     }
     else if( [[segue identifier] isEqualToString:@"editPersonSegue"] == YES ){
         NSIndexPath *indexPath = [[self tableView] indexPathForCell:(DSPersonCell *)sender];
         id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedPeopleResultController] sections] objectAtIndex:[indexPath section]];
         DSPerson *person = [[sectionInfo objects] objectAtIndex:[indexPath row]];
         DSPersonDetailViewController *personDetailViewController = [segue destinationViewController];
         [personDetailViewController setPerson:person];
         [personDetailViewController setManagedObjectContext:[self managedObjectContext]];
     }
 }
 
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedPeopleResultController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedPeopleResultController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DSPersonCell";
    DSPersonCell *cell = (DSPersonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedPeopleResultController] sections] objectAtIndex:[indexPath section]];
    DSPerson *person = [[sectionInfo objects] objectAtIndex:[indexPath row]];
    
    [[cell nameLabel] setText:[person name]];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedPeopleResultController] sections] objectAtIndex:[indexPath section]];
    DSPerson *person = [[sectionInfo objects] objectAtIndex:[indexPath row]];
    
    if( delegate != nil ){
        [delegate personListViewController:self
                           didSelectPerson:person];
    }
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



@end

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
