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

-(NSArray *)getAnimationFrames:(NSString*)minionAnimationKey
{
    NSMutableArray* workingArrayOfFrames = [[NSMutableArray alloc] init];
    
#pragma mark minion_animation
    if([minionAnimationKey hasPrefix:@"minion"]){
        SKTextureAtlas *minionAnimatedAtlas = [SKTextureAtlas atlasNamed:@"minions"];
        // minion_walk_right
        if([minionAnimationKey isEqualToString:@"minion_walk_right"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"minion_walk_right_%d", i];
                SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        }
        //minion_deadfrom_right
        if([minionAnimationKey isEqualToString:@"minion_deadfrom_right"]){
            NSString *textureName = [NSString stringWithFormat:@"minion_deadfrom_right"];
            SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
        //minion_hitfrom_right
        if([minionAnimationKey isEqualToString:@"minion_hitfrom_right"]){
            NSUInteger i = arc4random_uniform(3) + 1;
            NSString *textureName = [NSString stringWithFormat:@"minion_hitfrom_right_%lu", (unsigned long)i];
            SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
        //minion_attack_right
        if([minionAnimationKey isEqualToString:@"minion_attack_right"]){
            NSUInteger i = arc4random_uniform(3) + 1;
            NSString *textureName = [NSString stringWithFormat:@"minion_attack_right_%lu", (unsigned long)i];
            SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
    }
    return (NSArray*)workingArrayOfFrames;
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
