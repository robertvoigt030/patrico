//
//  Dice.h
//  patrico
//
//  Created by master on 12.04.15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MIN_SCORE 1;
#define MAX_SCORE 6;

static const NSUInteger minScore = MIN_SCORE;
static const NSUInteger maxScore = MAX_SCORE;

@interface Dice : NSObject

-(NSInteger)throwDice;

@end

