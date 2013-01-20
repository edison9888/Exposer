//
//  JARExposerView.m
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "JARExposerView.h"

#import "JARExposerContentViewAttributes.h"
#import "JARExposerContentView.h"

@interface JARExposerView ()

@property (strong, nonatomic) NSMutableArray *visibleViews;
@property (strong, nonatomic) NSMutableDictionary *reuseQueues;

@end

@implementation JARExposerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _visibleViews = [NSMutableArray arrayWithCapacity:0];
        _reuseQueues = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateVisibleViews];
}

#pragma mark - Public

- (JARExposerContentView *)dequeueReusableViewWithIdentifier:(NSString *)viewIdentifier forIndex:(NSUInteger)index
{
    NSMutableArray *reusableViews = [_reuseQueues objectForKey:viewIdentifier];
    JARExposerContentView *reusableView = [reusableViews lastObject];

    JARExposerContentViewAttributes *attributes;
    if ([_dataSource respondsToSelector:@selector(contentViewAttributes)])
        attributes = [_dataSource contentViewAttributes];
    
    if (reusableView != nil) {
        [reusableViews removeObjectAtIndex:[reusableViews count] - 1];
    } else {
        if (attributes == nil) {
            attributes = [JARExposerContentViewAttributes contentViewAttributesForIndex:index];
            attributes.frame = self.bounds;
            attributes.alpha = 1.f;
            attributes.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        }

        JARExposerContentView *contentView = [[JARExposerContentView alloc] initWithFrame:attributes.frame reuseIdentifier:viewIdentifier];
        reusableView = contentView;
    }
    
    return reusableView;
}

- (JARExposerContentView *)contentVewAtIndex:(NSUInteger)index
{
    JARExposerContentView *contentView;
    
    if ([_visibleViews count] > index)
        contentView = [_visibleViews objectAtIndex:index];
    
    return contentView;
}

- (void)reloadData
{
    [_visibleViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIView class]])
            [obj removeFromSuperview];
    }];
    
    [_visibleViews removeAllObjects];
    
    [self setNeedsLayout];
}

- (void)scrollToContentViewAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    
}

#pragma mark - Private

- (void)updateVisibleViews
{
    CGRect visibleBounds = self.bounds;
    CGFloat pageWidth = CGRectGetWidth(self.bounds);    
    NSInteger firstVisibleIndex = floorf(CGRectGetMinX(visibleBounds) / pageWidth);
    firstVisibleIndex = MAX(firstVisibleIndex, 0);
    NSInteger lastVisibleIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / pageWidth);
    lastVisibleIndex = MIN(lastVisibleIndex, [self.visibleViews count] - 1);
    
    for (JARExposerContentView *contentView in _visibleViews)
    {
        if (![contentView isDescendantOfView:self])
            [self addSubview:contentView];
    }
}

@end
