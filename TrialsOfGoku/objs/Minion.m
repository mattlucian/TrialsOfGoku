//
//  Minion.m
//  trialsofgoku
//
//  Created by Matt on 11/15/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Minion.h"
#import "Goku.h"

@implementation Minion


#pragma mark Initialization
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isActivated = false;
    }
    return self;
}
-(Minion*)setUpMinionWithName:(NSString *)name
{
    Minion* temp = [Minion spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"minion_walk_right_1"]];
    temp.position = CGPointMake(-100, -100);
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:temp.size];
    temp.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.contactTestBitMask = GOKU_CATEGORY | POWERBALL_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.inputView.contentMode = UIViewContentModeCenter;

    temp.name = name;
    
    temp.health = 50;
    temp.totalHealth = 50;
    temp.attackPower = 5;
    
    temp.isDead = false;
    temp.lastDirection = @"right";
    temp.typeOfObject = @"minion";
    return temp;
}



@end
