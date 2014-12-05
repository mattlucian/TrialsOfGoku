//
//  Minion2.m
//  trialsofgoku
//
//  Created by Marcus on 11/30/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Minion2.h"
#import "Goku.h"

@implementation Minion2
{
    NSTimer* hitTimer;
}

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
    if([minionAnimationKey hasPrefix:@"minion2"]){
        SKTextureAtlas *minionAnimatedAtlas = [SKTextureAtlas atlasNamed:@"minion2"];
        // minion_walk_right
        if([minionAnimationKey isEqualToString:@"minion2_walk_right"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"minion2_walk_right_%d", i];
                SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        }
        //minion_deadfrom_right
        if([minionAnimationKey isEqualToString:@"minion2_deadfrom_right"]){
            NSString *textureName = [NSString stringWithFormat:@"minion2_deadfrom_right"];
            SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
        //minion_hitfrom_right
        if([minionAnimationKey isEqualToString:@"minion2_hitfrom_right"]){
            NSUInteger i = arc4random_uniform(3) + 1;
            NSString *textureName = [NSString stringWithFormat:@"minion2_hitfrom_right_%lu", (unsigned long)i];
            SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
        //minion_attack_right
        if([minionAnimationKey isEqualToString:@"minion2_attack_right"]){
            NSUInteger i = arc4random_uniform(3) + 1;
            NSString *textureName = [NSString stringWithFormat:@"minion2_attack_right_%lu", (unsigned long)i];
            SKTexture *temp = [minionAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }
    }
    return (NSArray*)workingArrayOfFrames;
}

-(BOOL)checkEligibilityForAttackWith:(Goku *)goku
{
    if(!self.isDead && self.isActivated){
        if((abs(goku.position.x - self.position.x) < 100) && (abs(goku.position.y - self.position.y)<40)){
            [self handleCollisionWithGoku:goku attackTypeIsPowerBall:NO];
            return YES;
        }
    }
    return NO;
}

-(Minion2*)setUpMinionWithName:(NSString *)name
{
    Minion2* temp = [Minion2 spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"minion2_walk_right_1"] size:CGSizeMake(80, 100)];
    NSArray *animation = [temp getAnimationFrames:@"minion2_walk_right"];
    [temp runAnimation: animation atFrequency:.3 withKey:@"minion2_walk_right"];
    temp.position = CGPointMake(-100, -100);
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:temp.size];
    temp.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.contactTestBitMask = GOKU_CATEGORY | POWERBALL_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.inputView.contentMode = UIViewContentModeCenter;
    temp.xScale = -1.0;
    
    temp.name = name;
    
    temp.health = 100;
    temp.totalHealth = 100;
    temp.attackPower = 10;
    
    temp.isDead = false;
    temp.lastDirection = @"right";
    temp.typeOfObject = @"minion2";
    return temp;
}


@end
