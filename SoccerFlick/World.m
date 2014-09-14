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
    CCLabelTTF *scoreLabel;
    int scorePlayer;
    int scoreEnemy;
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
        //self.debugDraw = YES;
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
        floor.physicsBody.type = CCPhysicsBodyTypeStatic;
        [self addChild:floor];
        
        // Create bounding box around the world so nothing will escape
        [self addChild:[self createInvisibleWall:CGRectMake(canvas.contentSize.width/2, canvas.contentSize.height, canvas.contentSize.width, 1)]];
        [self addChild:[self createInvisibleWall:CGRectMake(0, canvas.contentSize.height/2, 1, canvas.contentSize.height)]];
        [self addChild:[self createInvisibleWall:CGRectMake(canvas.contentSize.width, canvas.contentSize.height/2, 1, canvas.contentSize.height)]];
        
        // Add scoreboard at the top of the screen
        scorePlayer = 0, scoreEnemy = 0;
        scoreLabel = [CCLabelTTF labelWithString:@"0 : 0" fontName:@"Chalkduster" fontSize:36.0f];
        scoreLabel.color = [CCColor colorWithRed:0.4 green:0.4 blue:0.2];
        scoreLabel.position = ccp(canvas.contentSize.width/2, canvas.contentSize.height/4*3); // Middle top of screen
        [self addChild:scoreLabel];
    }
    return self;
}

// Create grey box with wall.size size and middle point in wall.origin
-(CCSprite*)createInvisibleWall:(CGRect)wall {
    CCSprite *sky = [CCSprite spriteWithImageNamed:@"blank.png"];
    sky.scaleX = wall.size.width;
    sky.scaleY = wall.size.height;
    sky.position = ccp(wall.origin.x, wall.origin.y);
    sky.color = [CCColor colorWithRed:0.2 green:0.2 blue:0.2];
    sky.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, sky.contentSize} cornerRadius:0];
    sky.physicsBody.type = CCPhysicsBodyTypeStatic;
    return sky;
}

// Add score for you (or enemy if its your goal)
-(void)addScore:(BOOL)enemy {
    if (!enemy) scoreEnemy++; else scorePlayer++;
    scoreLabel.string = [NSString stringWithFormat:@"%d : %d", scorePlayer, scoreEnemy];
}



@end
