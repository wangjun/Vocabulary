//
//  Word_Bookmark.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, Word;

@interface Word_Bookmark : NSManagedObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) Word *word;
@property (nonatomic, retain) Bookmark *bookmark;

@end
