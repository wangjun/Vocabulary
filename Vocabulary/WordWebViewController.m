//
//  WordWebViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "WordWebViewController.h"
#import "AddToBookmarkViewController.h"
#import "AppDelegate.h"
#import "Word.h"
#import "LocalHistory.h"

@interface WordWebViewController ()

-(NSURL*)getURL:(NSString*)word;
@property (nonatomic) BOOL isOnlyOne;
@property (nonatomic,strong)NSArray *words;
@property (nonatomic,strong)UIButton *yinbiao;
@end

@implementation WordWebViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize showingWord = _showingWord,wordweb;
@synthesize notRecord = _notRecord;
@synthesize words = _words;
@synthesize yinbiao = _yinbiao;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWordToBookmark)];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
        self.notRecord = YES;
        self.isOnlyOne = YES;
    }
    return self;
}

- (void)setShowingWord:(Word*)word andIsOnlyOne:(BOOL)isOnlyOne andNotRecord:(BOOL)notRecord  andWords:(NSArray*)words
{
    self.words = words;
    self.showingWord = word;
    self.notRecord = notRecord;
    self.isOnlyOne = isOnlyOne;
    
}

-(void)setShowingWord:(Word *)showingWord
{
    _showingWord = showingWord;
    self.navigationItem.title = showingWord.word;
    NSUInteger index = 0;
    for(Word *word in self.words)
    {
        if([word isEqual:self.showingWord])
        {
            self.currentIndex = index;
            NSLog(@"WordWebViewController        self.currentIndex = %d",index);
            break;
        }
        
        index ++;
        
    }
}

-(void)gotoTheLast
{
    if(self.currentIndex == 0)
    {
        self.currentIndex = self.words.count - 1;
    }
    else
    {
        self.currentIndex --;
    }

    _showingWord = [self.words objectAtIndex:self.currentIndex];
    
    [self loadWord:self.showingWord];

}

-(void)gotoNext
{
    if(self.currentIndex == self.words.count -1)
    {
        self.currentIndex = 0;
    }
    else
    {
        self.currentIndex ++;
    }
    _showingWord = [self.words objectAtIndex:self.currentIndex];
    
    [self loadWord:self.showingWord];
}

-(NSArray*)words
{
    if(_words == nil && self.isOnlyOne == YES)
    {
        _words = @[self.showingWord];
    }
    else if(_words == nil && self.isOnlyOne == NO)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Word" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        NSError *error;
        _words = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
    return _words;
}
-(UIButton*)yinbiao
{
    if(_yinbiao == nil)
    {
        _yinbiao = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _yinbiao.frame = CGRectMake(20, 270, 60, 30);
        [_yinbiao setTitle:@"显示英音" forState:UIControlStateNormal];
        [_yinbiao addTarget:self action:@selector(showYinbiao) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yinbiao;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wordweb = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.wordweb.scalesPageToFit = YES;
    self.wordweb.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.wordweb];
    
    UIButton *theLast = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    theLast.frame = CGRectMake(20, 310, 60, 30);
    [theLast setTitle:@"上一个" forState:UIControlStateNormal];
    [theLast addTarget:self action:@selector(gotoTheLast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:theLast];
    
    UIButton *following = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    following.frame = CGRectMake(240, 310, 60, 30);
    [following setTitle:@"下一个" forState:UIControlStateNormal];
    [following addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.yinbiao];
    [self.view addSubview:following];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadWord:self.showingWord];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.managedObjectContext save:nil];
}

-(NSURL*)getURL:(NSString *)word
{
     NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"words.bundle"];
    
    NSURL *url = [[NSBundle bundleWithPath:bundlePath] URLForResource:word withExtension:@"html"];
    return url;
}

-(void)loadWord:(Word*)word
{
    if(!self.notRecord)
    {
        [[NSUserDefaults standardUserDefaults] setValue:word.word forKey:@"currentWord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.currentIndex = [self.words indexOfObject:word];
    self.navigationItem.title = word.word;
    NSURLRequest * wordRequest = [NSURLRequest requestWithURL:[self getURL:word.word]];
    
    if(self.notRecord == NO){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"LocalHistory" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@ AND word = %@",currentDateStr,word];
        [fetchRequest setPredicate:predicate];
        NSArray *fetched = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        
        
        if(fetched.count == 0){
            NSManagedObjectContext *context = [self managedObjectContext];
            LocalHistory *history = (LocalHistory*)[NSEntityDescription
                                                    insertNewObjectForEntityForName:@"LocalHistory"
                                                    inManagedObjectContext:context];
            history.date = currentDateStr;
            history.word = word;
            history.adddate = [NSDate date];
        }

    }
    
    [self.wordweb loadRequest:wordRequest];
}

-(void)saveWordToBookmark
{
    AddToBookmarkViewController *vc = [[AddToBookmarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setWord:self.showingWord];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showYinbiao
{
    NSArray *array;
    if([self.yinbiao.titleLabel.text isEqual: @"显示单词"])
    {
        self.navigationItem.titleView = nil;
        self.navigationItem.title = self.showingWord.word;
        array = nil;
    }
    else{
        array = [self getYinBiao:self.showingWord];
    }
    if(array != nil){
        UITextField *view = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        if([self.yinbiao.titleLabel.text isEqual: @"显示英音"])
            view.text = array[0];
        else if([self.yinbiao.titleLabel.text isEqual: @"显示美音"])
            view.text = array[1];
        view.textAlignment = NSTextAlignmentCenter;
        view.textColor = [UIColor redColor];
        view.font = [UIFont boldSystemFontOfSize:20];
        self.navigationItem.titleView = view;
        
        
    }
    if([self.yinbiao.titleLabel.text isEqual: @"显示英音"])
        [self.yinbiao setTitle:@"显示美音" forState:UIControlStateNormal];
    else if([self.yinbiao.titleLabel.text isEqual: @"显示美音"])
        [self.yinbiao setTitle:@"显示单词" forState:UIControlStateNormal];
    else
        [self.yinbiao setTitle:@"显示英音" forState:UIControlStateNormal];
}

-(NSArray*)getYinBiao:(Word*)word
{
    sqlite3 *database;
    NSString *databaseFilePath = [[NSBundle mainBundle] pathForResource:@"yinbiao" ofType:@"db"];
    if (sqlite3_open([databaseFilePath UTF8String], &database)==SQLITE_OK) {
        NSString *_sql = [NSString stringWithFormat:@"select * from yinbiao where word = '%@'",word.word];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [_sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //get data
                char *yingyin = (char *)sqlite3_column_text(statement, 1);
                NSString *yingyinStr = [NSString stringWithCString:yingyin encoding:NSUTF8StringEncoding];
                char *meiyin = (char *)sqlite3_column_text(statement, 2);
                NSString *meiyinStr = [NSString stringWithCString:meiyin encoding:NSUTF8StringEncoding];
                NSArray *retDvalue = @[yingyinStr,meiyinStr];
                NSLog(@"%@",retDvalue);
                return retDvalue;
            }
            sqlite3_finalize(statement);
        }
        
    }
    return nil;
}


@end
