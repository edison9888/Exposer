//
//  JARExposerViewController.h
//  Exposer
//
//  Created by Jesse Armand on 17/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JARExposerView.h"

@interface JARExposerViewController : UIViewController <JARExposerViewDataSource, JARExposerViewDelegate>

@property (strong, nonatomic) JARExposerView *exposerView;

@property (strong, nonatomic) UIViewController *exposedViewController;

- (void)exposeViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

@end
