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

@property (nonatomic) BOOL presentingContent;

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
    
    if (!_presentingContent)
        [self updateVisibleViews];
    else
        [self presentContentViews];
}

- (void)didMoveToSuperview
{
    if (_animatesPresentation)
        _presentingContent = YES;
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

- (void)exposeContentView:(JARExposerContentView *)contentView
{
    NSInteger contentViewIndex = contentView.index;
    
    NSUInteger numberOfContentViews = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfContentViews)])
        numberOfContentViews = [self.dataSource numberOfContentViews];
    
    CGFloat contentViewWidth = 0.f;
    CGFloat contentViewHeight = 0.f;
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        JARExposerContentViewAttributes *attributes = [self.dataSource contentViewAttributesAtIndex:0];
        contentViewWidth = attributes.size.width;
        contentViewHeight = attributes.size.height;
    }
    
    CGPoint endPosition = contentView.layer.position;
    
    UIBezierPath *presentationPath = [UIBezierPath bezierPath];
    CGPoint startPoint = { CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) + contentViewHeight };
    [presentationPath moveToPoint:startPoint];
    
    CGPoint firstEndPoint = { -(numberOfContentViews * contentViewWidth), endPosition.y };
    [presentationPath addQuadCurveToPoint:firstEndPoint controlPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds) + contentViewHeight)];
    
    [presentationPath addLineToPoint:endPosition];
        
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.path = presentationPath.CGPath;
    keyframeAnimation.duration = 1.0 + 1.0 / (contentViewIndex + 1);
    keyframeAnimation.calculationMode = kCAAnimationCubicPaced;
    keyframeAnimation.delegate = self;
        
    CABasicAnimation *scalingAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scalingAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 0.4)];
    scalingAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scalingAnimation.delegate = self;
    
    NSString *animationKey = [NSString stringWithFormat:@"ExposerPresentationAnimation-%d", contentViewIndex];
    if (contentViewIndex == numberOfContentViews-1)
        animationKey = @"LastContentViewAnimation";
    
    CAAnimationGroup *groupAnimation = (CAAnimationGroup *)[self.layer animationForKey:animationKey];
    if (groupAnimation == nil) {
        groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = @[keyframeAnimation, scalingAnimation];
        groupAnimation.duration = 1.0 + 1.0 / (contentViewIndex + 1);
        groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        groupAnimation.delegate = self;        
        [groupAnimation setValue:animationKey forKey:@"animationKey"];
        
        [contentView.layer addAnimation:groupAnimation forKey:animationKey];
    }
    
    [self addSubview:contentView];
}

- (void)presentContentViews
{
    [_visibleViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIView class]])
            [obj removeFromSuperview];
    }];
    
    [_visibleViews removeAllObjects];
    
    NSUInteger numberOfContentViews = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfContentViews)])
        numberOfContentViews = [self.dataSource numberOfContentViews];    
    
    // Animate the content views from the last to the first. 
    
    for (NSInteger contentViewIndex = numberOfContentViews-1; contentViewIndex >= 0; contentViewIndex--)
    {
        JARExposerContentView *contentView = [self.dataSource exposerView:self contentViewAtIndex:contentViewIndex];
        [self exposeContentView:contentView];
    }
}

#pragma mark - Private

- (NSInteger)firstVisibleIndex
{
    CGRect visibleBounds = self.bounds;
    CGFloat contentViewWidth = CGRectGetWidth(visibleBounds);
    
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        JARExposerContentViewAttributes *attributes = [self.dataSource contentViewAttributesAtIndex:0];
        contentViewWidth = attributes.size.width;
    }
    
    NSInteger firstVisibleIndex = floorf(self.contentOffset.x / contentViewWidth);
    firstVisibleIndex = MAX(firstVisibleIndex, 0);
    return firstVisibleIndex;
}

- (NSInteger)lastVisibleIndex
{
    CGRect visibleBounds = self.bounds;
    CGFloat contentViewWidth = CGRectGetWidth(visibleBounds);
    
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        JARExposerContentViewAttributes *attributes = [self.dataSource contentViewAttributesAtIndex:0];
        contentViewWidth = attributes.size.width;
    }
    
    NSUInteger numOfContentViews = [self.dataSource numberOfContentViews];
    
    NSInteger lastVisibleIndex = ceilf((self.contentOffset.x + contentViewWidth) / contentViewWidth);
    
    CGFloat totalWidth = numOfContentViews * contentViewWidth;
    if (totalWidth <= CGRectGetWidth(self.bounds))
        lastVisibleIndex = MIN(lastVisibleIndex, numOfContentViews - 1);
    else
        lastVisibleIndex = MAX(lastVisibleIndex, numOfContentViews - 1);
    
    return lastVisibleIndex;
}

- (void)updateContentSize
{
    CGFloat contentViewWidth = CGRectGetWidth(self.bounds);
    
    if ([self.dataSource respondsToSelector:@selector(contentViewAttributesAtIndex:)]) {
        JARExposerContentViewAttributes *attributes = [self.dataSource contentViewAttributesAtIndex:0];
        contentViewWidth = attributes.size.width;
    }
 
    NSUInteger numberOfContentViews = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfContentViews)])
        numberOfContentViews = [self.dataSource numberOfContentViews];
    
    CGFloat contentWidth = (numberOfContentViews > 0) ? (numberOfContentViews * contentViewWidth) : contentViewWidth;
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

- (void)updateVisibleViews
{
    [self updateContentSize];
    
    NSInteger firstVisibleIndex = [self firstVisibleIndex];
    NSInteger lastVisibleIndex = [self lastVisibleIndex];
        
    NSArray *visibleViews = [_visibleViews copy];
    for (JARExposerContentView *contentView in visibleViews)
    {
        if (contentView.index < firstVisibleIndex || contentView.index > lastVisibleIndex) {
            [self reuseView:contentView];
            [_visibleViews removeObject:contentView];
        }
    }
    
    visibleViews = [_visibleViews copy];
    
    for (NSInteger contentViewIndex = firstVisibleIndex; contentViewIndex <= lastVisibleIndex; ++contentViewIndex)
    {
        JARExposerContentView *contentView = [self.dataSource exposerView:self contentViewAtIndex:contentViewIndex];
        
        if (contentViewIndex >= [visibleViews count]) {
            
            if (![_visibleViews containsObject:contentView]) {
                [_visibleViews addObject:contentView];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:willPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self willPresentContentViewAtIndex:contentViewIndex];
                
                [contentView presentOnView:self animated:contentView.animatesPresentation];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:didPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self didPresentContentViewAtIndex:contentViewIndex];
            }
            
        } else if (contentViewIndex <= firstVisibleIndex) {
            
            if (![_visibleViews containsObject:contentView]) {
                [_visibleViews insertObject:contentView atIndex:0];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:willPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self willPresentContentViewAtIndex:contentViewIndex];
                
                [contentView presentOnView:self animated:contentView.animatesPresentation];
                
                if ([self.delegate respondsToSelector:@selector(exposerView:didPresentContentViewAtIndex:)])
                    [self.delegate exposerView:self didPresentContentViewAtIndex:contentViewIndex];
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

#pragma mark - CAAnimation delegates

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished) {
        NSString *animationKey = [anim valueForKey:@"animationKey"];
        if ([animationKey isEqualToString:@"LastContentViewAnimation"]) {
            _presentingContent = NO;            
        }
    }
}

@end
