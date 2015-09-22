//
//  GameCenterController.m
//  patrico
//
//  Created by master on 17.03.15.
//  Copyright (c) 2015 master. All rights reserved.
//
#import "cocos2d.h"
#import "GameCenterController.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const LocalPlayerIsAuthenticated = @"local_player_authenticated";

@implementation GameCenterController{
    BOOL _enableGameCenter;
    BOOL _matchStarted;
}

// -----------------------------------------------------------------------
#pragma mark Initialization
// -----------------------------------------------------------------------

//Singleton pattern - shared object
+ (instancetype)sharedGameCenterController
{
    static GameCenterController *sharedGameCenterController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameCenterController = [[GameCenterController alloc] init];
    });
    return sharedGameCenterController;
}

// -----------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

// -----------------------------------------------------------------------
#pragma mark public methods
// -----------------------------------------------------------------------

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        [self setLastError:error];
        if(viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
        } else {
            _enableGameCenter = NO;
        }
    };
}

// -----------------------------------------------------------------------

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GameCenterControllerDelegate>)delegate {
    
    if (!_enableGameCenter) return;
    
    if([GKLocalPlayer localPlayer].isAuthenticated){
        NSLog(@"the local player: %@ ",[GKLocalPlayer localPlayer]);
    }

    _matchStarted = NO;
    self.match = nil;
    _delegate = delegate;
    [viewController dismissViewControllerAnimated:NO completion:nil];
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController *mmvc =
    [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
}

// -----------------------------------------------------------------------
#pragma mark private methods
// -----------------------------------------------------------------------

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}

// -----------------------------------------------------------------------

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameCenterController ERROR: %@",
              [[_lastError userInfo] description]);
    }
}

// -----------------------------------------------------------------------
#pragma mark GKMatchmakerViewControllerDelegate
// -----------------------------------------------------------------------

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
     NSLog(@"The user has cancelled matchmaking: ");
}

// -----------------------------------------------------------------------

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

// -----------------------------------------------------------------------

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match {
    NSLog(@"did find match!");

    [viewController dismissViewControllerAnimated:YES completion:nil];
    self.match = match;
    match.delegate = self;
    if (!_matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
    }
}

// -----------------------------------------------------------------------

- (void)matchmakerViewController:(GKMatchmakerViewController*)viewController hostedPlayerDidAccept:(GKPlayer *)player
{
    NSLog(@"- (void)matchmakerViewController:(GKMatchmakerViewController*)viewController hostedPlayerDidAccept:(GKPlayer *)player");
}

// -----------------------------------------------------------------------
#pragma mark GKMatchDelegate
// -----------------------------------------------------------------------

// The match received data sent from the player.
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    if (_match != match) return;
    
    [_delegate match:match didReceiveData:data fromPlayer:playerID];
}

// -----------------------------------------------------------------------

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    if (_match != match) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!_matchStarted && match.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
            }
            
            break;
        case GKPlayerStateDisconnected:
            // a player just disconnected.
            NSLog(@"Player disconnected!");
            _matchStarted = NO;
            [_delegate matchEnded];
            break;
            
        case GKPlayerStateUnknown:
            //player state unknown
            NSLog(@"player state unknown!");
            break;
    }
}

// -----------------------------------------------------------------------

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (_match != match) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    _matchStarted = NO;
    [_delegate matchEnded];
}

// -----------------------------------------------------------------------

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error {
    
    if (_match != match) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    _matchStarted = NO;
    [_delegate matchEnded];
}

// -----------------------------------------------------------------------

@end

