//
//  Ball.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"

#define IMG_BALL @"soccer_ball_1.png"
#define IMG_BALL_SCALE 0.1
#define CONST_ELASTICITY 3

@interface Ball () {
    CGPoint startPosition;
}

@end

@implementation Ball

-(id)initWithPosition:(CGPoint)point{
    self = [super initWithImageNamed:IMG_BALL];
    if (self) {
        self.scale = IMG_BALL_SCALE;
        self.position = point;
        self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.width/2 andCenter:ccp(self.contentSize.width/2, self.contentSize.height/2)];
        self.physicsBody.elasticity = CONST_ELASTICITY;
        // setting collision type so it can be later interpreted with goal to check for scoring
        self.physicsBody.collisionType = @"ball";
        startPosition = point;
    }
    return self;
}

-(void)resetPosition {
    self.position = startPosition;
    self.rotation = 0;
    self.physicsBody.angularVelocity = 0;
    self.physicsBody.velocity = CGPointZero;
}



@end
