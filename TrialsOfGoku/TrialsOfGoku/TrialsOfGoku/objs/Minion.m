//
//  Minion.m
//  trialsofgoku
//
//  Created by Matt on 11/15/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Minion.h"

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
-(void)setUpMinion{
    self.position = CGPointMake(200, 175);
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = GOKU_CATEGORY | POWERBALL_CATEGORY;
    self.physicsBody.collisionBitMask = 0;
    self.inputView.contentMode = UIViewContentModeCenter;
    self.name = @"minion";
    self.isDead = false;
}

#pragma mark Actions
-(void)runAnimation:(NSArray*)animationFrames atFrequency:(float)frequency{
    
}



@end
