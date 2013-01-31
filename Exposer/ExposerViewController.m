//
//  ExposerViewController.m
//  Exposer
//
//  Created by Jesse Armand on 12/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "ExposerViewController.h"

@interface ExposerViewController () 

@property (strong, nonatomic) JARExposerView *presentationView;

@end

@implementation ExposerViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Exposer View

- (NSUInteger)numberOfContentViews
{
    return 10;
}

- (JARExposerContentViewAttributes *)contentViewAttributesAtIndex:(NSUInteger)index
{
    JARExposerContentViewAttributes *attributes = [JARExposerContentViewAttributes contentViewAttributesForIndex:index];
    attributes.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    attributes.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    attributes.alpha = 1.f;
    return attributes;
}

- (JARExposerContentView *)exposerView:(JARExposerView *)exposerView contentViewAtIndex:(NSUInteger)index
{
    static NSString *viewIdentifier = @"ContentView";
    
    JARExposerContentView *contentView = [exposerView dequeueReusableViewWithIdentifier:viewIdentifier forIndex:index];
    
    if ([[contentView.layer sublayers] count] == 0) {
        CGFloat contentWidth = (CGRectGetWidth(contentView.bounds) - 20.f)/4;
        
        CGPoint center = CGPointMake(CGRectGetWidth(contentView.bounds)/2, CGRectGetHeight(contentView.bounds)/2);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:contentWidth startAngle:0.f endAngle:2*M_PI clockwise:NO];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.fillColor = [UIColor blueColor].CGColor;
        shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
        shapeLayer.lineWidth = 10.f;
        
        [contentView.layer addSublayer:shapeLayer];
        
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 15.f;
    }
    
    contentView.backgroundColor = [UIColor redColor];
    
    return contentView;
}

- (void)exposerView:(JARExposerView *)exposerView didSelectContentViewAtIndex:(NSUInteger)index
{
    JARExposerContentView *contentView = [exposerView contentViewAtIndex:index];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        contentView.layer.transform = CATransform3DMakeRotation(M_PI_2/3, 0, 0, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            contentView.layer.transform = CATransform3DMakeRotation(-M_PI_2/3, 0, 0, 1);
        } completion:^(BOOL finished) {
            contentView.transform = CGAffineTransformMakeRotation(0);
        }];
    }];
    
    NSLog(@"Selected content view %@", contentView);
}

@end
