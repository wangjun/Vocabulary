//
//  WordWebViewController.h
//  Vocabulary
//
//  Created by 徐哲 on 14-4-23.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Word;
@interface WordWebViewController : UIViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) UIWebView *wordweb;
@property (nonatomic,strong) Word *showingWord;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,weak) NSArray *words;
@end
