//
//  JARExposerContentView.m
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "JARExposerContentView.h"
#import "JARExposerContentViewAttributes.h"

@interface JARExposerContentView ()

@property (strong, nonatomic) JARExposerContentViewAttributes *attributes;

@end

@implementation JARExposerContentView

- (id)initWithAttributes:(JARExposerContentViewAttributes *)attributes reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        if (attributes == nil) {
            _attributes = [JARExposerContentViewAttributes contentViewAttributesForIndex:0];
            _attributes.bounds = [[UIScreen mainScreen] bounds];
            _attributes.center = CGPointMake(CGRectGetWidth(_attributes.bounds)/2, CGRectGetHeight(_attributes.bounds)/2);
            _attributes.alpha = 1.f;
        } else {
            _attributes = attributes;
        }
        
        _index = _attributes.index;
        
        self.center = _attributes.center;
        self.bounds = _attributes.bounds;
        
        if ([reuseIdentifier length] == 0)
            _reuseIdentifier = @"JARExposerContentView";
        else
            _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithAttributes:nil reuseIdentifier:nil];
}

- (void)prepareForReuse
{
    
}

- (void)applyAttributes:(JARExposerContentViewAttributes *)attributes
{
    if (attributes != _attributes) {
        _attributes = attributes;
        
        _index = attributes.index;
                
        self.alpha = attributes.alpha;
        self.hidden = attributes.isHidden;
    }
}

@end
