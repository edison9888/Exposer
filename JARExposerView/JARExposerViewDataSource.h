//
//  JARExposerViewDataSource.h
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JARExposerContentView;

@protocol JARExposerViewDataSource <NSObject>

@required
- (NSUInteger)numberOfContentViews;

- (JARExposerContentView *)contentView:(JARExposerContentView *)contentView atIndex:(NSUInteger)index;

@end
