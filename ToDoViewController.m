//
//  ToDoViewController.m
//  EveryDo250516V2
//
//  Created by Yasmin Ahmad on 2016-05-25.
//  Copyright © 2016 YasminA. All rights reserved.
//

#import "ToDoViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "ToDo.h"

@interface ToDoViewController ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *taskTable;
@property (strong, nonatomic) IBOutlet UITextField *taskField;
@property (strong, nonatomic) IBOutlet UITextField *taskDetailsField;
@property (strong, nonatomic) IBOutlet UITextField *priorityField;
@property (strong, nonatomic) NSFetchedResultsController *fetchedController;

@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    
    //create instance of moc to manage collection of objects
    NSManagedObjectContext *moc = appDel.managedObjectContext;
    
    //describes criteria used to sort data and how to list in table view. in this case task 'priority'
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ToDo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES]];
    
    self.fetchedController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    self.fetchedController.delegate = self;
    [self.fetchedController performFetch:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveNewTask:(id)sender {
    
    
    
    
    NSManagedObjectContext *moc = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSArray *defaultTaskArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"ToDo"];
    ToDo *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo" inManagedObjectContext:moc];
    
    if ([self.taskField.text isEqualToString:@""]) {
        
        newTask.task = defaultTaskArray[0];
        newTask.details = defaultTaskArray[1];
        newTask.priority = defaultTaskArray[2];
        [moc save:nil];
    }
    
    else if ([self.taskDetailsField.text isEqualToString:@""]){

        newTask.task = defaultTaskArray[0];
        newTask.details = defaultTaskArray[1];
        newTask.priority = defaultTaskArray[2];
        [moc save:nil];
    }
    
    else if ([self.priorityField.text isEqualToString:@""]){
        
        newTask.task = defaultTaskArray[0];
        newTask.details = defaultTaskArray[1];
        newTask.priority = defaultTaskArray[2];
        [moc save:nil];
    }
    else{
        ToDo *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo" inManagedObjectContext:moc];
        newTask.task = self.taskField.text;
        newTask.details = self.taskDetailsField.text;
        newTask.priority = self.priorityField.text;
        [moc save:nil];
    }
    self.taskField.text = @"";
    self.taskDetailsField.text = @"";
    self.priorityField.text = @"";
    
    
}

- (IBAction)setDefaultTask:(id)sender {
    
    NSArray *defaultTaskArray = [[NSArray alloc]initWithObjects:@"Bookstore", @"Buy new book to read", @"2", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:defaultTaskArray forKey:@"ToDo"];
    [defaults synchronize];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        NSIndexPath *indexPath = [self.taskTable indexPathForSelectedRow];
        ToDo *selectedToDo = [self.fetchedController objectAtIndexPath:indexPath];
        DetailViewController *dvc = [segue destinationViewController];
        dvc.task = selectedToDo;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedController.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedController.sections[section] numberOfObjects];
}


- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    ToDo *task = [self.fetchedController objectAtIndexPath:indexPath];
    UILabel *taskLabel = [cell viewWithTag:1];
    taskLabel.text = [NSString stringWithFormat:@"Task: %@  Priority: %@", task.task, task.priority];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDo *task;
    NSManagedObjectContext *moc = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
            task = [self.fetchedController objectAtIndexPath:indexPath];
            [moc deleteObject:task];
            [moc save:nil];
            break;
            
        default:
            break;
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.taskTable beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.taskTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.taskTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.taskTable;
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


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.taskTable endUpdates];
}

@end
