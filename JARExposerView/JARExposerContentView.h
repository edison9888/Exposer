//
//  JARExposerContentView.h
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class JARExposerContentViewAttributes;

@interface JARExposerContentView : UIView

@property (copy, readonly, nonatomic) NSString *reuseIdentifier;
@property (readonly, nonatomic) NSUInteger index;

- (id)initWithAttributes:(JARExposerContentViewAttributes *)attributes reuseIdentifier:(NSString *)reuseIdentifier;

- (void)prepareForReuse;

- (void)applyAttributes:(JARExposerContentViewAttributes *)attributes;

- (void)presentOnView:(UIView *)containerView animated:(BOOL)animated;

@end
