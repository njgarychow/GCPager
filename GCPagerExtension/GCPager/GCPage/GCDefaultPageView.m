//
//  GCDefaultPageView.m
//  GCPagerExtension
//
//  Created by njgarychow on 1/17/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import "GCDefaultPageView.h"
#import "GCPageScrollView.h"

@interface GCDefaultPageView () <UIScrollViewDelegate>

@property (nonatomic, strong) GCPageScrollView* pageScrollView;

@property (nonatomic, copy) void (^leftBorderAction)();
@property (nonatomic, copy) void (^rightBorderAction)();

@end



@implementation GCDefaultPageView

@dynamic bounces;
- (void)setBounces:(BOOL)bounces {
    self.pageScrollView.bounces = bounces;
}
- (BOOL)bounces {
    return self.pageScrollView.bounces;
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.pageScrollView = ({
            GCPageScrollView* view = [[GCPageScrollView alloc] initWithFrame:self.bounds];
            view.bounces = self.bounces;
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            view;
        });
        [self addSubview:self.pageScrollView];
    }
    return self;
}

- (instancetype)withBlockForPageViewCellCount:(NSUInteger (^)(GCPageView* pageView))block {
    __weak typeof(self) weakSelf = self;
    [self.pageScrollView withBlockWithPageViewCount:^NSUInteger(GCPageScrollView *view) {
        return block(weakSelf);
    }];
    return self;
}
- (instancetype)withBlockForPageViewCell:(GCPageViewCell* (^)(GCPageView* pageView, NSUInteger index))block {
    __weak typeof(self) weakSelf = self;
    [self.pageScrollView withBlockWithPageViewForDisplay:^UIView *(GCPageScrollView *view, NSUInteger index) {
        return (UIView *)block(weakSelf, index);
    }];
    return self;
}
- (instancetype)withBlockForPageViewCellDidScroll:(void (^)(GCPageView* pageView, GCPageViewCell* cell, CGFloat position))block {\
    __weak typeof(self) weakSelf = self;
    [self.pageScrollView withBlockForPageViewDidScroll:^(GCPageScrollView *view, UIView *contentView, CGFloat position) {
        if (block) {
            block(weakSelf, (GCPageViewCell *)contentView, position);
        }
    }];
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
- (instancetype)withPagingEnabled:(BOOL)pagingEnabled {
    self.pageScrollView.contentPagingEnabled = pagingEnabled;
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
    [self.pageScrollView reloadData];
}

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval {
    //TODO:
}
- (void)stopAutoScroll {
    //TODO:
}

@end