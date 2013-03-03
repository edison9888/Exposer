//
//  ContentViewController.m
//  Exposer
//
//  Created by Jesse Armand on 17/2/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"I'm Exposed!", @"");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"")
                                                                              style:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(close:)];
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

#pragma mark - Actions

- (void)close:(id)sender
{
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil && ![parentViewController respondsToSelector:@selector(concealViewControllerAnimated:completion:)])
        parentViewController = parentViewController.parentViewController;
    
    if (parentViewController != nil && [parentViewController respondsToSelector:@selector(concealViewControllerAnimated:completion:)])
        [(JARExposerViewController *)parentViewController concealViewControllerAnimated:YES completion:^{ }];
}

@end
