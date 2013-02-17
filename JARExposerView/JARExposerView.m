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
@property (strong, nonatomic) NSCache *reuseQueueCache;

@end

@implementation JARExposerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _visibleViews = [NSMutableArray arrayWithCapacity:0];
        _reuseQueueCache = [[NSCache alloc] init];
        [_reuseQueueCache setName:@"JARExposerContentViewCache"];
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
    NSMutableArray *reusableViews = [_reuseQueueCache objectForKey:reuseIdentifier];
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
            attributes.size = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            attributes.alpha = 1.f;
            attributes.index = index;
        }

        reusableView = [[JARExposerContentView alloc] initWithAttributes:attributes reuseIdentifier:reuseIdentifier];
    }
    
    UIEdgeInsets edgeInsets = attributes.edgeInsets;
    
    CGRect frame = reusableView.frame;
    CGFloat width = attributes.size.width - (edgeInsets.left + edgeInsets.right);
    CGFloat height = attributes.size.height - (edgeInsets.top + edgeInsets.bottom);
    CGFloat statusBarHeight = 20.f;
    
    frame.origin.x = edgeInsets.left + (edgeInsets.left + width + edgeInsets.right)*index;
    frame.origin.y = (CGRectGetHeight(self.bounds) + statusBarHeight - height)/2 - edgeInsets.top;
    frame.size.width = width;
    frame.size.height = height;
    reusableView.frame = frame;
    [reusableView applyAttributes:attributes];
    
    return reusableView;
}

- (JARExposerContentView *)contentViewAtIndex:(NSUInteger)index
{
    __block JARExposerContentView *contentView;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[JARExposerContentView class]]) {
            if ([obj index] == index)
                contentView = obj;
        }
    }];
        
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
    JARExposerContentView *contentView = [self contentViewAtIndex:index];
    
    [self scrollRectToVisible:contentView.frame animated:animated];
}

#pragma mark - Private

- (void)updateContentSize
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        JARExposerContentViewAttributes *attributes = [self.dataSource contentViewAttributesAtIndex:0];
        pageWidth = attributes.size.width;
    }
 
    NSUInteger numberOfContentViews = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfContentViews)])
        numberOfContentViews = [self.dataSource numberOfContentViews];
    
    CGFloat contentWidth = (numberOfContentViews > 0) ? (numberOfContentViews * pageWidth) : pageWidth;
    if (contentWidth < CGRectGetWidth(self.bounds))
        contentWidth = CGRectGetWidth(self.bounds);
    
    self.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(self.bounds));
}

- (void)reuseView:(JARExposerContentView *)view
{
    NSString *reuseIdentifier = view.reuseIdentifier;
    NSParameterAssert([reuseIdentifier length]);
    
    [view removeFromSuperview];
    [view prepareForReuse];
    
    NSMutableArray *reusableViews = [_reuseQueueCache objectForKey:reuseIdentifier];
    if (reusableViews == nil) {
        reusableViews = [NSMutableArray arrayWithCapacity:0];
        [_reuseQueueCache setObject:reusableViews forKey:reuseIdentifier];
    }
    
    [reusableViews addObject:view];
}

- (void)updateVisibleViewsAnimated:(BOOL)animated
{
    [self updateContentSize];
    
    CGRect visibleBounds = self.bounds;
    CGFloat pageWidth = CGRectGetWidth(visibleBounds);
    
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        JARExposerContentViewAttributes *attributes = [self.dataSource contentViewAttributesAtIndex:0];
        pageWidth = attributes.size.width;
    }
    
    NSUInteger numOfContentViews = [self.dataSource numberOfContentViews];
        
    NSInteger firstVisibleIndex = floorf(self.contentOffset.x / pageWidth);
    firstVisibleIndex = MAX(firstVisibleIndex, 0);
    NSInteger lastVisibleIndex = ceilf((self.contentOffset.x + pageWidth) / pageWidth);
    
    CGFloat totalWidth = numOfContentViews * pageWidth;
    if (totalWidth <= CGRectGetWidth(self.bounds))
        lastVisibleIndex = MIN(lastVisibleIndex, numOfContentViews - 1);
    else
        lastVisibleIndex = MAX(lastVisibleIndex, numOfContentViews - 1);
    
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
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        NSUInteger contentIndex = contentView.index;
        
        if (contentIndex >= [visibleViews count]) {
            
            if (![_visibleViews containsObject:contentView]) {
                [_visibleViews addObject:contentView];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:willPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self willPresentContentViewAtIndex:contentIndex];
                
                [contentView presentOnView:self animated:animated];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:didPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self didPresentContentViewAtIndex:contentIndex];
            }
            
        } else if (contentIndex <= firstVisibleIndex) {
            
            if (![_visibleViews containsObject:contentView]) {
                [_visibleViews insertObject:contentView atIndex:0];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:willPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self willPresentContentViewAtIndex:contentIndex];
                
                [contentView presentOnView:self animated:animated];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:didPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self didPresentContentViewAtIndex:contentIndex];
            }
        }
    }
}

- (NSUInteger)indexOfViewAtPoint:(CGPoint)point
{
    __block NSUInteger viewIndex = NSNotFound;
    
    [_visibleViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        JARExposerContentView *visibleView = obj;
        
        if (CGRectContainsPoint(visibleView.frame, point)) {
            viewIndex = visibleView.index;
            *stop = YES;
        }
    }];
    
    return viewIndex;
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    NSInteger viewIndex = [self indexOfViewAtPoint:touchPoint];
    if (viewIndex != NSNotFound && [self.delegate respondsToSelector:@selector(exposerView:didSelectContentViewAtIndex:)])
        [self.delegate exposerView:self didSelectContentViewAtIndex:viewIndex];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

@end
