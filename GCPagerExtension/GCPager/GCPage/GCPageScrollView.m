//
//  GCPageScrollView.m
//  GCPagerExtension
//
//  Created by zhoujinqiang on 15/1/20.
//  Copyright (c) 2015年 njgarychow. All rights reserved.
//

#import "GCPageScrollView.h"
#import "UIView+GCOperation.h"

#pragma mark - GCPageContentScrollView

@interface GCPageContentScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIView* contentView;

@end

@implementation GCPageContentScrollView

- (void)setContentView:(UIView *)contentView {
    if (_contentView == contentView) {
        return;
    }
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self addSubview:_contentView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}

@end


#pragma mark - GCPageContentScrollViewStoreHelper

@interface GCPageContentScrollViewStoreHelper : NSObject {
    NSMutableDictionary* _inuseViewDictionary;
    NSMutableArray* _reuseViewArray;
}

- (NSArray *)storedPageContentScrollViewsIndexesInorder;
- (GCPageContentScrollView *)pageContentScrollViewAtIndex:(NSUInteger)index;
- (GCPageContentScrollView *)createPageContentScrollViewAtIndex:(NSUInteger)index;
- (void)deletePageContentScrollViewAtIndex:(NSUInteger)index;

@end


@implementation GCPageContentScrollViewStoreHelper

- (instancetype)init {
    if (self = [super init]) {
        _inuseViewDictionary = [NSMutableDictionary dictionary];
        _reuseViewArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)storedPageContentScrollViewsIndexesInorder {
    return [[_inuseViewDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 unsignedIntegerValue] <= [obj2 unsignedIntegerValue] ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (GCPageContentScrollView *)createPageContentScrollViewAtIndex:(NSUInteger)index {
    GCPageContentScrollView* view = nil;
    view = [_reuseViewArray lastObject];
    [_reuseViewArray removeLastObject];
    if (!view) {
        view = [[GCPageContentScrollView alloc] init];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    _inuseViewDictionary[@(index)] = view;
    return view;
}
- (GCPageContentScrollView *)pageContentScrollViewAtIndex:(NSUInteger)index {
    return _inuseViewDictionary[@(index)];
}
- (void)deletePageContentScrollViewAtIndex:(NSUInteger)index {
    GCPageContentScrollView* view = _inuseViewDictionary[@(index)];
    [_inuseViewDictionary removeObjectForKey:@(index)];
    [view removeAllSubviews];
    view.frame = CGRectZero;
    [_reuseViewArray addObject:view];
}

@end





#pragma mark - GCPageScrollView


@interface GCPageScrollView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSUInteger (^blockForPageViewCount)(GCPageScrollView* view);
@property (nonatomic, copy) UIView* (^blockForPageViewWillDisplay)(GCPageScrollView* view, NSUInteger index);
@property (nonatomic, copy) void (^blockForPageViewDidUndisplay)(GCPageScrollView* view, NSUInteger index, UIView* undisplayView);
@property (nonatomic, copy) void (^blockForPageViewDidScroll)(GCPageScrollView* view, UIView* contentView, CGFloat position);

@property (nonatomic, strong) GCPageContentScrollViewStoreHelper* storeHelper;

@property (nonatomic, assign) CGPoint startDraggingOffsetPoint;

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign) NSUInteger totalPageCount;

@end


@implementation GCPageScrollView
- (void)setContentPagingEnabled:(BOOL)contentPagingEnabled {
    _contentPagingEnabled = contentPagingEnabled;
    self.decelerationRate = _contentPagingEnabled ? .994f : .992f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.storeHelper = [[GCPageContentScrollViewStoreHelper alloc] init];
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.decelerationRate = 0.994f;
    }
    return self;
}

- (instancetype)withBlockWithPageViewCount:(NSUInteger (^)(GCPageScrollView *))block {
    self.blockForPageViewCount = block;
    return self;
}
- (instancetype)withBlockWithPageViewWillDisplay:(UIView *(^)(GCPageScrollView *, NSUInteger))block {
    self.blockForPageViewWillDisplay = block;
    return self;
}
- (instancetype)withBlockForPageViewDidUndisplay:(void (^)(GCPageScrollView *, NSUInteger, UIView *))block {
    self.blockForPageViewDidUndisplay = block;
    return self;
}
- (instancetype)withBlockForPageViewDidScroll:(void (^)(GCPageScrollView* view, UIView* contentView, CGFloat position))block {
    self.blockForPageViewDidScroll = block;
    return self;
}

- (void)reloadData {
    NSParameterAssert(self.blockForPageViewCount != NULL);
    NSParameterAssert(self.blockForPageViewWillDisplay != NULL);
    
    self.totalPageCount = self.blockForPageViewCount(self);
    if (self.currentPageIndex >= self.totalPageCount) {
        self.currentPageIndex = (self.totalPageCount >= 1) ? self.totalPageCount - 1 : 0;
    }
    self.contentSize = CGSizeMake(self.width * self.totalPageCount, self.bounds.size.height);
    [self _refreshContentPageViews];
}


#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self _refreshContentPageViews];
    self.currentPageIndex = floor(self.contentOffset.x / self.width + 0.5f);
    if (self.blockForPageViewDidScroll) {
        for (NSNumber* index in [self.storeHelper storedPageContentScrollViewsIndexesInorder]) {
            CGRect rect = [self _rectForContentViewAtIndex:[index unsignedIntegerValue]];
            GCPageContentScrollView* contentContainerView = [self.storeHelper pageContentScrollViewAtIndex:[index unsignedIntegerValue]];
            self.blockForPageViewDidScroll(self, contentContainerView.contentView, fabsf((rect.origin.x - scrollView.contentOffset.x) / self.width));
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startDraggingOffsetPoint = scrollView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.contentPagingEnabled) {
        NSInteger targetPageIndex = floor(((*targetContentOffset).x / self.width) + 0.5f);
        NSInteger originPageIndex = floor(self.startDraggingOffsetPoint.x / self.width + 0.5f);
        NSInteger pageIndex = originPageIndex;
        if (targetPageIndex > originPageIndex) {
            pageIndex++;
        }
        else if (targetPageIndex < originPageIndex) {
            pageIndex--;
        }
        *targetContentOffset = CGPointMake(self.width * pageIndex, (*targetContentOffset).y);
    }
    else {
        NSInteger targetPageIndex = floor(((*targetContentOffset).x / self.width) + 0.5f);
        *targetContentOffset = CGPointMake(self.width * targetPageIndex + self.contentInset.left, (*targetContentOffset).y);
    }
}



#pragma mark - private methods

- (void)_refreshContentPageViews {
    NSArray* visibleIndexes = [self _visibleContentIndexes];
    for (NSNumber* index in [self.storeHelper storedPageContentScrollViewsIndexesInorder]) {
        if (![visibleIndexes containsObject:index]) {
            NSUInteger idx = [index unsignedIntegerValue];
            GCPageContentScrollView* contentContainerView = [self.storeHelper pageContentScrollViewAtIndex:idx];
            UIView* view = contentContainerView.contentView;
            [self.storeHelper deletePageContentScrollViewAtIndex:idx];
            if (self.blockForPageViewDidUndisplay) {
                self.blockForPageViewDidUndisplay(self, idx, view);
            }
        }
    }
    for (NSNumber* index in visibleIndexes) {
        NSUInteger idx = [index unsignedIntegerValue];
        if (![self.storeHelper pageContentScrollViewAtIndex:idx]) {
            UIView* view = self.blockForPageViewWillDisplay(self, idx);
            GCPageContentScrollView* contentView = [self.storeHelper createPageContentScrollViewAtIndex:idx];
            contentView.contentView = view;
            contentView.frame = [self _rectForContentViewAtIndex:idx];
            [self addSubview:contentView];
        }
    }
}

- (CGRect)_rectForContentViewAtIndex:(NSUInteger)index {
    return (CGRect){{self.width * index, 0}, self.bounds.size};
}

- (NSArray *)_visibleContentIndexes {
    CGRect visibleRect = self.bounds;
    NSMutableArray* indexes = [NSMutableArray array];
    {
        NSUInteger pageIndex = (self.bounds.origin.x / self.width);
        while (YES) {
            CGRect rect = [self _rectForContentViewAtIndex:pageIndex];
            if (!CGRectIntersectsRect(rect, visibleRect)) {
                break;
            }
            [indexes addObject:@(pageIndex--)];
        }
    }
    {
        NSUInteger pageIndex = (self.bounds.origin.x / self.width) + 1;
        while (YES) {
            CGRect rect = [self _rectForContentViewAtIndex:pageIndex];
            if (!CGRectIntersectsRect(rect, visibleRect)) {
                break;
            }
            [indexes addObject:@(pageIndex++)];
        }
    }
    return [indexes copy];
}

@end