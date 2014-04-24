//
//  HistoryViewController.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UITableViewController


@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSArray *historys;
@end
