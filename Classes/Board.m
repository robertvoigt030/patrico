//
//  Board.m
//  patrico
//
//  Created by master on 07.01.15.
//  Copyright 2015 master. All rights reserved.
//

#import "Board.h"

NSMutableArray *currentStepPositions;

@implementation Board

@synthesize allPossibleFields,currentFields,currentBoardState,aniReady;

CGPoint redTokenPos;
CGPoint blueTokenPos;

// -----------------------------------------------------------------------
#pragma mark Initialization
// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"board_dark.png"];

    currentStepPositions = [[NSMutableArray alloc]init];
    currentFields = [[NSMutableArray alloc] init];
    [self initFieldArray];
    aniReady = YES;
    [self createRandomFieldsOnTheBoard];
    
    // done
    return self;
}

// -----------------------------------------------------------------------

-(void)initFieldArray
{
    allPossibleFields = [[NSMutableArray alloc] initWithCapacity:rowCount];
    
    for (int col = 0; col < columnCount; col++){
        
        NSMutableArray *nextCol = [[NSMutableArray alloc]initWithCapacity:rowCount];
        [allPossibleFields addObject:nextCol];
    }
    
    [self fillFieldArrayWithValues];
}

// -----------------------------------------------------------------------

-(void)fillFieldArrayWithValues
{
    CGPoint firstIndexCoord = ccp(fieldSize.width/2,fieldSize.height/2);

    CGPoint currentPoint = firstIndexCoord;
    
    for (int col = 0; col < columnCount; col++) {
        for(int row = 0; row < rowCount;row++){
            Field *newField;
            newField= [[Field alloc]init];
            currentPoint = ccp(firstIndexCoord.x+(col*fieldSize.width),firstIndexCoord.y+(row*fieldSize.height));
            newField.position = currentPoint;
            newField.boardIndex = ccp(col,row);
            newField.fieldType = Normal;
            [[allPossibleFields objectAtIndex:col] insertObject:newField atIndex:row];
        }
    }
}

// -----------------------------------------------------------------------
#pragma mark the field creation algorithm
// -----------------------------------------------------------------------

-(void) createRandomFieldsOnTheBoard
{
    CGPoint lastIndex;
    NSInteger maxSteps = 100;
    NSInteger currentSteps = 0;
    NSInteger fieldCounter = 0;
    NSInteger normalFieldCounter = 0;
    
    for (int fieldCount = 0; fieldCount < maximumAmountOfFields;fieldCount++){
        
        NSInteger myColRandom;
        NSInteger myRowRandom;
        NSInteger myFieldRandom = [self randomNumberBetween:Jail maxNumber:Green];
        
        if(fieldCount == 0){
            myColRandom = [self randomNumberBetween:0 maxNumber:columnCount-1];
            myRowRandom = [self randomNumberBetween:0 maxNumber:rowCount-1];
            myFieldRandom = Start;
            lastIndex = ccp(myColRandom,myRowRandom);
        }else{
            if([self chance:0.33] || normalFieldCounter > 4){
                normalFieldCounter = 0;
                myFieldRandom = [self randomNumberBetween:Jail maxNumber:Green];
            }else{
                myFieldRandom = Normal;
                normalFieldCounter++;
            }
            
            CGPoint newIndex;
            
            if (fieldCount == maximumAmountOfFields-1){
                myFieldRandom = Finish;
            }
            
            do{
                newIndex= ccpAdd([self checkBoundariesForIndex:lastIndex],lastIndex);
                currentSteps++;
                if((newIndex.x == lastIndex.x && newIndex.y == lastIndex.y) || currentSteps >= maxSteps){
                    [self addFieldToIndex:lastIndex withType:Finish];
                    //didn't find another valid field position, algorithm has to stop here by
                    //treating the actual field as a finish field
                    if(fieldCounter < minimumAmountOfFields){
                        [self restartRandomFieldCreation];
                    }
                    return;
                }
                
            }while([self checkIndexForNeighbourFields:newIndex lastIndex:lastIndex]);

            lastIndex = newIndex;
        }
        
        [self addFieldToIndex:lastIndex withType:myFieldRandom];
        fieldCounter++;
    }
}

// -----------------------------------------------------------------------
#pragma mark field  creation algorithm helpers
// -----------------------------------------------------------------------

//returns true if neighbour was found
-(bool)checkIndexForNeighbourFields:(CGPoint)potetialIndex lastIndex:(CGPoint)lastIndex
{
    CGPoint potDown = ccpAdd(potetialIndex, MOVE_DOWN);
    CGPoint potLeft = ccpAdd(potetialIndex, MOVE_LEFT);
    CGPoint potRight = ccpAdd(potetialIndex, MOVE_RIGHT);
    CGPoint potUp = ccpAdd(potetialIndex, MOVE_UP);
    CGPoint indexToCheck;
    
    NSArray *myPotentialIndices = @[[NSValue valueWithCGPoint:potDown],[NSValue valueWithCGPoint:potLeft],[NSValue valueWithCGPoint:potRight],[NSValue valueWithCGPoint:potUp]];
    
    for (int i = 0; i < [myPotentialIndices count];i++){
        indexToCheck = [myPotentialIndices[i] CGPointValue];
        
        if([self checkNeighbourHelper:indexToCheck lastIndex:lastIndex]){
            //there was a neighbour
            return true;
        }
    }
    
    return false;
}

// -----------------------------------------------------------------------

-(bool)checkNeighbourHelper:(CGPoint)modifiedIndex lastIndex:(CGPoint)lastIndex
{
    if(modifiedIndex.x == lastIndex.x && modifiedIndex.y == lastIndex.y)
        return false;
    
    NSMutableString *tagName = [NSMutableString stringWithFormat:@"(%f,%f)",modifiedIndex.x,modifiedIndex.y];
    return [self getChildByName:tagName recursively:NO];
}

// -----------------------------------------------------------------------

//returns zero in case of no valid point
-(CGPoint)checkBoundariesForIndex:(CGPoint)currentIndex
{
    NSInteger maxSteps = 30;
    NSInteger currentSteps = 0;
    
    CGPoint randomPoint1;
    CGPoint randomPoint2;
    CGPoint randomPoint3;
    CGPoint randomPoint4;
    NSMutableString *tagName1;
    NSMutableString *tagName2;
    NSMutableString *tagName3;
    NSMutableString *tagName4;
    NSInteger randomNr;
    
    randomPoint1 = ccpAdd(currentIndex,MOVE_LEFT);
    randomPoint2 = ccpAdd(currentIndex, MOVE_RIGHT);
    randomPoint3 = ccpAdd(currentIndex, MOVE_UP);
    randomPoint4 = ccpAdd(currentIndex, MOVE_DOWN);
    
    tagName1 = [NSMutableString stringWithFormat:@"(%f,%f)",randomPoint1.x,randomPoint1.y];
    tagName2 = [NSMutableString stringWithFormat:@"(%f,%f)",randomPoint2.x,randomPoint2.y];
    tagName3 = [NSMutableString stringWithFormat:@"(%f,%f)",randomPoint3.x,randomPoint3.y];
    tagName4 = [NSMutableString stringWithFormat:@"(%f,%f)",randomPoint4.x,randomPoint4.y];
    
    NSArray *possiblePoints = @[[NSValue valueWithCGPoint:randomPoint1],[NSValue valueWithCGPoint:randomPoint2],[NSValue valueWithCGPoint:randomPoint3],[NSValue valueWithCGPoint:randomPoint4]];
    
    NSArray *possiblePointNames =  @[tagName1,tagName2,tagName3,tagName4];
    
    CGPoint selectedPoint;
    NSMutableString *selectedName;
    
    do{
        randomNr = [self randomNumberBetween:0 maxNumber:3];
        selectedPoint = [possiblePoints[randomNr] CGPointValue];
        selectedName = possiblePointNames[randomNr];
        currentSteps++;
        
        if(currentSteps >= maxSteps){
            //no valid point found
            return CGPointZero;
        }
    }while([self getChildByName:selectedName recursively:NO] || selectedPoint.x  > columnCount-1 || selectedPoint.x < 0 || selectedPoint.y > rowCount-1 || selectedPoint.y < 0);
    
    CGPoint stepVec = ccpSub(selectedPoint,currentIndex);
    return stepVec;
}

// -----------------------------------------------------------------------


-(void)addFieldToIndex:(CGPoint)theIndex withType:(FieldType)theType
{
//    NSLog(@"currentFields count: %i",[currentFields count]); //uncomment to check how many fields produced by the algorithm
    
    Field *newField;
    newField= [[allPossibleFields objectAtIndex:theIndex.x]objectAtIndex:theIndex.y];
    [newField setFieldTypeTo:theType];
    NSMutableString *theName = [NSMutableString stringWithFormat:@"(%f,%f)",newField.boardIndex.x,newField.boardIndex.y];
    
    if(![self getChildByName:theName recursively:NO]){
        [self addChild:newField z:0 name:theName];
        [currentFields addObject:newField];
    }else{
        //set last field as finish field
        Field *theField = (Field*)[self getChildByName:theName recursively:NO];
        [theField setFieldTypeTo:Finish];
    }
    
    if([currentFields count] == 2){
        [self rotateStartField];
    }
}

// -----------------------------------------------------------------------


//rotate startfield triangle facing to its next field
-(void)rotateStartField{
    
    Field *startField = [currentFields objectAtIndex:0];
    Field *firstInbetweenField = [currentFields objectAtIndex:1];
    CGPoint direction = ccpSub(startField.boardIndex,firstInbetweenField.boardIndex);
    startField.anchorPoint = ccp(0.5,0.5);
    
    if(CGPointEqualToPoint(direction, MOVE_LEFT))
        startField.rotation = 0;
    
    if(CGPointEqualToPoint(direction, MOVE_RIGHT))
        startField.rotation = 180;
    
    if(CGPointEqualToPoint(direction, MOVE_UP))
        startField.rotation = 90;
    
    if(CGPointEqualToPoint(direction, MOVE_DOWN))
        startField.rotation = 270;
}

// -----------------------------------------------------------------------

-(void)restartRandomFieldCreation
{
    //remove all added field nodes from the board
    for (Field *currentField in currentFields){
        [self removeChild:currentField cleanup:YES];
    }
    
    //make sure to have a clean restart by initializing both arrays again
    currentFields = [[NSMutableArray alloc] init];
    [self initFieldArray];
    
    //start the algorithm again
    [self createRandomFieldsOnTheBoard];
}

// -----------------------------------------------------------------------
#pragma mark random and chance
// -----------------------------------------------------------------------
- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform(max - min + 1);
}

// -----------------------------------------------------------------------

-(bool)chance:(float)percent//returns true in addiction of given percent
{
    NSInteger random = rand ();
    bool chance = (random < (RAND_MAX * percent));
    return chance;
}
// -----------------------------------------------------------------------
#pragma mark token actions
// -----------------------------------------------------------------------
-(void)addTokenToBoard:(Token*)theToken
{
    Field *startField = [currentFields objectAtIndex:0];
    NSInteger startFieldRotationAngle = startField.rotation;
    NSInteger distance = fieldWidth/5;
    
    //get the right position for the token in relation to the token color and the angle of the start field
    switch (startFieldRotationAngle) {
        case 0:
            blueTokenPos = ccp(startField.position.x,startField.position.y - (distance*2));
            redTokenPos = ccp(startField.position.x,startField.position.y);
            break;
        case 90:
            blueTokenPos = ccp(startField.position.x - distance,startField.position.y - distance);
            redTokenPos = ccp(startField.position.x + distance,startField.position.y - distance);
            break;
        case 180:
            blueTokenPos = ccp(startField.position.x,startField.position.y - (distance*2));
            redTokenPos = ccp(startField.position.x,startField.position.y);
            break;
        case 270:
            blueTokenPos = ccp(startField.position.x - distance,startField.position.y - distance);
            redTokenPos = ccp(startField.position.x + distance,startField.position.y - distance);
            break;
        default:
            break;
    }
    
    theToken.anchorPoint = ccp(0.5,0.0);
    
    //token which belongs to the player added to the board as a CCNode to make it visible
    if(theToken.tokenColor == Red){
        theToken.position = redTokenPos;
        [self addChild:theToken z:1 name:@"Red"];
    }else if(theToken.tokenColor == Blue){
        theToken.position = blueTokenPos;
        [self addChild:theToken z:2 name:@"Blue"];
    }
}

// -----------------------------------------------------------------------

-(void)moveToken:(Token*)theToken withResult:(NSInteger)theDicingResult;
{
    NSInteger newFieldNr;
    Field *theField;
    CGPoint newPos;
    
    newFieldNr = theToken.currentFieldNr;
    
    theField = [currentFields objectAtIndex:newFieldNr];
    if(theField.fieldType == Jail && theDicingResult%2 > 0){
//        self.jailed = YES;
        currentBoardState = jailed;
        return;
    }
    
    if(newFieldNr+theDicingResult < [currentFields count]){
        //collect the positions for the single steps to reach target field
        for(int i = 0; i < theDicingResult; i++){
            newFieldNr += 1;
            theField = [currentFields objectAtIndex:newFieldNr];
            newPos = theField.position;
            [currentStepPositions addObject:[NSValue valueWithCGPoint:(newPos)]];
        }
       
        [self animateToken:theToken];
        theToken.currentFieldNr = newFieldNr;
        
        // game over check
        if(theToken.currentFieldNr == [currentFields count]-1){
//            self.gameOver = YES;
            currentBoardState = gameOver;
        }

    }else{
        //less fields to go than dice score
//        self.moveImpossible = YES;
        currentBoardState = moveImpossible;
    }
}

// -----------------------------------------------------------------------

//animates per step to single field while using recursion till the position array is empty
-(void)animateToken:(Token*)theToken
{
    aniReady = NO;
    
    if([currentStepPositions count] == 0){
        [self checkForSpecials:theToken];
        //No more steps left for this turn, turn animation done
        return;
    }
    
    NSValue *currentStepVal = [currentStepPositions objectAtIndex:0];
    
    CGPoint currentStepPos = [currentStepVal CGPointValue];
    [currentStepPositions removeObject:currentStepVal];
    
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:currentStepPos];
    CCActionDelay *actionDelay = [CCActionDelay actionWithDuration:0.3f];
    CCActionCallBlock *actionBlock = [CCActionCallBlock actionWithBlock:^{[self animateToken:theToken];}]; //recursion
    [theToken runAction:[CCActionSequence actions:actionMove,actionDelay,actionBlock, nil]];
}

// -----------------------------------------------------------------------

-(void)onTokenMoveFinished
{
    NSLog(@"");
    aniReady = YES;
}

// -----------------------------------------------------------------------
#pragma mark token special field animations
// -----------------------------------------------------------------------

-(void)checkForSpecials:(Token*)theToken
{
    Field *currentField = (Field*)[currentFields objectAtIndex:theToken.currentFieldNr];
    FieldType theFieldType = currentField.fieldType;
//    CCActionCallFunc *actionMoveDone;
    
    switch (theFieldType) {
        case Normal:
            //nothing special, just a normal field..
            [self onTokenMoveFinished];
            break;
        case Hole:
            //you dropped in a hole. you will be redirected to the start field
            [self performHoleAniWithToken:theToken];
            break;
        case Jail:
            //you are in jail! score must be even.
            [self onTokenMoveFinished];
            break;
        case Green:
            //green field: you can go three steps further
            [self performGreenSpecial:theToken];
            break;
        case Yellow:
            //yellow field: you get an animated instant win
            [self performYellowSpecial:theToken];
            break;
        default:
            //start or finish field
            [self onTokenMoveFinished];
            break;
    }
}

// -----------------------------------------------------------------------

-(void)performHoleAniWithToken:(Token*)theToken
{
    
    CGPoint startPos = theToken.tokenColor == Red ? redTokenPos : blueTokenPos;
    
    CCActionScaleTo *decrease =[CCActionScaleTo actionWithDuration:1.0f scale:0.0f];
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.5f];
    CCActionMoveTo *move = [CCActionMoveTo actionWithDuration:0.1 position:startPos];
    CCActionScaleTo *increase = [CCActionScaleTo actionWithDuration:1.0f scale:1.0f];
    CCActionCallBlock *block = [CCActionCallBlock actionWithBlock:^{[self onTokenMoveFinished];}];
    CCActionSequence *seq = [CCActionSequence actions:decrease,delay,move,increase,block,nil];
    [theToken runAction:seq];
    
    theToken.currentFieldNr = 0;
}

-(void)performGreenSpecial:(Token*)theToken
{
    CCActionBlink *blink = [CCActionBlink actionWithDuration:1.0f blinks:4];
    CCActionCallBlock *block = [CCActionCallBlock actionWithBlock:^{[self moveToken:theToken withResult:3];}];
    CCActionSequence *seq = [CCActionSequence actions:blink,block, nil];
    [theToken runAction:seq];
}

-(void)performYellowSpecial:(Token*)theToken
{
    Field *destinationField= [currentFields objectAtIndex:[currentFields count]-1];
    CGPoint destinationPos = destinationField.position;

    CCActionRotateBy *rotation = [CCActionRotateBy actionWithDuration:3.0f angle:2160];
    CCActionJumpTo *jump2 = [CCActionJumpTo actionWithDuration:3.0f position:destinationPos height:20.0f jumps:20];
    CCActionCallBlock *block = [CCActionCallBlock actionWithBlock:^{[self onTokenMoveFinished];currentBoardState = gameOver;/*self.gameOver = YES;*/}];
    CCActionSequence *seq = [CCActionSequence actions:rotation,jump2,block,nil];
    [theToken runAction:seq];
}
@end
