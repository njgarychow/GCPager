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

@property (nonatomic, copy) NSUInteger (^blockForPageViewCellCount)(GCPageView* pageView);
@property (nonatomic, copy) GCPageViewCell* (^blockForPageViewCell)(GCPageView* pageView, NSUInteger index);
@property (nonatomic, copy) void (^blockForPageViewCellDidScroll)(GCPageView* pageView, GCPageViewCell* cell, CGFloat position);

@property (nonatomic, assign) BOOL bounces;

- (instancetype)initWithMode:(GCPageViewMode)mode;

- (instancetype)withLeftBorderAction:(void (^)())leftBorderAction;
- (instancetype)withRightBorderAction:(void (^)())rightBorderAction;
- (instancetype)withPageViewCellSize:(CGSize)size;
- (instancetype)withPagingEnabled:(BOOL)pagingEnabled;

- (void)registClass:(Class)cellClass withCellIdentifer:(NSString *)cellIdentifier;
- (id)dequeueReusableCellWithIdentifer:(NSString *)cellIdentifier;

- (void)reloadData;

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval;
- (void)stopAutoScroll;

@end
