//
//  BookmarkViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "BookmarkViewController.h"
#import "NewBookmarkViewController.h"
#import "WordTableViewController.h"
#import "Bookmark.h"
#import "AppDelegate.h"

@interface BookmarkViewController ()

@end

@implementation BookmarkViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bookmarks = _bookmarks;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"收藏夹";
        self.tabBarItem.title = @"收藏夹";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmark)];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}

-(NSArray*)bookmarks
{
    if(_bookmarks == nil)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Bookmark" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        _bookmarks = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in _bookmarks) {
            NSLog(@"Name: %@", [info valueForKey:@"name"]);
        }
    }
    return _bookmarks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.managedObjectContext save:nil];
    _bookmarks = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBookmark
{
    NewBookmarkViewController *VC = [[NewBookmarkViewController alloc] initWithNibName:nil bundle:nil];
    VC.bookmarks = self.bookmarks;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.bookmarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Bookmark *bookmark = (Bookmark*)[self.bookmarks objectAtIndex:indexPath.row];
    cell.textLabel.text = bookmark.name;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WordTableViewController *vc = [[WordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.bookmark = self.bookmarks[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
