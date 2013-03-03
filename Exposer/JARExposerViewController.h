//
//  JARExposerViewController.h
//  Exposer
//
//  Created by Jesse Armand on 17/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JARExposerView;

@protocol JARViewControllerPresentation 

- (void)exposeViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)concealViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

@interface JARExposerViewController : UIViewController <JARViewControllerPresentation>

@property (strong, nonatomic) JARExposerView *exposerView;

@property (strong, nonatomic) UIViewController *exposedViewController;

@end
