//
//  SelectionScene.m
//  patrico
//
//  Created by master on 27.10.14.
//  Copyright master 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "SelectionScene.h"
#import "GameScene.h"
#import "GameCenterController.h"

// -----------------------------------------------------------------------
#pragma mark - SelectionScene
// -----------------------------------------------------------------------

@implementation SelectionScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (SelectionScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (blue)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.4f blue:0.6f alpha:1.0f]];
    [self addChild:background];
    
    //Logo
    CCSprite *logo = [CCSprite spriteWithImageNamed:@"logo2.png"];
    logo.positionType = CCPositionTypeNormalized;
    logo.position = ccp(0.5f,0.6f);
    [self addChild:logo];
    
    //play mode label
    CCSprite *playModeLabel = [CCSprite spriteWithImageNamed:@"playMode.png"];
    playModeLabel.positionType = CCPositionTypeNormalized;
    playModeLabel.position = ccp(0.5f,0.3f);
    [self addChild:playModeLabel];
    
    // single player button
    CCSpriteFrame *singleButtonFrame = [CCSpriteFrame frameWithImageNamed: @"buttonSinglePlayer.png"];
    CCButton *singleButton = [CCButton buttonWithTitle:@"" spriteFrame:singleButtonFrame]; //fontName:@"Verdana-Bold" fontSize:18.0f];
    [singleButton setBackgroundOpacity:1.0f forState:CCControlStateHighlighted];
    singleButton.positionType = CCPositionTypeNormalized;
    singleButton.position = ccp(0.35f, 0.2f);
    [singleButton setTarget:self selector:@selector(onSingleClicked:)];
    [self addChild:singleButton];
    
    // multi player button
    CCSpriteFrame *multiButtonFrame = [CCSpriteFrame frameWithImageNamed: @"buttonMultiPlayer.png"];
    CCButton *multiButton = [CCButton buttonWithTitle:@"" spriteFrame:multiButtonFrame]; //fontName:@"Verdana-Bold" fontSize:18.0f];
    multiButton.positionType = CCPositionTypeNormalized;
    multiButton.position = ccp(0.65f, 0.2f);
    [multiButton setTarget:self selector:@selector(onMultiClicked:)];
    [self addChild:multiButton];

    // done
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSingleClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5]];
}

- (void)onMultiClicked:(id)sender
{
    if(![GKLocalPlayer localPlayer].isAuthenticated && [GameCenterController sharedGameCenterController].authenticationViewController){
        [[CCDirector sharedDirector] presentModalViewController:[GameCenterController sharedGameCenterController].authenticationViewController animated:YES];
    }
    
    [[GameCenterController sharedGameCenterController] findMatchWithMinPlayers:2 maxPlayers:2 viewController:[CCDirector sharedDirector] delegate:self];
}

// -----------------------------------------------------------------------
#pragma mark delegate methods
// -----------------------------------------------------------------------
- (void)matchStarted
{
    NSLog(@"matchStarted (SelectionScene)");
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.3f]];
}
- (void)matchEnded
{
    NSLog(@"matchEnded (SelectionScene)");
}
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    NSLog(@"match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID (SelectionScene)");
}
- (void)inviteReceived
{
    NSLog(@"inviteReceived (SelectionScene)");
}


@end


