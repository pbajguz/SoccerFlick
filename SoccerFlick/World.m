//
//  World.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "World.h"

@interface World () {
    CCScene *canvas;
    CCNode *floor;
}

@end

@implementation World

-(id)initWithScene:(CCScene*)scene {
    self = [super init];
    if (self) {
        canvas = scene;
        
        // Create background
        CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.4f green:0.4f blue:0.8f]];
        [canvas addChild:background];
        
        // Create physics
        self.gravity = ccp(0, -100);
        self.debugDraw = YES;
        self.collisionDelegate = (NSObject<CCPhysicsCollisionDelegate>*)canvas;
        self.iterations = 2;
        [canvas addChild:self];
        
        // Create ground to play on
        floor = [CCSprite spriteWithImageNamed:@"blank.png"];
        floor.scaleX = canvas.contentSize.width;
        floor.scaleY = 50;
        floor.position = ccp(canvas.contentSize.width/2, 0);
        floor.color = [CCColor colorWithRed:0.2 green:0.8 blue:0.2];
        floor.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, floor.contentSize} cornerRadius:0];
        //floor.physicsBody.affectedByGravity = NO;
        //floor.physicsBody.mass = 1000000;
        floor.physicsBody.type = CCPhysicsBodyTypeStatic;
        [self addChild:floor];
    }
    return self;
}



@end
