//
//  ViewContoller3.m
//  GCPagerExtension
//
//  Created by zhoujinqiang on 15/1/29.
//  Copyright (c) 2015年 njgarychow. All rights reserved.
//

#import "ViewContoller3.h"

@implementation ViewContoller3

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:100];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label.frame = self.view.bounds;
    [self.view addSubview:self.label];
}

- (void)dealloc {
    NSLog(@"%@ dealloc %@", NSStringFromClass([self class]), self.label.text);
}

@end
