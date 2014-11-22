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

-(Buu*)createAnimatedBuu:(NSString *)buuAnimationKey{
    NSArray * frames = [[NSArray alloc] init];
    Buu * workingBuu = [[Buu alloc] init];
    frames = [workingBuu getAnimationFrames:buuAnimationKey];
    workingBuu = [Buu spriteNodeWithTexture:frames[0] ];
    return workingBuu;
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
    }
    return workingFrames;
}

-(void)setUpBuu{
    self.position = CGPointMake(520, 30); // spawns off edge
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = GOKU_CATEGORY | POWERBALL_CATEGORY;
    self.physicsBody.collisionBitMask = 0;
    self.inputView.contentMode = UIViewContentModeCenter;
    self.health = 200;
    self.attackPower = 5;
    
    self.name = @"buu";
    self.isDead = false;
    self.lastDirection = @"right"; // default because they spawn on right
}



@end
