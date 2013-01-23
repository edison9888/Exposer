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
    
    [self updateVisibleViewsAnimated:YES];
}

#pragma mark - Public

- (JARExposerContentView *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier forIndex:(NSUInteger)index
{
    NSMutableArray *reusableViews = _reuseQueues[reuseIdentifier];
    JARExposerContentView *reusableView = [reusableViews lastObject];

    JARExposerContentViewAttributes *attributes;
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        attributes = [self.dataSource contentViewAttributesAtIndex:index];
    }
    
    if (reusableView != nil) {
        [reusableViews removeObjectAtIndex:[reusableViews count] - 1];
    } else {
        if (attributes == nil) {
            attributes = [JARExposerContentViewAttributes contentViewAttributesForIndex:index];
            attributes.edgeInsets = UIEdgeInsetsZero;
            attributes.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
            attributes.bounds = self.bounds;
            attributes.alpha = 1.f;
            attributes.index = index;
        }

        reusableView = [[JARExposerContentView alloc] initWithAttributes:attributes reuseIdentifier:reuseIdentifier];
    }
    
    UIEdgeInsets edgeInsets = attributes.edgeInsets;
    
    CGRect frame = reusableView.frame;
    CGFloat width = CGRectGetWidth(attributes.bounds) - (edgeInsets.left + edgeInsets.right);
    CGFloat height = CGRectGetHeight(attributes.bounds) - (edgeInsets.top + edgeInsets.bottom);
    
    frame.origin.x = edgeInsets.left + (edgeInsets.left + width + edgeInsets.right)*index;
    frame.origin.y = edgeInsets.top;
    frame.size.width = width;
    frame.size.height = height;
    reusableView.frame = frame;
    [reusableView applyAttributes:attributes];
    
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

- (void)updateContentSize
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        JARExposerContentViewAttributes *attributes = [self.dataSource contentViewAttributesAtIndex:0];
        CGFloat attributesWidth = CGRectGetWidth(attributes.bounds);
        if (attributesWidth > pageWidth)
            pageWidth = attributesWidth;
    }
 
    NSUInteger numberOfContentViews = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfContentViews)])
        numberOfContentViews = [self.dataSource numberOfContentViews];
    
    CGFloat contentWidth = (numberOfContentViews > 0) ? (numberOfContentViews * pageWidth) : pageWidth;
    
    self.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(self.bounds));
}

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

- (void)updateVisibleViewsAnimated:(BOOL)animated
{
    [self updateContentSize];
    
    CGRect visibleBounds = self.bounds;
    CGFloat pageWidth = CGRectGetWidth(visibleBounds);
    
    NSUInteger numOfContentViews = [self.dataSource numberOfContentViews];
        
    NSInteger firstVisibleIndex = floorf(self.contentOffset.x / pageWidth);
    firstVisibleIndex = MAX(firstVisibleIndex, 0);
    NSInteger lastVisibleIndex = ceilf((self.contentOffset.x + pageWidth) / pageWidth);
    lastVisibleIndex = MIN(lastVisibleIndex, numOfContentViews - 1);
    
    NSArray *visibleViews = [_visibleViews copy];
    for (JARExposerContentView *contentView in visibleViews)
    {
        if (contentView.index < firstVisibleIndex || contentView.index > lastVisibleIndex) {
            [self reuseView:contentView];
            [_visibleViews removeObject:contentView];
        }
    }
    
    visibleViews = [_visibleViews copy];
    
    for (NSInteger pageIndex = firstVisibleIndex; pageIndex <= lastVisibleIndex; ++pageIndex)
    {
        JARExposerContentView *contentView = [self.dataSource exposerView:self contentViewAtIndex:pageIndex];
        contentView.animatePresentation = animated;
        
        if (contentView.index >= [visibleViews count]) {
            [_visibleViews addObject:contentView];
            [self addSubview:contentView];
        } else if (contentView.index <= firstVisibleIndex) {
            [_visibleViews insertObject:contentView atIndex:0];
            [self addSubview:contentView];
        }
    }
}

@end
