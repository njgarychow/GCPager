//
//  UIView+GCOperation.m
//  GCPagerExtension
//
//  Created by njgarychow on 1/14/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import "UIView+GCOperation.h"

@implementation UIView (GCOperation)

- (void)removeAllSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        [view removeFromSuperview];
    }];
}

@end
