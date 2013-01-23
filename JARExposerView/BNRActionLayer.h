//
//  BNRActionLayer.h
//
//  Created by Joe Conway on 8/12/09.
//  Copyright (c) 2009 Big Nerd Ranch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface BNRActionLayer : CALayer

- (void)addTarget:(id)target action:(SEL)action forKey:(NSString *)key;
- (void)removeTarget:(id)target action:(SEL)action forKey:(NSString *)key;
- (NSArray *)actionsForTarget:(id)target forKey:(NSString *)key;

@end
