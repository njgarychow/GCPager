//
//  GCPageViewCell.h
//  GCPagerExtension
//
//  Created by njgarychow on 1/16/15.
//  Copyright (c) 2015 njgarychow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPageViewCell : UIView

@property (nonatomic, readonly) NSString* reuseIdentifier;

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

- (void)prepareForReuse;
- (void)prepareForFree;

@end
