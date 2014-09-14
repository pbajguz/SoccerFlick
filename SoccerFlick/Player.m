//
//  Player.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#define MAX_FLICK_SPEED 200
#define CONST_FLICK_SPEED_REDUCE 10
#define IMG_TORSO @"torso.png"
#define IMG_TORSO_SCALE 0.5
#define IMG_LIMB @"limb.png"
#define IMG_LIMB_SCALE 0.2

@interface Player () {
    CCSprite *legLeft;
    CCSprite *legRight;
    CCSprite *handLeft;
    CCSprite *handRight;
    // limb starting positions
    CGPoint lL;
    CGPoint lR;
    CGPoint hL;
    CGPoint hR;
    NSString *collisionGroup;
    // saved position for restarting player position
    CGPoint startPosition;
    NSTimer *aiTimer;
}

@end

@implementation Player

-(id)initWithPosition:(CGPoint)point color:(CCColor*)color {
    self = [self initWithPosition:point];
    self.color = legLeft.color = legRight.color = handLeft.color = handRight.color = color;
    return self;
}

-(id)initWithPosition:(CGPoint)point {
    self = [super initWithImageNamed:IMG_TORSO];
    if (self) {
        // Create collision group name to apply it to every limb so they can clip
        collisionGroup = [NSString stringWithFormat:@"%f,%f", point.x, point.y];
        self.scale = IMG_TORSO_SCALE;
        self.position = point;
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.collisionGroup = collisionGroup;
        
        // Init limbs
        lL = ccp(point.x-self.contentSize.width/4, point.y-self.contentSize.height/3);
        lR = ccp(point.x+self.contentSize.width/4, point.y-self.contentSize.height/3);
        hL = ccp(point.x-self.contentSize.width/4, point.y-self.contentSize.height/8);
        hR = ccp(point.x+self.contentSize.width/4, point.y-self.contentSize.height/8);
        legLeft = [self createLimb:lL];
        legRight = [self createLimb:lR];
        handLeft = [self createLimb:hL];
        handRight = [self createLimb:hR];
        
        // save starting position
        startPosition = point;
    }
    return self;
}

// add all player elements to specified world
-(void)addToWorld:(CCPhysicsNode*)world {
    [world addChild:self];
    [world addChild:legRight];
    [world addChild:legLeft];
    [world addChild:handRight];
    [world addChild:handLeft];
}

// create limb at specified position
-(CCSprite*)createLimb:(CGPoint)position {
    CCSprite *limb = [CCSprite spriteWithImageNamed:IMG_LIMB];
    limb.scale = IMG_LIMB_SCALE;
    limb.position = position;
    limb.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    limb.physicsBody.collisionGroup = collisionGroup;
    limb.physicsBody.mass = 0.1;
    // attach limb to main body with pivot and limit it's rotation
    [CCPhysicsJoint connectedPivotJointWithBodyA:limb.physicsBody bodyB:self.physicsBody anchorA:ccp(limb.contentSize.width, limb.contentSize.height)];
    [CCPhysicsJoint connectedRotaryLimitJointWithBodyA:limb.physicsBody bodyB:self.physicsBody min:-0.5f max:0.5f];
    return limb;
}

// Start timer, every time it fires ai will do something
-(void)initAI {
    aiTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(aiAction:) userInfo:nil repeats:YES];
}

// AI will perform random movement
-(void)aiAction:(NSTimer*)timer {
    const int playerMaxFlick = MAX_FLICK_SPEED * 10;
    [self jumpVelocity:ccp(playerMaxFlick - ( arc4random() % (playerMaxFlick*2) ), playerMaxFlick - arc4random() % (playerMaxFlick*2) )];
}

// Makes player jump with certain angle and speed
-(void)jumpVelocity:(CGPoint)velocity {
    CGPoint flick = velocity;
    // Change y to -y, because height is calculated from the bottom of screen
    flick.y = -flick.y;
    // Cut by constant to reduce speed
    flick.x /= CONST_FLICK_SPEED_REDUCE;
    flick.y /= CONST_FLICK_SPEED_REDUCE;
    // limit flick speed to MAX_FLICK_SPEED
    if (flick.x > MAX_FLICK_SPEED) flick.x = MAX_FLICK_SPEED;
    else if (flick.x < -MAX_FLICK_SPEED) flick.x = -MAX_FLICK_SPEED;
    if (flick.y > MAX_FLICK_SPEED) flick.y = MAX_FLICK_SPEED;
    else if (flick.y < -MAX_FLICK_SPEED) flick.y = -MAX_FLICK_SPEED;
    [self.physicsBody applyImpulse:flick];
}

// resets player position
-(void)resetPosition {
    // If the AI timer is running, stop it and resume after the reset
    BOOL isAI = NO;
    if ([aiTimer isValid]) {
        [aiTimer invalidate];
        isAI = YES;
    }
    [self resetPositionOfObject:self position:startPosition];
    [self resetPositionOfObject:handLeft position:hL];
    [self resetPositionOfObject:handRight position:hR];
    [self resetPositionOfObject:legLeft position:lL];
    [self resetPositionOfObject:legRight position:lR];
    
    if (isAI) {
        [self initAI];
    }
}

-(void)resetPositionOfObject:(CCNode*)object position:(CGPoint)position {
    object.position = position;
    object.rotation = 0;
    object.physicsBody.angularVelocity = 0;
    object.physicsBody.velocity = CGPointZero;
}

-(void)disableAI {
    if ([aiTimer isValid]) {
        [aiTimer invalidate];
    }
}

@end
