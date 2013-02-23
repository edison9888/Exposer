//
//  JARExposerView.h
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JARExposerViewDelegate.h"
#import "JARExposerViewDataSource.h"
#import "JARExposerContentViewAttributes.h"
#import "JARExposerContentView.h"

@class JARExposerContentView;

@interface JARExposerView : UIScrollView

@property (weak, nonatomic) id <JARExposerViewDelegate> delegate;
@property (weak, nonatomic) id <JARExposerViewDataSource> dataSource;

- (JARExposerContentView *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier forIndex:(NSUInteger)index;
- (JARExposerContentView *)contentViewAtIndex:(NSUInteger)index;

- (void)reloadData;

- (void)scrollToContentViewAtIndex:(NSUInteger)index animated:(BOOL)animated;

// This is used to reset visible views and present all of the content views in a bezier curve type of animation.
- (void)presentContentViews;

@end
