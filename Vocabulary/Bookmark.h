//
//  Bookmark.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * adddate;
@property (nonatomic, retain) NSSet *word_had;
@end

@interface Bookmark (CoreDataGeneratedAccessors)

- (void)addWord_hadObject:(Word *)value;
- (void)removeWord_hadObject:(Word *)value;
- (void)addWord_had:(NSSet *)values;
- (void)removeWord_had:(NSSet *)values;

@end
