//
//  ViewController.m
//  GCPagerExtension
//
//  Created by njgarychow on 1/13/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import "ViewController.h"
#import "GCPager.h"
#import "ContentCell.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GCPageView* pageView = ({
        GCPageView* view = [[GCPageView alloc] initWithMode:GCPageViewModeDefault];
        [view withPagingEnabled:YES];
        [view withBlockForPageViewCellCount:^NSUInteger(GCPageView *pageView) {
            return (NSUInteger)4;
        }];
        [view withBlockForPageViewCell:^GCPageViewCell *(GCPageView *pageView, NSUInteger index) {
            ContentCell* cell = [pageView dequeueReusableCellWithIdentifer:@"test"];
            cell.label.text = [@(index) stringValue];
            return cell;
        }];
        [view withBlockForPageViewCellDidScroll:^(GCPageView *pageView, GCPageViewCell *cell, CGFloat position) {
            cell.alpha = 1 - fabsf(position);
        }];
        [view withBlockForPageViewCellDidEndDisplay:^(GCPageView *pageView, NSUInteger index, GCPageViewCell *cell) {
            NSLog(@"%@", @(index));
        }];
        [view withLeftBorderAction:^{
            NSLog(@"left action");
        }];
        [view startAutoScrollWithInterval:2.0f];
        view.frame = self.view.bounds;
        [view registClass:[ContentCell class] withCellIdentifer:@"test"];
        [view reloadData];
        view;
    });
    [self.view addSubview:pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
