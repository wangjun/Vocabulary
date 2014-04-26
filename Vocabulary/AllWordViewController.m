//
//  AllWordViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "AllWordViewController.h"
#import "AppDelegate.h"
#import "Word.h"
#import "WordWebViewController.h"

@interface AllWordViewController ()

@end

@implementation AllWordViewController
@synthesize context = _context;
@synthesize wordDics = _wordDics;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"全部单词";
        self.tabBarItem.title = @"全部单词";
        // Custom initialization
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

-(NSArray*)wordDics{
    if (_wordDics == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Word" inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *firstcharSort = [NSSortDescriptor sortDescriptorWithKey:@"firstchar" ascending:YES];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"word" ascending:YES];
        [fetchRequest setSortDescriptors:@[firstcharSort,sort]];
        NSError *error;
        NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *wordDicArray = [NSMutableArray array];
        for(Word *word in array){
            BOOL isFound = NO;
            for(NSMutableDictionary *wordDic in wordDicArray){
                if([[wordDic valueForKey:@"firstchar"] isEqual:word.firstchar]){
                    isFound = YES;
                    NSMutableArray * dic_wordArray = (NSMutableArray*)[wordDic valueForKey:@"WordArray"];
                    [dic_wordArray addObject:word];
                    break;
                }
            }
            if(isFound == NO){
                NSMutableDictionary *wordDic = [NSMutableDictionary dictionary];
                NSMutableArray *dic_wordArray = [NSMutableArray array];
                [wordDic setValue:word.firstchar forKey:@"firstchar"];
                [wordDic setValue:dic_wordArray forKey:@"WordArray"];
                [dic_wordArray addObject:word];
                [wordDicArray addObject:wordDic];
            }
        }
        _wordDics = wordDicArray;
    }
    return _wordDics;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.wordDics.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray*)[self.wordDics[section] valueForKey:@"WordArray"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.wordDics[indexPath.section] valueForKey:@"WordArray"][indexPath.row] valueForKey:@"word"];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.wordDics[section] valueForKey:@"firstchar"];
}
- (NSArray *) sectionIndexTitlesForTableView : (UITableView *) tableView {
    
    return [self.wordDics valueForKey:@"firstchar"];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *words = [self.wordDics[indexPath.section] valueForKey:@"WordArray"];
    Word *word =  words[indexPath.row];
    WordWebViewController *wordwebVC = [[WordWebViewController alloc] initWithNibName:nil bundle:nil];
    [wordwebVC setShowingWord:word andIsOnlyOne:NO andNotRecord:NO andWords:nil];
    [self.navigationController pushViewController:wordwebVC animated:YES];
}

@end
