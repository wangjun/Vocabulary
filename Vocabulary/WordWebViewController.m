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
@property (nonatomic) BOOL isOnlyOne;
@property (nonatomic,strong)NSArray *words;
@end

@implementation WordWebViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize showingWord = _showingWord,wordweb;
@synthesize notRecord = _notRecord;
@synthesize words = _words;


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
    [self.view addSubview:following];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadWord:self.showingWord];
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
    [self.wordweb loadRequest:wordRequest];
}

-(void)saveWordToBookmark
{
    AddToBookmarkViewController *vc = [[AddToBookmarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setWord:self.showingWord];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
