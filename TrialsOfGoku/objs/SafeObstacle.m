//
//  Rock.m
//  trialsofgoku
//
//  Created by Matt on 11/14/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "SafeObstacle.h"

@implementation SafeObstacle
{
    CGPoint velocity;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(SafeObstacle*)setUpObstacleAtPoint:(CGPoint)point withName: (NSString*) name;
{
    SafeObstacle* temp = [SafeObstacle spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"rock1"] size:CGSizeMake(70, 100)];
    temp.isActivated = YES;
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:temp.size];
    temp.physicsBody.categoryBitMask = SAFE_OBSTACLE_CATEGORY;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.contactTestBitMask = ENEMY_CATEGORY | GOKU_CATEGORY | ENEMY_BLAST_CATEGORY | POWERBALL_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.name = name;
    temp.position = point;
    
    return temp;

}

-(void)moveInRelationTo:(Goku *)goku
{
    self.position = CGPointMake(self.position.x+velocity.x- goku.velocity.x,self.position.y);
}

@end
