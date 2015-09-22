//
//  SelectionScene.h
//  patrico
//
//  Created by master on 27.10.14.
//  Copyright master 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameCenterController.h"

// -----------------------------------------------------------------------

//this scene implements the GameCenterControllerDelegate protocol
//to be able to be informed about important game center events
//and to handle the sent data from other clients corresponding to the actual match
@interface SelectionScene : CCScene <GameCenterControllerDelegate>

// -----------------------------------------------------------------------

+ (SelectionScene *)scene;
- (id)init;

#pragma mark delegate methods
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
// -----------------------------------------------------------------------
@end
