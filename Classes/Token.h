//
//  Token.h
//  patrico
//
//  Created by master on 07.01.15.
//  Copyright 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef NS_ENUM(NSInteger, TokenColor) {
    Blue = 0,
    Red
};


@interface Token : CCSprite {
    
}
@property (readonly) TokenColor tokenColor;
@property NSInteger currentFieldNr;

-(id)initWithColor:(TokenColor)theColor;

@end
