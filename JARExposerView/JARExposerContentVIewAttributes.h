//
//  JARExposerContentViewAttributes.h
//  Exposer
//
//  Created by Jesse Armand on 16/1/13.
//  Copyright (c) 2013 Jesse Armand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JARExposerContentViewAttributes : NSObject

+ (instancetype)contentViewAttributesForIndex:(NSUInteger)index;

@property (nonatomic) CGRect bounds;
@property (nonatomic) CGPoint center;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic, getter = isHidden) BOOL hidden;
@property (nonatomic) float alpha;
@property (nonatomic) CATransform3D transform3D;
@property (nonatomic) NSInteger zIndex;
@property (nonatomic) NSUInteger index;

@end
