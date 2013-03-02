//
//  ExposerViewController.m
//  Exposer
//
//  Created by Jesse Armand on 12/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "ExposerViewController.h"

#import "ContentViewController.h"

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
    
    [self.exposerView scrollToContentViewAtIndex:[self numberOfContentViews]-1 animated:YES];
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
    attributes.size =  (CGSize){ CGRectGetWidth(self.view.bounds)/4, CGRectGetHeight(self.view.bounds)/4 };
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
        
        if (index == [self numberOfContentViews]-1) {
            shapeLayer.fillColor = [UIColor redColor].CGColor;
            shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        } else {
            shapeLayer.fillColor = [UIColor blueColor].CGColor;
            shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
        }

        shapeLayer.lineWidth = 10.f;
        
        [contentView.layer addSublayer:shapeLayer];
        
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 15.f;
    }
    
    contentView.animatesSelection = YES;
    contentView.animatesPresentation = YES;
    contentView.backgroundColor = [UIColor redColor];
    
    return contentView;
}

- (void)exposerView:(JARExposerView *)exposerView didSelectContentViewAtIndex:(NSUInteger)index
{
    ContentViewController *viewController = [[ContentViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self exposeViewController:navController animated:YES completion:^{ }];
}

@end
