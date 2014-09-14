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
#import "World.h"
#import "Player.h"
#import "Ball.h"
#import "Goal.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@interface HelloWorldScene () {
    UIPanGestureRecognizer *panGestureRecognizer;
    World *world;
    Player *player;
    Player *enemy;
    Ball *ball;
    Goal *playerGoal;
    Goal *enemyGoal;
    CGPoint velocity;
}

@end

@implementation HelloWorldScene

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
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [[CCDirector sharedDirector].view addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.delegate = self;
    
    
    // Screen size for diffrent objects
    CGFloat width = self.contentSize.width, height = self.contentSize.height;
    
    // Create world
    __weak CCScene *weakSelf = self;
    world = [[World alloc] initWithScene:weakSelf];
    
    // Add the ball
    //ball = [[Ball alloc] initWithWidth:width height:height];
    ball = [[Ball alloc] initWithPosition:CGPointMake(width/2, height/2)];
    [world addChild:ball];
    
    // Add the players
    player = [[Player alloc] initWithPosition:CGPointMake(width/4, height/2)];
    [player addToWorld:world];
    enemy = [[Player alloc] initWithPosition:CGPointMake(width/4 * 3, height/2)];
    [enemy addToWorld:world];
    
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
    [[CCDirector sharedDirector].view removeGestureRecognizer:panGestureRecognizer];
}

// -----------------------------------------------------------------------
#pragma mark - Collision detection
// -----------------------------------------------------------------------

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)nodeA goal:(CCNode *)nodeB {
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

// Detect user flicks
-(void)didPan:(UIPanGestureRecognizer*)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateEnded:
            velocity = [recognizer velocityInView:[recognizer.view superview]];
            CGFloat angle = atan2f(velocity.y, velocity.x);
            NSLog(@"%f, %f, %f", velocity.x, velocity.y, angle);
            [player jumpVelocity:velocity];
        default:
            break;
    }
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    [[CCDirector sharedDirector].view removeGestureRecognizer:panGestureRecognizer];
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
