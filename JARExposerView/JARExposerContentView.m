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

- (void)applyAttributes:(JARExposerContentViewAttributes *)attributes
{
    if (attributes != _attributes) {
        _attributes = attributes;
        
        self.frame = attributes.frame;
        self.center = attributes.center;
        self.alpha = attributes.alpha;
        self.hidden = attributes.isHidden;
        
        self.layer.transform = attributes.transform3D;
        self.layer.opacity = attributes.alpha;
        self.layer.zPosition = attributes.zIndex;
    }
}

@end
