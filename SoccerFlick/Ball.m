//
//  Ball.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"



@implementation Ball

-(id)initWithPosition:(CGPoint)point{
    self = [super init];
    if (self) {
        self = [CCSprite spriteWithImageNamed:@"soccer_ball_1.png"];
        self.scale = 0.1;
        self.position = point;
        self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.width/2 andCenter:ccp(self.contentSize.width/2, self.contentSize.height/2)];
        self.physicsBody.elasticity = 2;
        self.physicsBody.collisionType = @"ball";
    }
    return self;
}





@end
