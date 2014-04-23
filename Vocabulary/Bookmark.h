//
//  Bookmark.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * adddate;
@property (nonatomic, retain) NSSet *word_bookmark;
@end

@interface Bookmark (CoreDataGeneratedAccessors)

- (void)addWord_bookmarkObject:(NSManagedObject *)value;
- (void)removeWord_bookmarkObject:(NSManagedObject *)value;
- (void)addWord_bookmark:(NSSet *)values;
- (void)removeWord_bookmark:(NSSet *)values;

@end
