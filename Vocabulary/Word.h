//
//  Word.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, LocalHistory;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSNumber * lookdCount;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) NSSet *history;
@end

@interface Word (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

- (void)addHistoryObject:(LocalHistory *)value;
- (void)removeHistoryObject:(LocalHistory *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

@end
