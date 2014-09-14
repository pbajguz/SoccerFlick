//
//  Player.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#define MAX_FLICK_SPEED 200

@interface Player () {
    CCSprite *legLeft;
    CCSprite *legRight;
    CCSprite *handLeft;
    CCSprite *handRight;
    NSString *collisionGroup;
    CGPoint startPosition;
    NSTimer *aiTimer;
}

@end

@implementation Player

//@synthesize sprite;

-(id)initWithPosition:(CGPoint)point {
    self = [super initWithImageNamed:@"torso.png"];
    if (self) {
        collisionGroup = [NSString stringWithFormat:@"%f,%f", point.x, point.y];
        self.scale = 0.5;
        self.position = point;
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.collisionGroup = collisionGroup;
        
        // Init limbs
        legLeft = [self createLimb:ccp(point.x-self.contentSize.width/4, point.y-self.contentSize.height/3)];
        legRight = [self createLimb:ccp(point.x+self.contentSize.width/4, point.y-self.contentSize.height/3)];
        handLeft = [self createLimb:ccp(point.x-self.contentSize.width/4, point.y-self.contentSize.height/8)];
        handRight = [self createLimb:ccp(point.x+self.contentSize.width/4, point.y-self.contentSize.height/8)];
        
        startPosition = point;
    }
    return self;
}

-(void)addToWorld:(CCPhysicsNode*)world {
    [world addChild:self];
    [world addChild:legRight];
    [world addChild:legLeft];
    [world addChild:handRight];
    [world addChild:handLeft];
}

-(CCSprite*)createLimb:(CGPoint)position {
    CCSprite *limb = [CCSprite spriteWithImageNamed:@"limb.png"];
    limb.scale = 0.2;
    limb.position = position;
    limb.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    limb.physicsBody.collisionGroup = collisionGroup;
    limb.physicsBody.mass = 0.1;
    [CCPhysicsJoint connectedPivotJointWithBodyA:limb.physicsBody bodyB:self.physicsBody anchorA:ccp(limb.contentSize.width, limb.contentSize.height)];
    [CCPhysicsJoint connectedRotaryLimitJointWithBodyA:limb.physicsBody bodyB:self.physicsBody min:-0.5f max:0.5f];
    return limb;
}

-(void)initAI {
    aiTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(aiAction:) userInfo:nil repeats:YES];
}

-(void)aiAction:(NSTimer*)timer {
    const int playerMaxFlick = MAX_FLICK_SPEED * 10;
    [self jumpVelocity:ccp(playerMaxFlick - ( arc4random() % (playerMaxFlick*2) ), playerMaxFlick - arc4random() % (playerMaxFlick*2) )];
}

-(void)jumpVelocity:(CGPoint)velocity {
    CGPoint flick = velocity;
    flick.y = -flick.y;
    flick.x /= 10;
    flick.y /= 10;
    if (flick.x > MAX_FLICK_SPEED) flick.x = MAX_FLICK_SPEED;
    else if (flick.x < -MAX_FLICK_SPEED) flick.x = -MAX_FLICK_SPEED;
    if (flick.y > MAX_FLICK_SPEED) flick.y = MAX_FLICK_SPEED;
    else if (flick.y < -MAX_FLICK_SPEED) flick.y = -MAX_FLICK_SPEED;
    [self.physicsBody applyImpulse:flick];
}

-(void)resetPosition {
    self.position = startPosition;
    self.rotation = 0;
}

@end
