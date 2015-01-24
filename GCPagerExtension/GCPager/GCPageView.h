//
//  GCPageView.h
//  GCPagerExtension
//
//  Created by njgarychow on 1/13/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GCPageViewMode) {
    GCPageViewModeDefault,
    GCPageViewModeInfinite,
};

@class GCPageViewCell;

@interface GCPageView : UIView

@property (nonatomic, assign) BOOL bounces;

- (NSUInteger)currentPageIndex;
- (NSUInteger)totalPageCount;

- (instancetype)initWithMode:(GCPageViewMode)mode;

- (instancetype)withBlockForPageViewCellCount:(NSUInteger (^)(GCPageView* pageView))block;
- (instancetype)withBlockForPageViewCell:(GCPageViewCell* (^)(GCPageView* pageView, NSUInteger index))block;
- (instancetype)withBlockForPageViewCellDidScroll:(void (^)(GCPageView* pageView, GCPageViewCell* cell, CGFloat position))block;
- (instancetype)withBlockForPageViewCellDidEndDisplay:(void (^)(GCPageView* pageView, NSUInteger index, GCPageViewCell* cell))block;

- (instancetype)withLeftBorderAction:(void (^)())leftBorderAction;
- (instancetype)withRightBorderAction:(void (^)())rightBorderAction;
- (instancetype)withPagingEnabled:(BOOL)pagingEnabled;

- (void)registClass:(Class)cellClass withCellIdentifer:(NSString *)cellIdentifier;
- (id)dequeueReusableCellWithIdentifer:(NSString *)cellIdentifier;

- (void)reloadData;

- (void)showPageAtIndex:(NSUInteger)index animation:(BOOL)animation;

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval;
- (void)stopAutoScroll;

@end
