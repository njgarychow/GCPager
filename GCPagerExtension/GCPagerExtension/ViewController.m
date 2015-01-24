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
#import "ContentCell2.h"

@interface ViewController ()

@property (nonatomic, strong) GCPageView* pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageView = ({
        GCPageView* view = [[GCPageView alloc] initWithMode:GCPageViewModeDefault];
        [view withPagingEnabled:YES];
        [view withMaximumZoomScale:2.0f];
        [view withMinimumZoomScale:.5f];
        [view withBlockForPageViewCellCount:^NSUInteger(GCPageView *pageView) {
            return (NSUInteger)20;
        }];
        [view withBlockForPageViewCell:^GCPageViewCell *(GCPageView *pageView, NSUInteger index) {
            if (index % 2) {
                ContentCell* cell = [pageView dequeueReusableCellWithIdentifer:@"test"];
                cell.label.text = [@(index) stringValue];
                return cell;
            }
            else {
                ContentCell2* cell = [pageView dequeueReusableCellWithIdentifer:@"test2"];
                return cell;
            }
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
        [view startAutoScrollWithInterval:1.0f];
        view.frame = self.view.bounds;
        [view registClass:[ContentCell class] withCellIdentifer:@"test"];
        [view registClass:[ContentCell2 class] withCellIdentifer:@"test2"];
        [view reloadData];
        view;
    });
    [self.view addSubview:self.pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.pageView reloadData];
}

@end
