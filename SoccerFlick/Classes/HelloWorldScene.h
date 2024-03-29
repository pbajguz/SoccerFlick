//
//  HelloWorldScene.h
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene <CCPhysicsCollisionDelegate, UIGestureRecognizerDelegate>

// -----------------------------------------------------------------------

@property (assign, nonatomic) BOOL shake;

+ (HelloWorldScene *)scene;
- (id)init;
- (void)shakeAction;

// -----------------------------------------------------------------------
@end