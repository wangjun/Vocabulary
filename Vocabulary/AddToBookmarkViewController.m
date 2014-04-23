//
//  AddToBookmarkViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "AddToBookmarkViewController.h"
#import "Bookmark.h"
#import "AppDelegate.h"
#import "Word.h"

@interface AddToBookmarkViewController ()
@property (nonatomic,strong,readonly) NSArray *word_hadsmarks;
@end

@implementation AddToBookmarkViewController

@synthesize word = _word;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bookmarks = _bookmarks;
@synthesize word_hadsmarks = _word_hadsmarks;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"添加到收藏夹";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSave)];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

-(void)setBookmarks:(NSArray *)bookmarks
{
    _bookmarks = bookmarks;
}

-(NSArray*)word_hadsmarks
{
    if(_word_hadsmarks == nil)
    {
        _word_hadsmarks = [self.word.bookmarks allObjects];
    }
    return _word_hadsmarks;
}
-(void)setWord:(NSString*)wordString
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Word" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"word = %@",wordString];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    _word = (Word*)[_managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.managedObjectContext save:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookmarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookmarkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType != UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.word addBookmarks:[NSSet setWithObject:bookmark]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.word removeBookmarks:[NSSet setWithObject:bookmark]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    if([self.word_hadsmarks containsObject:bookmark])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = bookmark.name;
}

-(void)doneSave
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

