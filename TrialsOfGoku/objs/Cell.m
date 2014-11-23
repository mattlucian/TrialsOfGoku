//
//  Cell.m
//  trialsofgoku
//
//  Created by Matt on 11/15/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Cell.h"

@implementation Cell


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isActivated = false;
    }
    return self;
}


-(NSArray *)getAnimationFrames:(NSString*)cellAnimationKey
{
    NSMutableArray* workingArrayOfFrames = [[NSMutableArray alloc] init];
    
#pragma mark cell_animation
    if([cellAnimationKey hasPrefix:@"cell"]){
        SKTextureAtlas *cellAnimatedAtlas = [SKTextureAtlas atlasNamed:@"cell"];
        // minion_walk_right
        if([cellAnimationKey isEqualToString:@"cell_walk_right"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"cell_walk_right_%d", i];
                SKTexture *temp = [cellAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        }
        if([cellAnimationKey isEqualToString:@"cell_deadfrom_right"]){
            NSString *textureName = [NSString stringWithFormat:@"cell_deadfrom_right"];
            SKTexture *temp = [cellAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
        if([cellAnimationKey isEqualToString:@"cell_hitfrom_right"]){
            NSUInteger i = arc4random_uniform(3) + 1;
            NSString *textureName = [NSString stringWithFormat:@"cell_hitfrom_right_%lu", (unsigned long)i];
            SKTexture *temp = [cellAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
        //minion_attack_right
        if([cellAnimationKey isEqualToString:@"cell_attack_right"]){
            NSUInteger i = arc4random_uniform(3) + 1;
            NSString *textureName = [NSString stringWithFormat:@"cell_attack_right_%lu", (unsigned long)i];
            SKTexture *temp = [cellAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
    }
    return (NSArray*)workingArrayOfFrames;
}


-(Cell*)setUpCell{
    Cell* temp = [[Cell alloc] init];
    temp.position = CGPointMake(520, 30); // spawns off edge
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    temp.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.contactTestBitMask = GOKU_CATEGORY | POWERBALL_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.inputView.contentMode = UIViewContentModeCenter;
    temp.name = @"cell";
    temp.isDead = false;
    temp.lastDirection = @"right"; // default because they spawn on right
    return temp;
}


@end
