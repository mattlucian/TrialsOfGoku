//
//  Buu.m
//  trialsofgoku
//
//  Created by Matt on 11/13/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Buu.h"


@implementation Buu

#pragma mark Initialization
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isActivated = false;
        NSLog(@"test");
    }
    return self;
}

-(NSArray *)getAnimationFrames:(NSString*)buuAnimationKey{
    NSMutableArray* workingFrames = [[NSMutableArray alloc] init];
 
    SKTextureAtlas *buuAtlas = [SKTextureAtlas atlasNamed:@"buu"];
    
    if([buuAnimationKey isEqualToString:@"buu_attack_right"]){
        for (int i=1; i <= 3; i++) {
            NSString *textureName = [NSString stringWithFormat:@"buu_attack_right_%d", i];
            SKTexture *temp = [buuAtlas textureNamed:textureName];
            [workingFrames addObject:temp];
        }
    } else if([buuAnimationKey isEqualToString:@"buu_dead_right"]){
        NSString *textureName = [NSString stringWithFormat:@"buu_deadfrom_right"];
        SKTexture *temp = [buuAtlas textureNamed:textureName];
        [workingFrames addObject:temp];
    } else if([buuAnimationKey isEqualToString:@"buu_walk_right"]){
        NSString *textureName = [NSString stringWithFormat:@"buu_walk_right_1"];
        SKTexture *temp = [buuAtlas textureNamed:textureName];
        [workingFrames addObject:temp];
    }
    
    return workingFrames;
}

-(Buu*)setUpBuu{
    Buu* temp = [Buu spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"buu_walk_right_1"]];

    temp.position = CGPointMake(-100, -100);
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:temp.size];
    temp.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.contactTestBitMask = GOKU_CATEGORY | POWERBALL_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.inputView.contentMode = UIViewContentModeCenter;
    temp.name = @"boss";
    temp.isDead = false;
    temp.health = 100;
    temp.attackPower = 10;
    temp.lastDirection = @"right";
    temp.typeOfObject = @"buu";
    return temp;
}





@end
