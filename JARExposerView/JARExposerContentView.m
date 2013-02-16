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

#pragma mark - NSObject

- (NSUInteger)hash
{
    return _index;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[JARExposerContentView class]])
        return NO;
        
    return ([object index] == _index);
}

#pragma mark - UIView

- (id)initWithAttributes:(JARExposerContentViewAttributes *)attributes reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        if (attributes == nil) {
            _attributes = [JARExposerContentViewAttributes contentViewAttributesForIndex:0];
            _attributes.size = [[UIScreen mainScreen] bounds].size;
            _attributes.center = CGPointMake(_attributes.size.width/2, _attributes.size.height/2);
            _attributes.alpha = 1.f;
        } else {
            _attributes = attributes;
        }
        
        _index = _attributes.index;
        
        self.center = _attributes.center;
        self.bounds = CGRectMake(0, 0, _attributes.size.width, _attributes.size.height);
        
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

- (void)applyAttributes:(JARExposerContentViewAttributes *)attributes
{
    if (attributes != _attributes) {
        _attributes = attributes;
        
        _index = attributes.index;
                
        self.alpha = attributes.alpha;
        self.hidden = attributes.isHidden;
    }
}

- (void)presentOnView:(UIView *)containerView animated:(BOOL)animated
{
    if ([self isDescendantOfView:containerView])
        return;
    
    if (animated) {
        CATransform3D initialTransform = CATransform3DMakeScale(0.01, 0.01, 0.01);
        CATransform3D finalTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        CABasicAnimation *scalingAnimation = [self transformAnimationForKey:@"Scale" initialTransform:initialTransform finalTransform:finalTransform];
        
        CATransform3D rotateTransform = CATransform3DRotate(initialTransform, M_PI, 0.0, 1.0, 0.0);
        CABasicAnimation *rotateAnimation = [self transformAnimationForKey:@"Rotate" initialTransform:rotateTransform finalTransform:self.layer.transform];
        
        CAAnimationGroup *groupAnimation = (CAAnimationGroup *)[self.layer animationForKey:@"RotateAndScale"];
        if (groupAnimation == nil) {
            groupAnimation = [CAAnimationGroup animation];
            groupAnimation.animations = @[scalingAnimation, rotateAnimation];
            groupAnimation.duration = 0.5;
            groupAnimation.delegate = self;
            [self.layer addAnimation:groupAnimation forKey:@"RotateAndScale"];
        }
    }
    
    [containerView addSubview:self];
}

- (void)prepareForReuse
{
    
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (!_animateSelection)
        return;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.layer.transform = CATransform3DMakeScale(2, 2, 2);
    } completion:^(BOOL finished) {
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (!_animateSelection)
        return;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:^(BOOL finished) {
        self.layer.transform = CATransform3DIdentity;
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (!_animateSelection)
        return;
    
    self.layer.transform = CATransform3DIdentity;
}

#pragma mark - Animation

- (CABasicAnimation *)transformAnimationForKey:(NSString *)key initialTransform:(CATransform3D)initialTransform finalTransform:(CATransform3D)finalTransform
{
    CABasicAnimation *transformAnimation = (CABasicAnimation *)[self.layer animationForKey:key];
    if (transformAnimation == nil) {
        transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        [transformAnimation setValue:key forKey:@"animationId"];
        transformAnimation.fromValue  = [NSValue valueWithCATransform3D:initialTransform];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:finalTransform];
        transformAnimation.duration = 0.5;
        transformAnimation.delegate = self;
    }
    return transformAnimation;
}

#pragma mark - CAAnimation delegate

- (void)animationDidStart:(CAAnimation *)anim
{
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
}

@end
