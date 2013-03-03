//
//  JARExposerViewController.m
//  Exposer
//
//  Created by Jesse Armand on 17/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "JARExposerViewController.h"

#import "JARExposerViewDataSource.h"
#import "JARExposerViewDelegate.h"

#import "JARExposerView.h"
#import "JARExposerContentView.h"
#import "JARExposerContentViewAttributes.h"

@interface JARExposerViewController () <JARExposerViewDataSource, JARExposerViewDelegate, JARViewControllerPresentation>

@end

@implementation JARExposerViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:screenBounds];
    
    JARExposerView *exposerView = [[JARExposerView alloc] initWithFrame:self.view.bounds];
    exposerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    exposerView.dataSource = self;
    exposerView.delegate = self;
    exposerView.animatesPresentation = YES;
    _exposerView = exposerView;
    [self.view addSubview:_exposerView];
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

#pragma mark - Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.exposerView reloadData];
}

#pragma mark - Presentation

- (void)exposeViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self addChildViewController:viewController];
    
    CGRect bounds = self.view.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(bounds)/2, CGRectGetHeight(bounds)/2);

    viewController.view.center = center;
    viewController.view.bounds = bounds;
    viewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    [self.view addSubview:viewController.view];
    
    if (animated) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            viewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                _exposedViewController = viewController;
                
                if (completion)
                    completion();
            }
        }];
    } else {
        _exposedViewController = viewController;
        
        if (completion)
            completion();
    }
}

- (void)concealViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *childViewController = [self.childViewControllers lastObject];
    [childViewController removeFromParentViewController];
    
    if (animated) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            childViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [childViewController.view removeFromSuperview];
                _exposedViewController = nil;
                
                if (completion)
                    completion();
            }
        }];
    } else {
        [childViewController.view removeFromSuperview];
        _exposedViewController = nil;
        
        if (completion)
            completion();
    }
}

#pragma mark - JARExposerView data source

- (NSUInteger)numberOfContentViews
{
    return 0;
}

- (JARExposerContentViewAttributes *)contentViewAttributesAtIndex:(NSUInteger)index
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (JARExposerContentView *)exposerView:(JARExposerView *)exposerView contentViewAtIndex:(NSUInteger)index
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - JARExposerView delegate

- (void)exposerView:(JARExposerView *)exposerView willPresentContentViewAtIndex:(NSUInteger)index
{
    
}

- (void)exposerView:(JARExposerView *)exposerView didPresentContentViewAtIndex:(NSUInteger)index
{
    
}

@end
