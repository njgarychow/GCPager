//
//  ContentCell.m
//  GCPagerExtension
//
//  Created by zhoujinqiang on 15/1/23.
//  Copyright (c) 2015年 njgarychow. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:100];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.label];
    }
    return self;
}

@end
