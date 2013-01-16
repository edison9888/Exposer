//
//  ExposerViewController.m
//  Exposer
//
//  Created by Jesse Armand on 12/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "ExposerViewController.h"

#import "JARExposerView.h"

@interface ExposerViewController () <JARExposerViewDataSource, JARExposerViewDelegate>

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
    
    JARExposerView *presentationView = [[JARExposerView alloc] initWithFrame:self.view.bounds];
    presentationView.dataSource = self;
    presentationView.delegate = self;
    
    self.presentationView = presentationView;
    
    [self.view addSubview:presentationView];
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

@end
