//
//  Board.h
//  patrico
//
//  Created by master on 07.01.15.
//  Copyright 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCAnimation.h"

#import "Field.h"
#import "Token.h"

//Constants (values in points == NON-RETINA Resolution)
#define FIELD_WIDTH 50;
#define FIELD_HEIGHT 50;

#define BOARD_WIDTH 950;
#define BOARD_HEIGHT 500;

//possible fields on the boards width (ROWS) and height (COLUMNS)
#define ROWS 10;
#define COLUMNS 19;

#define MIN_FIELDS 50;
#define MAX_FIELDS 100;

static const NSUInteger columnCount = COLUMNS;
static const NSUInteger rowCount = ROWS;
static const NSInteger maximumAmountOfFields = MAX_FIELDS;
static const NSInteger minimumAmountOfFields = MIN_FIELDS;

static const NSInteger fieldWidth = FIELD_WIDTH;
static const NSInteger fieldHeight = FIELD_HEIGHT;
static const NSInteger boardWidth = BOARD_WIDTH;
static const NSInteger boardHeight = BOARD_HEIGHT;

static const CGSize fieldSize = {fieldWidth,fieldHeight};
static const CGSize boardSize = {boardWidth,boardHeight};

//Vectors for boardmatrix directions
static const CGPoint MOVE_UP = {0, 1};
static const CGPoint MOVE_DOWN = {0, -1};
static const CGPoint MOVE_LEFT = {-1, 0};
static const CGPoint MOVE_RIGHT = {1, 0};

typedef NS_ENUM(NSInteger, boardState) {
    initial,
    moveImpossible,
    jailed, //indicates whether the dice score is higher than the fields to go when near finish
    gameOver,
    nothing
};

//this class represents the board of the game, holding all necessary parts of the game
@interface Board : CCSprite {
}

@property (nonatomic,retain) NSMutableArray *allPossibleFields;
@property (nonatomic,retain) NSMutableArray *currentFields; //actually created fields by the random field algorithm
//@property (nonatomic) bool gameOver;
//@property (nonatomic) bool moveImpossible;
//@property (nonatomic) bool jailed;
@property (nonatomic) boardState currentBoardState;
@property (nonatomic) bool aniReady;

- (id)init;
-(void)addTokenToBoard:(Token*)theToken;
-(void)moveToken:(Token*)theToken withResult:(NSInteger)theDicingResult;

@end
