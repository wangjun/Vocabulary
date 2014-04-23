//
//  AddToBookmarkViewController.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Word;
@interface AddToBookmarkViewController : UITableViewController

@property (nonatomic,strong) Word *word;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSArray *bookmarks;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
