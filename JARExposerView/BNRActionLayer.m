//
//  BNRActionLayer.h
//
//  Created by Joe Conway on 8/12/09.
//  Copyright (c) 2009 Big Nerd Ranch. All rights reserved.
//

#import "BNRActionLayer.h"

// Declare a private class to keep track of target-action pairs
@interface BNRActionLayerTargetActionPair : NSObject

@property (nonatomic) id target;
@property (nonatomic) SEL action;

@end

@implementation BNRActionLayerTargetActionPair
@end

@interface BNRActionLayer ()

@property (strong, nonatomic) NSMutableDictionary *targetActionPairs;

- (NSMutableArray *)pairsForKey:(NSString *)key;

@end

@implementation BNRActionLayer

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    for (NSString *observedKey in _targetActionPairs) {
        if ([self animationForKey:observedKey] == theAnimation) {
            NSMutableArray *pairs = [self pairsForKey:observedKey];
            [self removeAnimationForKey:observedKey];
            for (BNRActionLayerTargetActionPair *pair in pairs) {
                if(flag)
                    [[pair target] performSelector:[pair action] withObject:self];
            }
        }
    }
}

- (void)addAnimation:(CAAnimation *)theAnimation forKey:(NSString *)key
{
    NSArray *targetActionsForThisKey = [_targetActionPairs objectForKey:key];
    if ([targetActionsForThisKey count] > 0) {
        [theAnimation setRemovedOnCompletion:NO];
        [theAnimation setDelegate:self];
    }
    [super addAnimation:theAnimation forKey:key];
}

- (void)addTarget:(id)target action:(SEL)action forKey:(NSString *)key
{
    if (_targetActionPairs == nil)
        _targetActionPairs = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSMutableArray *pairsForKey = [self pairsForKey:key];
    if (pairsForKey == nil) {
        pairsForKey = [NSMutableArray arrayWithCapacity:0];
        [_targetActionPairs setObject:pairsForKey forKey:key];
    }
	
    for (BNRActionLayerTargetActionPair *pair in pairsForKey) {
        if (pair.target == target && pair.action == action)
            return;
    }
	
    BNRActionLayerTargetActionPair *newPair = [[BNRActionLayerTargetActionPair alloc] init];
    [newPair setTarget:target];
    [newPair setAction:action];
    [pairsForKey addObject:newPair];
}

- (void)removeTarget:(id)target action:(SEL)action forKey:(NSString *)key
{
    NSMutableArray *pairsForKey = [self pairsForKey:key];
    if (pairsForKey == nil)
		return;
    
    BNRActionLayerTargetActionPair *removablePair = nil;
    for(BNRActionLayerTargetActionPair *pair in pairsForKey) {
        if (pair.target == target && pair.action == action) {
            removablePair = pair;
            break;
        }
    }
    [pairsForKey removeObject:removablePair];
}

- (NSMutableArray *)pairsForKey:(NSString *)key
{
    return [_targetActionPairs objectForKey:key];
}

- (NSArray *)actionsForTarget:(id)target forKey:(NSString *)key
{
    NSMutableArray *actions = [NSMutableArray array];
    NSMutableArray *pairsForKey = [self pairsForKey:key];
    for(BNRActionLayerTargetActionPair *pair in pairsForKey) {
        if(pair.target == target)
            [actions addObject:NSStringFromSelector([pair action])];
    }
    return [NSArray arrayWithArray:actions];
}

@end
