//
//  Goal.h
//  SoccerFlick
//
//  Created by Pawel Bajguz on 13/09/2014.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Goal : CCSprite {
    
}

@property (assign) BOOL enemyGoal;

-(id)initWithScreenSize:(CGSize)size enemy:(BOOL)enemy;

@end
