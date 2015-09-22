//
//  Field.h
//  patrico
//
//  Created by master on 07.01.15.
//  Copyright 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef NS_ENUM(NSInteger, FieldType) {
    Normal,
    Jail,
    Hole,
    Yellow,
    Green,
    Start,
    Finish
};

@interface Field : CCSprite {
}

@property FieldType fieldType;
@property CGPoint boardIndex;

-(void)setFieldTypeTo:(FieldType)theType;

@end
