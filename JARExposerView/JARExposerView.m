//
//  JARExposerView.m
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "JARExposerView.h"

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

- (JARExposerContentView *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier forIndex:(NSUInteger)index
{
    NSMutableArray *reusableViews = _reuseQueues[reuseIdentifier];
    JARExposerContentView *reusableView = [reusableViews lastObject];

    JARExposerContentViewAttributes *attributes;
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributes)])
        attributes = [self.dataSource contentViewAttributes];
    
    if (reusableView != nil) {
        [reusableViews removeObjectAtIndex:[reusableViews count] - 1];
    } else {
        if (attributes == nil) {
            attributes = [JARExposerContentViewAttributes contentViewAttributesForIndex:index];
            attributes.frame = self.bounds;
            attributes.alpha = 1.f;
            attributes.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        }

        JARExposerContentView *contentView = [[JARExposerContentView alloc] initWithFrame:attributes.frame reuseIdentifier:reuseIdentifier];
        CGRect frame = contentView.frame;
        frame.origin.x = frame.origin.x + CGRectGetWidth(frame)*index;
        contentView.frame = frame;

        [contentView applyAttributes:attributes];
        reusableView = contentView;
    }
    
    return reusableView;
}

- (JARExposerContentView *)contentViewAtIndex:(NSUInteger)index
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

- (void)reuseView:(JARExposerContentView *)view
{
    NSString *reuseIdentifier = view.reuseIdentifier;
    NSParameterAssert([reuseIdentifier length]);
    
    [view removeFromSuperview];
    [view prepareForReuse];
    
    NSMutableArray *reusableViews = _reuseQueues[reuseIdentifier];
    if (reusableViews == nil) {
        reusableViews = [NSMutableArray arrayWithCapacity:0];
        _reuseQueues[reuseIdentifier] = reusableViews;
    }
    
    [reusableViews addObject:view];
}

- (void)updateVisibleViews
{
    CGRect visibleBounds = self.bounds;
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    
    NSUInteger numOfVisibleViews = [_visibleViews count];
        
    NSInteger firstVisibleIndex = floorf(CGRectGetMinX(visibleBounds) / pageWidth);
    firstVisibleIndex = MAX(firstVisibleIndex, 0);
    NSInteger lastVisibleIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / pageWidth);
    lastVisibleIndex = MIN(lastVisibleIndex, numOfVisibleViews - 1);
    
    NSArray *visibleViews = [_visibleViews copy];
    for (JARExposerContentView *contentView in visibleViews)
    {
        if (contentView.index < firstVisibleIndex || contentView.index > lastVisibleIndex) {
            [self reuseView:contentView];
            [_visibleViews removeObject:contentView];
        }
    }
    
    visibleViews = [_visibleViews copy];
    
    if (numOfVisibleViews == 0)
        lastVisibleIndex = [self.dataSource numberOfContentViews];
    
    for (NSInteger pageIndex = firstVisibleIndex; pageIndex < lastVisibleIndex; ++pageIndex)
    {
        JARExposerContentView *contentView = [self.dataSource exposerView:self contentViewAtIndex:pageIndex];
        
        if ([visibleViews count] == 0) {
            [_visibleViews addObject:contentView];
            [self addSubview:contentView];
        } else {
            [visibleViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                JARExposerContentView *visibleContentView = obj;
                if (visibleContentView.index > pageIndex) {
                    [_visibleViews insertObject:contentView atIndex:idx];
                } else if (visibleContentView.index < pageIndex) {
                    [_visibleViews addObject:contentView];
                }
                
                [self addSubview:contentView];
            }];
        }
    }
    
    self.contentSize = CGSizeMake(numOfVisibleViews * pageWidth, CGRectGetHeight(self.bounds));
}

@end
