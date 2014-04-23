//
//  WordTableViewController.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Bookmark;
@interface WordTableViewController : UITableViewController

@property (nonatomic) Bookmark *bookmark;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSArray *words;
@end
