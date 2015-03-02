//
//  ViewController2.m
//  GCPagerExtension
//
//  Created by zhoujinqiang on 15/1/29.
//  Copyright (c) 2015年 njgarychow. All rights reserved.
//

#import "ViewController2.h"

#import "GCPageViewController.h"
#import "ViewContoller3.h"

@interface ViewController2 ()

@property (nonatomic, copy) void (^dismissBlock)(NSDictionary* userInfo);

@end

@implementation ViewController2

- (instancetype)withDismissBlock:(void (^)(NSDictionary* userInfo))dismissBlock {
    self.dismissBlock = dismissBlock;
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GCPageViewController* pageViewController = ({
        GCPageViewController* pvc = [[GCPageViewController alloc] initWithMode:GCPageModeInfinite];
        __weak typeof(pvc) weakPVC = pvc;
        [pvc withBlockForPageControllerCount:^NSUInteger(GCPageViewController *controller) {
            return (NSUInteger)4;
        }];
        [pvc withBlockForPageController:^UIViewController *(GCPageViewController *controller, NSUInteger index) {
            ViewContoller3* vc = [[ViewContoller3 alloc] init];
            vc.label.text = [@(index) stringValue];
            return vc;
        }];
        [pvc withBlockForPageControllerDidEndDisplay:^(GCPageViewController *controller, NSUInteger index) {
            NSLog(@"end display :%ld", index);
        }];
        [pvc withLeftBorderAction:^{
            self.dismissBlock(nil);
        }];
        [pvc withRightBorderAction:^{
            [weakPVC showPageAtIndex:0 animation:NO];
        }];
        pvc.view.frame = self.view.bounds;
        [pvc reloadData];
        pvc;
    });
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
}

@end
