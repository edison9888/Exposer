//
//  JARExposerViewController.m
//  Exposer
//
//  Created by Jesse Armand on 17/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "JARExposerViewController.h"

#import "JARExposerContentViewAttributes.h"

@interface JARExposerViewController () 

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
