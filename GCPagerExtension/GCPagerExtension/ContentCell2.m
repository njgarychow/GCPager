//
//  ContentCell2.m
//  GCPagerExtension
//
//  Created by njgarychow on 1/24/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import "ContentCell2.h"

@implementation ContentCell2

- (void)prepareForReuse {
    CGFloat r = arc4random() % 255 / 255.0f;
    CGFloat g = arc4random() % 255 / 255.0f;
    CGFloat b = arc4random() % 255 / 255.0f;
    self.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
