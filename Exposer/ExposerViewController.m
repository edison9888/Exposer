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

- (JARExposerContentView *)exposerView:(JARExposerView *)exposerView contentViewAtIndex:(NSUInteger)index
{
    static NSString *viewIdentifier = @"ContentView";
    JARExposerContentView *contentView = [exposerView dequeueReusableViewWithIdentifier:viewIdentifier forIndex:index];
    return contentView;
}

@end