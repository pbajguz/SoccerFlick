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
    BOOL gamePaused;
    CCButton *continueButton;
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
    ball = [[Ball alloc] initWithPosition:ccp(width/2, height/2)];
    [world addChild:ball];
    
    // Add the players
    player = [[Player alloc] initWithPosition:ccp(width/4, height/3) color:[CCColor blueColor]];
    [player addToWorld:world];
    enemy = [[Player alloc] initWithPosition:ccp(width/4 * 3, height/3) color:[CCColor redColor]];
    [enemy addToWorld:world];
    [enemy initAI];
    
    // Add the goals
    playerGoal = [[Goal alloc] initWithScreenSize:CGSizeMake(width, height) enemy:NO];
    enemyGoal = [[Goal alloc] initWithScreenSize:CGSizeMake(width, height) enemy:YES];
    [world addChild:playerGoal];
    [world addChild:enemyGoal];
    
    gamePaused = NO;
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    // Create continue button for when somene score
    continueButton = [CCButton buttonWithTitle:@"[ Continue ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    [continueButton setColor:[CCColor colorWithRed:0.8 green:0.6 blue:0.2]];
    continueButton.positionType = CCPositionTypeNormalized;
    continueButton.position = ccp(0.5f, 0.5f); // Middle
    [continueButton setTarget:self selector:@selector(onContinueClicked:)];
    continueButton.visible = NO;
    [self addChild:continueButton];

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

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)ball goal:(Goal *)goal {
    if (!gamePaused) {
        gamePaused = YES;
        continueButton.visible = YES;
        [world addScore:goal.enemyGoal];
    }
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
#pragma mark - User interactions
// -----------------------------------------------------------------------

// Detect user flicks
-(void)didPan:(UIPanGestureRecognizer*)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateEnded:
            velocity = [recognizer velocityInView:[recognizer.view superview]];
            [player jumpVelocity:velocity];
        default:
            break;
    }
}

// shake action
-(void)shakeAction {
    NSLog(@"Shaking!");
    [world toggleGravity];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onBackClicked:(id)sender {
    // Prepare for leaving the scene
    [enemy disableAI];
    [[CCDirector sharedDirector].view removeGestureRecognizer:panGestureRecognizer];
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

-(void)onContinueClicked:(id)sender {
    // If someone scored recently allow to resume play
    if (gamePaused) {
        gamePaused = NO;
        continueButton.visible = NO;
        [player resetPosition];
        [enemy resetPosition];
        [ball resetPosition];
    }
}

// -----------------------------------------------------------------------
@end


// Recognizer for shaking events
@implementation CCDirector (Shake)

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Shake detected");
        if ([self.runningScene isKindOfClass:[HelloWorldScene class]]) {
            [(HelloWorldScene*)self.runningScene shakeAction];
        }
//        if ([self.runningScene respondsToSelector:@selector(shakeAction)]) {
//            [(HelloWorldScene*)self.runningScene shakeAction];
//        }
    }
}

@end
