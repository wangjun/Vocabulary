//
//  FirstViewController.m
//  Vocabulary
//
//  Created by 徐哲 on 14-4-22.
//  Copyright (c) 2014年 徐哲. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.url = [[NSBundle mainBundle] URLForResource:@"able" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
