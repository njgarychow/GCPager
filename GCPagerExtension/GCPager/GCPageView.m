//
//  GCPageView.m
//  GCPagerExtension
//
//  Created by njgarychow on 1/13/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import "GCPageView.h"
#import "GCDefaultPageView.h"
#import "GCInfinitePageView.h"


@implementation GCPageView

@dynamic bounces;
- (void)setBounces:(BOOL)bounces {
    NSAssert(NO, @"override this method");
}
- (BOOL)bounces {
    NSAssert(NO, @"override this method");
    return NO;
}

- (instancetype)initWithMode:(GCPageViewMode)mode {
    if (mode == GCPageViewModeDefault) {
        return [[GCDefaultPageView alloc] init];
    }
    if (mode == GCPageViewModeInfinite) {
        return [[GCInfinitePageView alloc] init];
    }
    return nil;
}

- (instancetype)withLeftBorderAction:(void (^)())leftBorderAction {
    NSAssert(NO, @"override this method");
    return nil;
}
- (instancetype)withRightBorderAction:(void (^)())rightBorderAction {
    NSAssert(NO, @"override this method");
    return nil;
}
- (instancetype)withPageViewCellSize:(CGSize)size {
    NSAssert(NO, @"override this method");
    return nil;
}
- (instancetype)withPagingEnabled:(BOOL)pagingEnabled {
    NSAssert(NO, @"override this method");
    return nil;
}

- (void)registClass:(Class)cellClass withCellIdentifer:(NSString *)cellIdentifier {
    NSAssert(NO, @"override this method");
}
- (id)dequeueReusableCellWithIdentifer:(NSString *)cellIdentifier {
    NSAssert(NO, @"override this method");
    return nil;
}

- (void)reloadData {
    NSAssert(NO, @"override this method");
}
- (void)startAutoScrollWithInterval:(NSTimeInterval)interval {
    NSAssert(NO, @"override this method");
}
- (void)stopAutoScroll {
    NSAssert(NO, @"override this method");
}

@end
