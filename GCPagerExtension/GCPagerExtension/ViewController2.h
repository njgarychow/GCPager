//
//  ViewController2.h
//  GCPagerExtension
//
//  Created by zhoujinqiang on 15/1/29.
//  Copyright (c) 2015年 njgarychow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController2 : UIViewController

- (instancetype)withDismissBlock:(void (^)(NSDictionary* userInfo))dismissBlock;

@end
