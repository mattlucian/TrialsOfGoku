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

-(void)moveMinionInRelationTo:(Goku*)goku andBackgroundFlag:(BOOL)bgIsMoving
{
    if(self != nil){              // MINION
        if(self.isActivated){
            if(!self.isDead){
                if(self.position.x > goku.position.x){ // minion to the right
                    if([self.lastDirection isEqualToString:@"right"]){
                        self.velocity = CGPointMake(-1,self.velocity.y);
                        self.lastDirection = @"left";
                    }
                }else{ // buu to the left
                    if([self.lastDirection isEqualToString:@"left"]){
                        self.velocity = CGPointMake(1,self.velocity.y);
                        self.lastDirection = @"right";
                    }
                }
                if(bgIsMoving)
                    self.position = CGPointMake(self.position.x+self.velocity.x- goku.velocity.x,self.position.y);
                else
                    self.position = CGPointMake(self.position.x+self.velocity.x-(goku.velocity.x/50),self.position.y);
            }
        }
    }

}


@end
