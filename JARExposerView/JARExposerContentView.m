//
//  JARExposerContentView.m
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "JARExposerContentView.h"

@implementation JARExposerContentView

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame reuseIdentifier:nil];
}

- (void)prepareForReuse
{
    
}

@end
