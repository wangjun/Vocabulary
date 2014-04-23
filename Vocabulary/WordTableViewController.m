//
//  WordTableViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "WordTableViewController.h"
#import "AppDelegate.h"
#import "Word.h"
#import "WordWebViewController.h"

@interface WordTableViewController ()

@end

@implementation WordTableViewController
@synthesize context = _context;
@synthesize bookmark = _bookmarks;
@synthesize words = _words;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _context = appDelegate.managedObjectContext;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)words{
    if (_words == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Word_Bookmark" inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"bookmark = %@",self.bookmark];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        _words = [self.context executeFetchRequest:fetchRequest error:&error];
    }
    return _words;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[_words objectAtIndex:indexPath.row] valueForKey:@"word.word"];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Word *word = [[_words objectAtIndex:indexPath.row] valueForKey:@"word"];
    WordWebViewController *wordVC = [[WordWebViewController alloc] initWithNibName:nil bundle:nil];
    wordVC.showingWord = word;
    [wordVC setNotRecord:YES];
    [self.navigationController pushViewController:wordVC animated:YES];
}

@end
