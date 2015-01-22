//
//  ViewController.m
//  GCPagerExtension
//
//  Created by njgarychow on 1/13/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import "ViewController.h"
#import "GCPager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GCPageView* pageView = ({
        GCPageView* view = [[GCPageView alloc] initWithMode:GCPageViewModeDefault];
        [view withBlockForPageViewCellCount:^NSUInteger(GCPageView *pageView) {
            return (NSUInteger)2000000;
        }];
        [view withBlockForPageViewCell:^GCPageViewCell *(GCPageView *pageView, NSUInteger index) {
            GCPageViewCell* cell = [[GCPageViewCell alloc] initWithFrame:self.view.bounds];
            UILabel* label = [[UILabel alloc] initWithFrame:self.view.bounds];
            label.text = [@(index) stringValue];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:100];
            [cell addSubview:label];
            return cell;
        }];
        [view withBlockForPageViewCellDidScroll:^(GCPageView *pageView, GCPageViewCell *cell, CGFloat position) {
            NSLog(@"%@ %f", cell, position);
        }];
        view.frame = self.view.bounds;
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
