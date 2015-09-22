//
//  Dice.m
//  patrico
//
//  Created by master on 12.04.15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "Dice.h"

@implementation Dice

-(NSInteger)throwDice
{
    return [self randomNumberBetween:minScore maxNumber:maxScore];
}

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform(max - min + 1);
}

@end
