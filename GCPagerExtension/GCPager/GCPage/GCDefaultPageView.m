//
//  GCDefaultPageView.m
//  GCPagerExtension
//
//  Created by njgarychow on 1/17/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import "GCDefaultPageView.h"
#import "GCScrollView.h"

@interface GCDefaultPageView () <UIScrollViewDelegate>

@property (nonatomic, strong) GCScrollView* pageScrollView;

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign) NSUInteger pageCount;

@property (nonatomic, assign) CGPoint startDraggingPoint;

@property (nonatomic, copy) void (^leftBorderAction)();
@property (nonatomic, copy) void (^rightBorderAction)();
@property (nonatomic, assign) CGSize pageViewCellSize;
@property (nonatomic, assign) BOOL pagingEnabled;

@end



@implementation GCDefaultPageView

@dynamic bounces;
- (void)setBounces:(BOOL)bounces {
    self.pageScrollView.bounces = bounces;
}
- (BOOL)bounces {
    return self.pageScrollView.bounces;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pageScrollView.frame = self.bounds;
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.pageScrollView = ({
            GCScrollView* view = [[GCScrollView alloc] initWithFrame:self.bounds];
            view.bounces = self.bounces;
            view.delegate = self;
            view;
        });
        [self addSubview:self.pageScrollView];
        
        [self withPageViewCellSize:self.pageScrollView.bounds.size];
    }
    return self;
}

- (instancetype)withLeftBorderAction:(void (^)())leftBorderAction {
    self.pageScrollView.borderMask |= GCScrollViewBorderMaskLeft;
    self.leftBorderAction = leftBorderAction;
    return self;
}
- (instancetype)withRightBorderAction:(void (^)())rightBorderAction {
    self.pageScrollView.borderMask |= GCScrollViewBorderMaskRight;
    self.rightBorderAction = rightBorderAction;
    return self;
}
- (instancetype)withPageViewCellSize:(CGSize)size {
    self.pageViewCellSize = size;
    return self;
}
- (instancetype)withPagingEnabled:(BOOL)pagingEnabled {
    self.pagingEnabled = pagingEnabled;
    return self;
}

- (void)registClass:(Class)cellClass withCellIdentifer:(NSString *)cellIdentifier {
    //TODO:
}
- (id)dequeueReusableCellWithIdentifer:(NSString *)cellIdentifier {
    //TODO:
    return nil;
}

- (void)reloadData {
    
    NSParameterAssert(self.blockForPageViewCellCount != NULL);
    NSParameterAssert(self.blockForPageViewCell != NULL);
    
    self.pageCount = self.blockForPageViewCellCount(self);
    NSAssert(self.pageCount >= 0, @"page count can not litter than 0");
    
    if (self.currentPageIndex >= self.pageCount) {
        self.currentPageIndex = MAX(self.pageCount - 1, 0);
    }
    
    [self _reloadContainerViews];
    [self _reloadShowingViewsIfNeeded];
}

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval {
    //TODO:
}
- (void)stopAutoScroll {
    //TODO:
}


#pragma mark - UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startDraggingPoint = scrollView.contentOffset;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.pagingEnabled) {
        NSInteger targetPageIndex = floor(((*targetContentOffset).x / self.pageViewCellSize.width) + 0.5f);
        NSInteger currentPageIndex = floor(self.startDraggingPoint.x / self.pageViewCellSize.width + 0.5f);
        NSInteger pageIndex = currentPageIndex;
        if (targetPageIndex > currentPageIndex) {
            pageIndex++;
        }
        else if (targetPageIndex < currentPageIndex) {
            pageIndex--;
        }
        *targetContentOffset = CGPointMake(self.pageViewCellSize.width * pageIndex, (*targetContentOffset).y);
    }
    else {
        NSInteger targetPageIndex = floor(((*targetContentOffset).x / self.pageViewCellSize.width) + 0.5f);
        *targetContentOffset = CGPointMake(self.pageViewCellSize.width * targetPageIndex, (*targetContentOffset).y);
    }
}

#pragma mark - private methods

- (void)_reloadContainerViews {
    
}

- (void)_reloadShowingViewsIfNeeded {
    
}

@end