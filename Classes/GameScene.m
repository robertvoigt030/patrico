//
// GameScene.m
//  patrico
//
//  Created by master on 27.10.14.
//  Copyright master 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "GameScene.h"
#import "SelectionScene.h"
#import "Board.h"
#import "Dice.h"
#import "Player.h"

// -----------------------------------------------------------------------
#pragma mark - GameScene
// -----------------------------------------------------------------------

Board *thePlayground;
Dice *theDice;
Player *player1;
Player *player2;

CCLabelTTF *labelPlayer1;
CCLabelTTF *labelPlayer2;

CCSprite *info;
CCLabelTTF *infoText;
NSInteger diceResult;
bool cpuTurn;
bool blinkAni;

@implementation GameScene
{
    CCSprite *_sprite;
}

// -----------------------------------------------------------------------
#pragma mark - Initialization
// -----------------------------------------------------------------------

+ (GameScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.4f blue:0.6f alpha:1.0f]];
    [self addChild:background];

    [self initUI];
    [self initPlayers];
    [self initPlayground];
    [self addToken];
    
    // done
	return self;
}

// -----------------------------------------------------------------------

-(void)initUI
{
    // Create a back button
    CCSpriteFrame *backButtonFrame = [CCSpriteFrame frameWithImageNamed: @"buttonBack.png"];
    CCButton *backButton = [CCButton buttonWithTitle:@"" spriteFrame:backButtonFrame];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.065f, 0.93f); // top left corner of the screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    //create versus label
    CCSpriteFrame *versusButtonFrame = [CCSpriteFrame frameWithImageNamed: @"versus.png"];
    CCButton *versusButton = [CCButton buttonWithTitle:@"" spriteFrame:versusButtonFrame];
    versusButton.positionType = CCPositionTypeNormalized;
    versusButton.position = ccp(0.5f, 0.95f);
    [self addChild:versusButton];
    
    //create logo
    CCSpriteFrame *logoButtonFrame = [CCSpriteFrame frameWithImageNamed: @"logo3.png"];
    CCButton *logoButton = [CCButton buttonWithTitle:@"" spriteFrame:logoButtonFrame];
    logoButton.positionType = CCPositionTypeNormalized;
    logoButton.position = ccp(0.11f, 0.1f);
    [self addChild:logoButton];
    
    //create textbox
    CCSpriteFrame *textboxFrame = [CCSpriteFrame frameWithImageNamed: @"windowStatus.png"];
    CCButton *textbox = [CCButton buttonWithTitle:@"" spriteFrame:textboxFrame];
    textbox.positionType = CCPositionTypeNormalized;
    textbox.position = ccp(0.5f, 0.1f);
    [self addChild:textbox];
    
    //label for textbox
    
    //create dice button
    CCSpriteFrame *diceButtonFrame = [CCSpriteFrame frameWithImageNamed: @"buttonDices.png"];
    CCButton *diceButton = [CCButton buttonWithTitle:@"" spriteFrame:diceButtonFrame];
    diceButton.positionType = CCPositionTypeNormalized;
    diceButton.position = ccp(0.92f, 0.1f); // bottom right corner of screen
    [diceButton setTarget:self selector:@selector(onDiceClicked:)];
    [self addChild:diceButton];
    
    //create infoWindow
    info = [CCSprite spriteWithImageNamed:@"infoWindow.png"];
    [self addChild:info z:35];
    info.positionType = CCPositionTypeNormalized;
    info.position = ccp(0.5f, 0.5f);
    info.visible = NO;
    
    //dice img
    CCSprite *img = [CCSprite spriteWithSpriteFrame:diceButtonFrame];
    [info addChild:img];
    img.positionType = CCPositionTypeNormalized;
    img.position = ccp(0.15f,0.5f);
    
    //okay button
    CCSpriteFrame *genericButtonFrame = [CCSpriteFrame frameWithImageNamed:@"genericButton.png"];
    CCButton *okButton = [CCButton buttonWithTitle:@"" spriteFrame:genericButtonFrame];
    [okButton setTarget:self selector:@selector(onOkClicked:)];
    [info addChild:okButton];
    okButton.positionType = CCPositionTypeNormalized;
    okButton.position = ccp(0.85f,0.15f);
    okButton.scale = 1.3;
    [okButton.label setColor:[CCColor blackColor]];
    
    CCLabelTTF *btnText = [CCLabelTTF labelWithString:@"OKAY" fontName:@"Verdana-Bold" fontSize:15.0f];
    [okButton addChild:btnText];
    btnText.positionType = CCPositionTypeNormalized;
    btnText.position = ccp(0.5,0.5f);
    [btnText setColor:[CCColor blackColor]];
    
    //Label for infoWindow
    infoText = [CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:20.0f dimensions:CGSizeMake(info.boundingBox.size.width*0.65f , info.boundingBox.size.height*0.6f)];
    [info addChild:infoText z:100000];
    infoText.positionType = CCPositionTypeNormalized;
    infoText.anchorPoint = ccp(0.0f,0.5f);
    infoText.position = ccp(0.3,0.5f);
    [infoText setColor:[CCColor blackColor]];
}

// -----------------------------------------------------------------------

-(void)initPlayground
{
    NSLog(@"initPlayground...");
    thePlayground = [[Board alloc] init];
    thePlayground.positionType = CCPositionTypeNormalized;
    thePlayground.position = ccp(0.5,0.53);
    [self addChild:thePlayground];
    [self addToken];
    theDice = [[Dice alloc]init];
}

// -----------------------------------------------------------------------

-(void)initPlayers
{
    player1 = [[Player alloc]init];
    if([GKLocalPlayer localPlayer].alias){
        player1.playerID = [GKLocalPlayer localPlayer].alias;
    }else{
    	player1.playerID = @"Spieler 1";
    }
    
    player2 = [[Player alloc]init];
    player2.playerID = @"Der Computergegner";
    
    NSLog(@"initPlayers okay");
    
    [self initPlayerNames];
}

// -----------------------------------------------------------------------

-(void) initPlayerNames
{
    labelPlayer1 = [CCLabelTTF labelWithString:player1.playerID fontName:@"Verdana-Bold" fontSize:30.0f];
    labelPlayer1.anchorPoint = ccp(1.0,0.5);
    labelPlayer1.positionType = CCPositionTypeNormalized;
    labelPlayer1.position = ccp(0.45,0.95);
    [self addChild:labelPlayer1];
    
    labelPlayer2 = [CCLabelTTF labelWithString:player2.playerID fontName:@"Verdana-Bold" fontSize:30.0f];
    labelPlayer2.anchorPoint = ccp(0.0,0.5);
    labelPlayer2.positionType = CCPositionTypeNormalized;
    labelPlayer2.position = ccp(0.55,0.95);
    [self addChild:labelPlayer2];
    
    
    blinkAni = YES;
     NSLog(@"initPlayerNames okay");
}

// -----------------------------------------------------------------------

-(void)addToken
{
    bool alreadyAddedBlue = [thePlayground getChildByName:@"Blue" recursively:NO];
    bool alreadyAddedRed = [thePlayground getChildByName:@"Red" recursively:NO];
    
    if(alreadyAddedBlue || alreadyAddedRed){
        NSLog(@"token already added...");
        return;
    }
    
    [thePlayground addTokenToBoard:[[Token alloc]initWithColor:Blue]];
    [thePlayground addTokenToBoard:[[Token alloc]initWithColor:Red]];
}

// -----------------------------------------------------------------------
#pragma mark - turn management
// -----------------------------------------------------------------------

-(void)whoBegins
{
    diceResult = -1;
    NSInteger resultPlayer1 = theDice.throwDice;
    NSInteger resultPlayer2 = theDice.throwDice;
    
    if(resultPlayer1 == resultPlayer2){
        [self whoBegins];
        return;
    }
    
    if(resultPlayer1 > resultPlayer2){
        player1.myToken = (Token*)[thePlayground getChildByName:@"Blue" recursively:NO];
        player1.myToken.currentFieldNr = 0;
        player2.myToken = (Token*)[thePlayground getChildByName:@"Red" recursively:NO];
        player2.myToken.currentFieldNr = 0;
        
        labelPlayer1.color = [CCColor blueColor];
        labelPlayer2.color = [CCColor redColor];
        
    }else{
        player1.myToken = (Token*)[thePlayground getChildByName:@"Red" recursively:NO];
        player1.myToken.currentFieldNr = 0;
        player2.myToken = (Token*)[thePlayground getChildByName:@"Blue" recursively:NO];
        player2.myToken.currentFieldNr = 0;
        
        labelPlayer1.color = [CCColor redColor];
        labelPlayer2.color = [CCColor blueColor];
    }
    
    infoText.string = [NSString stringWithFormat:@"Wer fängt an? Du hast eine %ld gewürfelt. Dein Gegner hat eine %ld gewürfelt. Die höhere Zahl beginnt das Spiel mit der blauen Figur.",(long)resultPlayer1,(long)resultPlayer2];
    
    info.visible = YES;
}

// -----------------------------------------------------------------------

-(void)changeTurn
{
    if(player2.myTurn){
        cpuTurn = NO;
    }
    
    if(diceResult == 6)
        return;
    
    player1.myTurn = !player1.myTurn;
    player2.myTurn = !player2.myTurn;
}

// -----------------------------------------------------------------------
#pragma mark helpers
// -----------------------------------------------------------------------

-(void)showMessageOnInfo:(NSString*)theMessage
{
    infoText.string = theMessage;
    info.visible = YES;
}

//- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
//{
//    return min + arc4random_uniform(max - min + 1);
//}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onDiceClicked:(id)sender
{
    if(!thePlayground.aniReady || info.visible){
        return;
    }
    
    if(!player1.myTurn && !player2.myTurn){
        [self whoBegins];
        return;
    }
    
    diceResult = theDice.throwDice;
    NSString *currentPlayerID = player1.myTurn ? player1.playerID : player2.playerID;
    NSString *resultMsg = [NSString stringWithFormat:@"%@ würfelt eine %ld!",currentPlayerID,(long)diceResult];
    
    [self showMessageOnInfo:resultMsg];
}

// -----------------------------------------------------------------------

- (void)onOkClicked:(id)sender
{
    info.visible = NO;
    
    switch (thePlayground.currentBoardState) {
        case gameOver:
            [[CCDirector sharedDirector] replaceScene:[SelectionScene scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:0.3f]];
            break;
        case moveImpossible:
            thePlayground.currentBoardState = nothing;
            return;
            break;
        case jailed:
            thePlayground.currentBoardState = nothing;
            break;
        default:
            break;
    }

    if(diceResult > -1){
        if(player1.myTurn){
            [thePlayground moveToken:player1.myToken withResult:diceResult];
        }else if(player2.myTurn){
            [thePlayground moveToken:player2.myToken withResult:diceResult];
        }
    }else{
        if(player1.myToken.tokenColor == Blue){
            NSLog(@"Player 1 takes Blue");
            player1.myTurn = YES;
        }else if(player2.myToken.tokenColor == Blue){
            player2.myTurn = YES;
            NSLog(@"Player 1 takes Blue");
        }
        
        blinkAni = NO;
        
        return;
    }
    
    [self changeTurn];
}

// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[SelectionScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5]];
}

// -----------------------------------------------------------------------
#pragma mark - Update method
// -----------------------------------------------------------------------

//cocos2D update method is called once per frame and is used instead nstimer or dispatcher to manage time critical purposes
- (void)update:(CCTime)delta {
    
    if(!blinkAni && thePlayground.aniReady){
        blinkAni = YES;
        CCActionBlink *blink = [CCActionBlink actionWithDuration:1 blinks:1];
        CCActionCallBlock *block = [CCActionCallBlock actionWithBlock:^{blinkAni=NO;}];
        CCActionSequence *seq = [CCActionSequence actions:blink,block,nil];
        [player1.myTurn ? labelPlayer1 : labelPlayer2 runAction:seq];
    }
    
    if(!thePlayground.aniReady || info.visible)
        return;
    
    NSString *message;
    
    switch (thePlayground.currentBoardState) {
        case jailed:
            message = @"Man braucht ein gerades Würfelergebnis um aus dem Gefängins frei zu kommen.";
            break;
        case gameOver:
            message = [NSString stringWithFormat:@"%@ hat gewonnen! Noch einmal?",player2.myTurn ? player1.playerID : player2.playerID];
            break;
        case moveImpossible:
            message = @"Augenzahl zu hoch, die Spielfigur wird nicht bewegt!";
            break;
        default:
            message = nil;
            break;
    }
    
    if(message)
        [self showMessageOnInfo: message];

    
    if(player2.myTurn && !cpuTurn){
        cpuTurn = YES;
        NSLog(@"Now CPU turn");
        [self onDiceClicked:nil];
    }
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
    thePlayground = nil;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}


// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

}

@end
