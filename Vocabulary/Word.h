//
//  Word.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, LocalHistory, Word_Bookmark;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * firstchar;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSNumber * lookdCount;
@property (nonatomic, retain) NSSet *history;
@property (nonatomic, retain) NSSet *word_bookmark;
@end

@interface Word (CoreDataGeneratedAccessors)

- (void)addHistoryObject:(LocalHistory *)value;
- (void)removeHistoryObject:(LocalHistory *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

- (void)addWord_bookmarkObject:(Word_Bookmark *)value;
- (void)removeWord_bookmarkObject:(Word_Bookmark *)value;
- (void)addWord_bookmark:(NSSet *)values;
- (void)removeWord_bookmark:(NSSet *)values;

@end
