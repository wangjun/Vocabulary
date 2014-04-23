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
#import "Word_Bookmark.h"

@interface AddToBookmarkViewController ()
@property (nonatomic,strong) NSMutableArray *latest_bookmarks;
@end

@implementation AddToBookmarkViewController

@synthesize word = _word;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bookmarks = _bookmarks;
@synthesize latest_bookmarks = _latest_bookmarks;

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
        NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSManagedObject *info in array) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Word_Bookmark" inManagedObjectContext:_managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@ AND bookmark = %@",self.word,info];
            fetchRequest.predicate = predicate;
            NSError *error;
            NSArray *word_bookmarks = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableDictionary *dic;
            if(word_bookmarks.count == 0)
            {
                dic = [NSMutableDictionary dictionary];
                [dic setValue:@"NO" forKey:@"now_have"];
                [dic setValue:@"NO" forKey:@"old_have"];
                [dic setValue:info forKey:@"value"];
            }
            else
            {
                dic = [NSMutableDictionary dictionary];
                [dic setValue:@"YES" forKey:@"now_have"];
                [dic setValue:@"YES" forKey:@"old_have"];
                [dic setValue:info forKey:@"value"];
            }
            [mutableArray addObject:dic];
        }
        _bookmarks = mutableArray;
    }
    return _bookmarks;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(cell.accessoryType != UITableViewCellAccessoryCheckmark)
    {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.bookmarks[indexPath.row] setValue:@"YES" forKey:@"now_have"];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.bookmarks[indexPath.row] setValue:@"NO" forKey:@"now_have"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    if([[bookmark valueForKey:@"now_have"] isEqual:@"YES"])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [[bookmark valueForKey:@"value"] valueForKey:@"name"];
}

-(void)doneSave
{
    for (NSDictionary *dic in self.bookmarks) {
        if([[dic valueForKey:@"old_have"] isEqual: @"YES"] && [[dic valueForKey:@"now_have"] isEqual: @"NO"])
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Word_Bookmark" inManagedObjectContext:_managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@ AND bookmark = %@",self.word,[dic valueForKey:@"value"]];
            fetchRequest.predicate = predicate;
            NSError *error;
            NSArray *word_bookmarks = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
            [self.managedObjectContext deleteObject:word_bookmarks[0]];

        }
        if([[dic valueForKey:@"old_have"] isEqual: @"NO"] && [[dic valueForKey:@"needDelete"] isEqual: @"YES"])
        {
            NSManagedObjectContext *context = [self managedObjectContext];
            Word_Bookmark *word = (Word_Bookmark*)[NSEntityDescription
                                 insertNewObjectForEntityForName:@"Word_Bookmark"
                                 inManagedObjectContext:context];
            word.word = self.word;
            word.bookmark = [dic valueForKey:@"value"];
        }
    }
    [self.managedObjectContext save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

