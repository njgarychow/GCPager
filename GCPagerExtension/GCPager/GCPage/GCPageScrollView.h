//
//  GCPageScrollView.h
//  GCPagerExtension
//
//  Created by zhoujinqiang on 15/1/20.
//  Copyright (c) 2015年 njgarychow. All rights reserved.
//

#import "GCScrollView.h"

@interface GCPageScrollView : GCScrollView

@property (nonatomic, assign) BOOL contentPagingEnabled;

- (instancetype)withBlockWithPageViewCount:(NSUInteger (^)(GCPageScrollView* view))block;
- (instancetype)withBlockWithPageViewWillDisplay:(UIView* (^)(GCPageScrollView* view, NSUInteger index))block;
- (instancetype)withBlockForPageViewDidUndisplay:(void (^)(GCPageScrollView* view, NSUInteger index, UIView* undisplayView))block;
- (instancetype)withBlockForPageViewDidScroll:(void (^)(GCPageScrollView* view, UIView* contentView, CGFloat position))block;

- (void)reloadData;

@end