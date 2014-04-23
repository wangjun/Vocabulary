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

@interface WordWebViewController ()

-(NSURL*)getURL:(NSString*)word;
@property (nonatomic) BOOL notRecord;
@end

@implementation WordWebViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize showingWord = _showingWord,wordweb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWordToBookmark)];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}

- (id)initWithWord:(NSString*)word
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        [self setShowingWord:word];
    }
    return self;
}

- (void)setShowingWord:(NSString *)showingWord
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Word" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"word = %@",showingWord];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *words = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    _showingWord = words[0];
    self.navigationItem.title = _showingWord.word;
}

- (Word*)showingWord
{
    if(_showingWord == nil)
    {
        NSString *word = @"abandon";
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Word" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"word = %@",word];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSArray *words = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        _showingWord = words[0];
    }
    return _showingWord;
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

    self.showingWord = [self.words objectAtIndex:self.currentIndex];
    
    [self loadWord:self.showingWord];

}

-(NSArray*)words
{
    if(_words == nil && self.notRecord == YES)
    {
        _words = @[self.showingWord];
    }
    else if(_words == nil && self.notRecord == NO)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Word" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        _words = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
    return _words;
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
    self.showingWord = [self.words objectAtIndex:self.currentIndex];
    
    [self loadWord:self.showingWord];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.words = [AppDelegate shareWordArray];
    
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
    [self.view addSubview:following];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadWord:self.showingWord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSURLRequest * wordRequest = [NSURLRequest requestWithURL:[self getURL:word.word]];
    [self.wordweb loadRequest:wordRequest];
}

-(void)saveWordToBookmark
{
    AddToBookmarkViewController *vc = [[AddToBookmarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setWord:self.showingWord];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setNotRecord:(BOOL)record
{
    self.notRecord = record;
}
@end
