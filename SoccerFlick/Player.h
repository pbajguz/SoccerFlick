//
//  Player.h
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite { //NSObject {//
    
}

//@property (strong, nonatomic) CCSprite* sprite;

-(id)initWithPosition:(CGPoint)point color:(CCColor*)color;

-(id)initWithPosition:(CGPoint)point;

-(void)addToWorld:(CCPhysicsNode*)world;

-(void)initAI;

-(void)jumpVelocity:(CGPoint)velocity;

-(void)resetPosition;

@end
