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
#import "ViewController2.h"

@interface ViewController ()

@property (nonatomic, strong) GCPageView* pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageView = ({
        GCPageView* view = [[GCPageView alloc] initWithMode:GCPageModeInfinite];
        [view withPagingEnabled:YES];
        [view withMaximumZoomScale:2.0f];
        [view withMinimumZoomScale:.5f];
        [view withBlockForPageViewCellCount:^NSUInteger(GCPageView *pageView) {
            return (NSUInteger)1;
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
        view.frame = self.view.bounds;
        [view registClass:[ContentCell class] withCellIdentifer:@"test"];
        [view registClass:[ContentCell2 class] withCellIdentifer:@"test2"];
        [view reloadData];
        view;
    });
    [self.view addSubview:self.pageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.pageView startAutoScrollWithInterval:1.0f];
    
    ViewController2* vc = [[ViewController2 alloc] init];
    [vc withDismissBlock:^(NSDictionary *userInfo) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.pageView stopAutoScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (!self.presentedViewController) {
        ViewController2* vc = [[ViewController2 alloc] init];
        [vc withDismissBlock:^(NSDictionary *userInfo) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
