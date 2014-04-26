//
//  AppDelegate.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-22.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "AppDelegate.h"
#import "WordWebViewController.h"
#import "BookmarkViewController.h"
#import "AllWordViewController.h"
#import "HistoryViewController.h"
#import "Word.h"
#import "Bookmark.h"
#import "LocalHistory.h"
#import "Word_Bookmark.h"

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setValue:@"a" forKey:@"currentWord"];
        NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"words.bundle"];
        NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundlePath error:nil];
        NSEnumerator *files = [fileList objectEnumerator];
        NSString *string;
        while (string = [files nextObject]) {
            NSString *wordname = [string componentsSeparatedByString:@".htm"][0];
            NSManagedObjectContext *context = [self managedObjectContext];
            Word *word = (Word*)[NSEntityDescription
                                              insertNewObjectForEntityForName:@"Word"
                                              inManagedObjectContext:context];
            word.word = wordname;
            word.lookdCount = 0;
            word.firstchar = [[wordname lowercaseString] substringToIndex:1];
            NSLog(@"%@",word.word);
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITabBarController *rootViewController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    
    NSString *currentWordStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentWord"];
    NSLog(@"%@",currentWordStr);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@",currentWordStr];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    Word *currentWord = array[0];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Word"
                         inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES]]];
    array = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    WordWebViewController *wordwebVC = [[WordWebViewController alloc] initWithNibName:nil bundle:nil];
    [wordwebVC setShowingWord:currentWord andIsOnlyOne:NO andNotRecord:NO andWords:array];
    
    UINavigationController *wordNavVC = [[UINavigationController alloc] initWithRootViewController:wordwebVC];
    wordNavVC.tabBarItem.title = @"继续背单词";
    [rootViewController addChildViewController:wordNavVC];
    
    
    BookmarkViewController *bookmarkVC = [[BookmarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *bookmarkNavC = [[UINavigationController alloc] initWithRootViewController:bookmarkVC];
    bookmarkNavC.tabBarItem.title = @"收藏夹";    
    [rootViewController addChildViewController:bookmarkNavC];
    
    
    AllWordViewController *allwordVC = [[AllWordViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *allwordNavC = [[UINavigationController alloc] initWithRootViewController:allwordVC];
    allwordNavC.tabBarItem.title = @"全部单词";
    [rootViewController addChildViewController:allwordNavC];
    
    
    HistoryViewController *historyVC = [[HistoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *historyNavVC = [[UINavigationController alloc] initWithRootViewController:historyVC];
    historyNavVC.tabBarItem.title = @"历史记录";
    [rootViewController addChildViewController:historyNavVC];
    
    
    [self.window setRootViewController:rootViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self saveContext];

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Vocabulary" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Vocabulary.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
