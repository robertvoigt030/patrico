//
//  Player.h
//  patrico
//
//  Created by master on 10.03.15.
//  Copyright 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

@interface Player : CCNode {
    
}

@property (nonatomic,strong) Token *myToken;
@property (nonatomic,strong) NSString *playerID;
@property (nonatomic) bool myTurn;

@end
