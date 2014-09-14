//
//  Goal.m
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Goal.h"

#define IMG_BLANK @"blank.png"

@implementation Goal

-(id)initWithScreenSize:(CGSize)size enemy:(BOOL)enemy {
    self = [super initWithImageNamed:IMG_BLANK];
    if (self) {
        // dimensions
        CGFloat x = 50, y = size.height/2 + x, originX, originY = size.height/3;
        self.enemyGoal = enemy;
        // determine where it should be created
        if (self.enemyGoal)
            originX = size.width;
        else
            originX = 0;
        
        self.scaleX = x;
        self.scaleY = y;
        self.position = ccp(originX, originY);
        self.color = [CCColor colorWithRed:0.8 green:0.4 blue:0.4];
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
        self.physicsBody.type = CCPhysicsBodyTypeStatic;
        // set collision type so it can react to collisions with ball
        self.physicsBody.collisionType = @"goal";
    }
    return self;
}

@end
