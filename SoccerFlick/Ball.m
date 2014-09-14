//
//  Ball.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"

@interface Ball () {
    CGPoint startPosition;
}

@end

@implementation Ball

-(id)initWithPosition:(CGPoint)point{
    self = [super initWithImageNamed:@"soccer_ball_1.png"];
    if (self) {
        self.scale = 0.1;
        self.position = point;
        self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.width/2 andCenter:ccp(self.contentSize.width/2, self.contentSize.height/2)];
        self.physicsBody.elasticity = 5;
        self.physicsBody.collisionType = @"ball";
        startPosition = point;
    }
    return self;
}

-(void)resetPosition {
    self.position = startPosition;
}



@end
