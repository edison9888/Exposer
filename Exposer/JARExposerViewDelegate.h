//
//  JARExposerViewDelegate.h
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JARExposerView;

@protocol JARExposerViewDelegate <UIScrollViewDelegate>

@optional
- (void)exposerView:(JARExposerView *)exposerView didSelectContentViewAtIndex:(NSUInteger)index;

- (void)exposerView:(JARExposerView *)exposerView willPresentContentViewAtIndex:(NSUInteger)index;
- (void)exposerView:(JARExposerView *)exposerView didPresentContentViewAtIndex:(NSUInteger)index;

- (void)exposerView:(JARExposerView *)exposerView willDismissContentViewAtIndex:(NSUInteger)index;
- (void)exposerView:(JARExposerView *)exposerView didDismissContentViewAtIndex:(NSUInteger)index;

@end
