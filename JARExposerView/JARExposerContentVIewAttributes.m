//
//  JARExposerContentViewAttributes.m
//  Exposer
//
//  Created by Jesse Armand on 16/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "JARExposerContentViewAttributes.h"

@implementation JARExposerContentViewAttributes

+ (instancetype)contentViewAttributesForIndex:(NSUInteger)index
{
    JARExposerContentViewAttributes *attributes = [[JARExposerContentViewAttributes alloc] init];
    attributes.index = index;
    return attributes;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
