//
//  JARExposerViewDataSource.h
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JARExposerView;
@class JARExposerContentView;
@class JARExposerContentViewAttributes;

@protocol JARExposerViewDataSource <NSObject>

@required
- (NSUInteger)numberOfContentViews;

- (JARExposerContentView *)exposerView:(JARExposerView *)exposerView contentViewAtIndex:(NSUInteger)index;
- (JARExposerContentViewAttributes *)contentViewAttributesAtIndex:(NSUInteger)index;

@end
