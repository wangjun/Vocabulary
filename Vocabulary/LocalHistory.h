//
//  LocalHistory.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface LocalHistory : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Word *word;

@end
