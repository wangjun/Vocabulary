//
//  NewBookmarkViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "NewBookmarkViewController.h"
#import "Bookmark.h"
#import "AppDelegate.h"

@interface NewBookmarkViewController ()

@property (nonatomic,strong)UITextField *bookmarkfield;
@property (nonatomic,strong)UIButton *okButton;

@end

@implementation NewBookmarkViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bookmarks = _bookmarks;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    }
    return _bookmarks;
}

-(void)setBookmarks:(NSArray *)bookmarks
{
    _bookmarks = bookmarks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.okButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(finishAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton setFrame:CGRectMake(50, 130, 220, 50)];
    [self.view addSubview:self.okButton];
    
    self.bookmarkfield = [[UITextField alloc] initWithFrame:CGRectMake(50, 30, 220, 50)];
    self.bookmarkfield.borderStyle =UITextBorderStyleRoundedRect;
    self.bookmarkfield.backgroundColor = [UIColor whiteColor];
    self.bookmarkfield.delegate = self;
    self.bookmarkfield.text = @"";
    [self.view addSubview:self.bookmarkfield];
    self.view.backgroundColor = [UIColor brownColor];
	// Do any additional setup after loading the view.
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

-(void)finishAdd
{
    NSArray *array = [self bookmarks];
    if(![self.bookmarkfield.text isEqualToString:@""])
    {
        BOOL hasname = NO;
        for(Bookmark *bookmark in array)
        {
            if(bookmark.name == self.bookmarkfield.text)
            {
                hasname = YES;
                break;
            }
        }
        if(hasname == NO)
        {
            NSManagedObjectContext *context = [self managedObjectContext];
            Bookmark *bookmark1 = (Bookmark*)[NSEntityDescription
                                              insertNewObjectForEntityForName:@"Bookmark"
                                              inManagedObjectContext:context];
            [bookmark1 setValue:self.bookmarkfield.text forKey:@"name"];
            [bookmark1 setValue:[NSDate date] forKey:@"adddate"];
            [context save:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
@end
