//
//  HelloWorldScene.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_ball;
    CCPhysicsNode *_physicsWorld;
    CCSprite *_floor;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
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
    
    // Create a colored background (Green)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.8f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Create physics
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,-100);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // Add the ball
    _ball = [CCSprite spriteWithImageNamed:@"soccer_ball_1.png"];
    _ball.scale = 0.1;
    _ball.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _ball.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:_ball.contentSize.width/2 andCenter:ccp(_ball.contentSize.width/2, _ball.contentSize.height/2)];
    _ball.physicsBody.elasticity = 2;
    _ball.physicsBody.collisionType = @"ball";
    [_physicsWorld addChild:_ball];
    
    // Add the floor
    _floor = [CCSprite spriteWithImageNamed:@"blank.png"];
    _floor.scaleX = self.contentSize.width;
    _floor.scaleY = 50;
    _floor.position = ccp(self.contentSize.width/2, 0);
    _floor.color = [CCColor blueColor];
    _floor.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _floor.contentSize} cornerRadius:0];
    _floor.physicsBody.affectedByGravity = NO;
    _floor.physicsBody.mass = 1000000;
    _floor.physicsBody.collisionType = @"floor";
    [_physicsWorld addChild:_floor];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)nodeA floor:(CCNode *)nodeB {
    NSLog(@"Objects touched!");
    return TRUE;
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
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    [_ball runAction:actionMove];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
