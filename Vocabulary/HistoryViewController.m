//
//  HistoryViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "Word.h"
#import "LocalHistory.h"
#import "Bookmark.h"
#import "WordWebViewController.h"


@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize historys = _historys;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"历史记录";
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmark)];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.managedObjectContext save:nil];
    _historys = nil;
}

-(NSArray*)historys
{
    if(_historys == nil)
    {
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalHistory" inManagedObjectContext:self.managedObjectContext];
        [fetch setEntity:entity];
        NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"adddate" ascending:NO];
        [fetch setSortDescriptors:@[sort1,sort2]];
        [fetch setFetchLimit:500];
        NSArray *historys = [self.managedObjectContext executeFetchRequest:fetch error:nil];
        
        NSMutableArray *historyDicArray = [NSMutableArray array];
        for(LocalHistory *history in historys){
            BOOL isFound = NO;
            for(NSMutableDictionary *historyDic in historyDicArray){
                if([[historyDic valueForKey:@"date"] isEqual:history.date]){
                    isFound = YES;
                    NSMutableArray * dic_wordArray = (NSMutableArray*)[historyDic valueForKey:@"WordArray"];
                    [dic_wordArray addObject:history];
                    break;
                }
            }
            if(isFound == NO){
                NSMutableDictionary *historyDic = [NSMutableDictionary dictionary];
                NSMutableArray *dic_wordArray = [NSMutableArray array];
                [historyDic setValue:history.date forKey:@"date"];
                [historyDic setValue:dic_wordArray forKey:@"WordArray"];
                [dic_wordArray addObject:history];
                [historyDicArray addObject:historyDic];
            }
        }
        _historys = historyDicArray;


    }
    return _historys;
}

/*
- (NSArray*)historys
{
    if(_historys == nil)
    {
        NSMutableArray *array = [NSMutableArray array];
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalHistory" inManagedObjectContext:self.managedObjectContext];
        [fetch setEntity:entity];
        [fetch setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
        [fetch setFetchLimit:500];
        NSArray *historys = [self.managedObjectContext executeFetchRequest:fetch error:nil];
        
        
        unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
        NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comp_now = [myCal components:units fromDate:[NSDate date]];
        NSInteger month_now = [comp_now month];
        NSInteger year_now = [comp_now year];
        NSInteger day_now = [comp_now day];
        NSLog(@"now year = %d   month = %d  day = %d",year_now,month_now,day_now);
        if(historys.count > 0){
            for (LocalHistory *history in historys) {
                
                NSDateComponents *comp1 = [myCal components:units fromDate:history.date];
                NSInteger month = [comp1 month];
                NSInteger year = [comp1 year];
                NSInteger day = [comp1 day];
                NSLog(@"history year = %d   month = %d  day = %d",year,month,day);
                
                BOOL isfound = NO;
                for (NSDictionary *dic in array) {
                    if(![[dic valueForKey:@"day"] isEqual:[NSNumber numberWithInt:day]])
                        break;
                    if(![[dic valueForKey:@"month"] isEqual:[NSNumber numberWithInt:month]])
                        break;
                    if(![[dic valueForKey:@"year"] isEqual:[NSNumber numberWithInt:year]])
                        break;
                    isfound = YES;
                    [[dic valueForKey:@"value"] addObject:history];
                }
                if(isfound == NO){
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:[NSNumber numberWithInt:day] forKey:@"day"];
                    [dic setValue:[NSNumber numberWithInt:month] forKey:@"month"];
                    [dic setValue:[NSNumber numberWithInt:year] forKey:@"year"];
                    NSMutableArray *array = [NSMutableArray array];
                    [array addObject:history];
                }
            }
        }
        NSLog(@"%@",array);
        _historys = array;
    }
    return _historys;
}*/
 
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.historys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *words = (NSArray*)[self.historys[section] valueForKey:@"WordArray"];
    return words.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.historys[section] valueForKey:@"date"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *words = (NSArray*)[self.historys[indexPath.section] valueForKey:@"WordArray"];
    cell.textLabel.text = [[words[indexPath.row] valueForKey:@"word"] valueForKey:@"word"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *words = [[self.historys[indexPath.section] valueForKey:@"WordArray"] valueForKey:@"word"];
    Word *word =  words[indexPath.row];
    WordWebViewController *wordwebVC = [[WordWebViewController alloc] initWithNibName:nil bundle:nil];
    [wordwebVC setShowingWord:word andIsOnlyOne:NO andNotRecord:YES andWords:words];
    [self.navigationController pushViewController:wordwebVC animated:YES];
}

@end
