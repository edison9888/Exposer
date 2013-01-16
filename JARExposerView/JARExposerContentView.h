//
//  JARExposerContentView.h
//  Exposer
//
//  Created by Jesse Armand on 14/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JARExposerContentView : UIView

@property (copy, readonly, nonatomic) NSString *reuseIdentifier;

- (void)prepareForReuse;

@end
