//
//  Buu.m
//  trialsofgoku
//
//  Created by Matt on 11/13/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Buu.h"
#import "Goku.h"

@implementation Buu

#pragma mark Initialization
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isActivated = false;
    }
    return self;
}

-(NSArray *)getAnimationFrames:(NSString*)buuAnimationKey{
    NSMutableArray* workingFrames = [[NSMutableArray alloc] init];
    
    SKTextureAtlas *buuAtlas = [SKTextureAtlas atlasNamed:@"buu"];
    
    
    if([buuAnimationKey isEqualToString:@"buu_attack_right"]){
        NSUInteger i = arc4random_uniform(3) + 1;
        NSString *textureName = [NSString stringWithFormat:@"buu_attack_right_%lu", (unsigned long)i];
        SKTexture *temp = [buuAtlas textureNamed:textureName];
        [workingFrames addObject:temp];
    }
    if([buuAnimationKey isEqualToString:@"buu_dead_right"]){
        NSString *textureName = [NSString stringWithFormat:@"buu_deadfrom_right"];
        SKTexture *temp = [buuAtlas textureNamed:textureName];
        [workingFrames addObject:temp];
    }
    if([buuAnimationKey isEqualToString:@"buu_walk_right"]){
        for (int i=1; i <= 3; i++) {
            NSString *textureName = [NSString stringWithFormat:@"buu_walk_right_%d", i];
            SKTexture *temp = [buuAtlas textureNamed:textureName];
            [workingFrames addObject:temp];
        }
    }
    if([buuAnimationKey isEqualToString:@"buu_hitfrom_right"]){
        NSUInteger i = arc4random_uniform(3) + 1;
        NSString *textureName = [NSString stringWithFormat:@"buu_hitfrom_right_%lu", (unsigned long)i];
        SKTexture *temp = [buuAtlas textureNamed:textureName];
        [workingFrames addObject:temp];
    }
    
    
    return workingFrames;
}

-(void)checkEligibilityForAttackWith:(Goku *)goku
{
    if((abs(goku.position.x - self.position.x) < 10) && (abs(goku.position.y - self.position.y)<20)){
        goku.isAttacking = YES;
        [goku animateAttack];
        [self handleCollisionWithGoku:goku attackTypeIsPowerBall:NO];
    }
}


-(Buu*)setUpBuu{
    Buu* temp = [Buu spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"buu_walk_right_1"] size:CGSizeMake(80, 100)];
    NSArray *animation = [temp getAnimationFrames:@"buu_walk_right"];
    [temp runAnimation: animation atFrequency:.3 withKey:@"buu_walk_right"];

    temp.position = CGPointMake(-100, -100);
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:temp.size];
    temp.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.contactTestBitMask = GOKU_CATEGORY | POWERBALL_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.inputView.contentMode = UIViewContentModeCenter;
    temp.name = @"buu";
    temp.isDead = false;
    temp.health = 100;
    temp.totalHealth = 100;
    temp.attackPower = 10;
    temp.lastDirection = @"right";
    temp.typeOfObject = @"buu";
    temp.xScale = -1;
    return temp;
}





@end
