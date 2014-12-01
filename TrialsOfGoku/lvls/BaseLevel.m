//
//  BaseLevel.m
//  trialsofgoku
//
//  Created by Matt on 11/22/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "BaseLevel.h"

@implementation BaseLevel


-(void)moveBackground:(BOOL)isMoving inRelationTo:(Goku*)goku{
    
    if(isMoving){
        self.bgIsMoving = YES;
        
        [self moveObstacles];
        
        if(self.background1 != nil)
            self.background1.position = CGPointMake(self.background1.position.x-goku.velocity.x,self.background1.position.y);
        
        if(self.background2 != nil)
            self.background2.position = CGPointMake(self.background2.position.x-goku.velocity.x,self.background2.position.y);
        
        
        // if goku is traveling right
        if(goku.velocity.x > 0){
            if((self.background1.position.x+(self.background1.size.width/2)) < 0){ // reset the background to the begining
                self.background1.position = CGPointMake((self.background2.position.x+(self.background2.size.width)),self.background1.position.y);
                self.currentLevelLocation += 1;
            }
            if((self.background2.position.x+(self.background2.size.width/2)) < 0){
                self.background2.position = CGPointMake((self.background1.position.x+(self.background1.size.width)),self.background2.position.y);
                self.currentLevelLocation += 1;
            }
        }else{ // else goku is traveling left
            if((self.background1.position.x-(self.background1.size.width/2)) > [[UIScreen mainScreen] bounds].size.width){
                self.background1.position = CGPointMake((self.background2.position.x-(self.background2.size.width)),self.background1.position.y);
                self.currentLevelLocation -= 1;
            }
            if((self.background2.position.x-(self.background2.size.width/2)) > [[UIScreen mainScreen] bounds].size.width){
                self.background2.position = CGPointMake((self.background1.position.x-(self.background1.size.width)),self.background2.position.y);
                self.currentLevelLocation -= 1;
            }
        }
    }else{
        self.bgIsMoving = NO;
    }    
}




-(void)moveObstacles
{
    if(self.obstacle1 != nil)
        [self.obstacle1 moveInRelationTo:self.goku];
    if(self.obstacle2 != nil)
        [self.obstacle2 moveInRelationTo:self.goku];
    if(self.obstacle3 != nil)
        [self.obstacle3 moveInRelationTo:self.goku];
    if(self.obstacle4 != nil)
        [self.obstacle4 moveInRelationTo:self.goku];
    if(self.obstacle5 != nil)
        [self.obstacle5 moveInRelationTo:self.goku];
    if(self.obstacle6 != nil)
        [self.obstacle6 moveInRelationTo:self.goku];
    
}

-(void)handleTapGestureWithLocation:(CGPoint)location andDirection:(NSInteger)direction
{
    NSArray* currentFrames = nil;
    if(location.x > (self.goku.position.x+30)){
        [self.goku increaseVelocity:@"X" addVelocity:(direction*3)];
        
        if(self.goku.transformationLevel == 0)
            currentFrames = [self.goku getAnimationFrames:@"goku_norm_walk_right"];
        else if(self.goku.transformationLevel == 1)
            currentFrames = [self.goku getAnimationFrames:@"goku_ss1_walk_right"];
        else if(self.goku.transformationLevel == 3)
            currentFrames = [self.goku getAnimationFrames:@"goku_ss3_walk_right"];

    }
    else if(location.x < (self.goku.position.x-30)){
        [self.goku increaseVelocity:@"X" addVelocity:(direction*3)];

        if(self.goku.transformationLevel == 0)
            currentFrames = [self.goku getAnimationFrames:@"goku_norm_walk_left"];
        else if(self.goku.transformationLevel == 1)
            currentFrames = [self.goku getAnimationFrames:@"goku_ss1_walk_left"];
        else if(self.goku.transformationLevel == 3)
            currentFrames = [self.goku getAnimationFrames:@"goku_ss3_walk_left"];

    }
    
    if(self.goku.velocity.x > 0){
        if([self.goku.lastDirection isEqualToString:@"left"]){
            [self.goku haltVelocity:@"x"];
        }
    }
    else if(self.goku.velocity.x < 0){
        if([self.goku.lastDirection isEqualToString:@"right"]){
            [self.goku haltVelocity:@"x"];
        }
    }
    
    // if tap was a jump
    if(location.y > self.goku.position.y+60 && self.goku.jumpCount < 2){
        self.goku.jumpCount++;
        self.goku.fallingLock = NO;
        self.goku.velocity = CGPointMake(self.goku.velocity.x,self.goku.velocity.y+8);
        self.goku.performingAnAction = YES;
        if(direction > 0){
            if(self.goku.transformationLevel == 0)
                currentFrames = [self.goku getAnimationFrames:@"goku_norm_jump_right"];
            else if(self.goku.transformationLevel == 1)
                currentFrames = [self.goku getAnimationFrames:@"goku_ss1_jump_right"];
            else if(self.goku.transformationLevel == 3)
                currentFrames = [self.goku getAnimationFrames:@"goku_ss3_jump_right"];
            
        }else if(direction < 0){
            if(self.goku.transformationLevel == 0)
                currentFrames = [self.goku getAnimationFrames:@"goku_norm_jump_left"];
            else if(self.goku.transformationLevel == 1)
                currentFrames = [self.goku getAnimationFrames:@"goku_ss1_jump_left"];
            else if(self.goku.transformationLevel == 3)
                currentFrames = [self.goku getAnimationFrames:@"goku_ss3_jump_left"];
        }
    }
    // animate whatever we decided on
    if(currentFrames != nil)
        [self.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
    
}


-(void)handleMinionCollisions:(SKPhysicsContact *)contact{
    if(self.minion1 != nil) {
        if(self.minion1.isActivated){
            if(!self.minion1.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion1"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion1 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion1"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion1 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion2 != nil) {
        if(self.minion2.isActivated){
            if(!self.minion2.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion2"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion2 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion2"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion2 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion3 != nil) {
        if(self.minion3.isActivated){
            if(!self.minion3.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion3"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion3 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion3"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion3 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    
    if(self.minion4 != nil) {
        if(self.minion4.isActivated){
            if(!self.minion4.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion4"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion4 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion4"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion4 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion5 != nil) {
        if(self.minion5.isActivated){
            if(!self.minion5.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion5"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion5 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion5"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion5 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion6 != nil) {
        if(self.minion6.isActivated){
            if(!self.minion6.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion6"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion6 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion6"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion6 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
}

-(void)handleCollisionEnd:(SKPhysicsContact *)contact
{
    NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
    if ([nodeNames containsObject:@"rock"] && [nodeNames containsObject:@"goku"]) {
        self.goku.obstacleRightLock = NO;
        self.goku.obstacleLeftLock = NO;
        self.goku.isCollidingWithObstacle = NO;
        self.goku.fallingLock = NO;
        self.goku.jumpCount++;
    }
    
}
-(void)handleObstacleCollisions:(SKPhysicsContact *) contact{
    NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
    if ([nodeNames containsObject:@"rock"] && [nodeNames containsObject:@"goku"]) {
        if(!self.goku.isCollidingWithObstacle){
            float difference = contact.bodyA.node.position.x - contact.bodyB.node.position.x;
            if([contact.bodyA.node.name isEqualToString:@"goku"]){
                // node A == Goku
                if(difference > 40 )
                    self.goku.obstacleLeftLock = YES;
                
                else if(difference < 40)
                    self.goku.obstacleRightLock = YES;
            }else{
                if(difference > 40 )
                    self.goku.obstacleRightLock = YES;
                else if(difference < 40)
                    self.goku.obstacleLeftLock = YES;
                
            }
            if(abs(contact.bodyA.node.position.y - contact.bodyB.node.position.y) > 30)
                self.goku.fallingLock = YES;
            self.goku.isCollidingWithObstacle = YES;
            [self.goku.delegate moveBackground:NO inRelationTo:self.goku];
        }
    }
}

-(void)unpauseAnimations{
    
    if(!self.goku.isDead){
        [self.goku removeActionForKey:@"paused_key"];
    }
    
    if(self.minion1 != nil){
        [self.minion1 runAction:[SKAction unhide]];
        [self.minion1.healthBar runAction:[SKAction unhide]];
    }
    if(self.minion2 != nil){
        [self.minion2 runAction:[SKAction unhide]];
        [self.minion2.healthBar runAction:[SKAction unhide]];
        
    }
    if(self.minion3 != nil){
        [self.minion3 runAction:[SKAction unhide]];
        [self.minion3.healthBar runAction:[SKAction unhide]];
    }
    if(self.minion4 != nil){
        [self.minion4 runAction:[SKAction unhide]];
        [self.minion4.healthBar runAction:[SKAction unhide]];
    }
    if(self.minion5 != nil){
        [self.minion5 runAction:[SKAction unhide]];
        [self.minion5.healthBar runAction:[SKAction unhide]];
    }
    if(self.minion6 != nil){
        [self.minion6 runAction:[SKAction unhide]];
        [self.minion6.healthBar runAction:[SKAction unhide]];
    }
    if(self.finalBoss != nil){
        [self.finalBoss runAction:[SKAction unhide]];
        [self.finalBoss.healthBar runAction:[SKAction unhide]];
    }
}

-(void)pauseAnimations{
    if(!self.goku.isDead){
        switch (self.goku.transformationLevel) {
            case 0:
                [self.goku runAnimation:[self.goku getAnimationFrames:@"goku_norm_stance_right"] atFrequency:1 withKey:@"paused_key"];
                break;
                
            case 1:
                [self.goku runAnimation:[self.goku getAnimationFrames:@"goku_ss1_stance_right"] atFrequency:1 withKey:@"paused_key"];
                break;
                
            case 3:
                [self.goku runAnimation:[self.goku getAnimationFrames:@"goku_ss3_stance_right"] atFrequency:1 withKey:@"paused_key"];
                break;
                
            default:
                break;
        }
    }
    
    if(self.minion1 != nil){
        [self.minion1 runAction:[SKAction hide]];
        [self.minion1.healthBar runAction:[SKAction hide]];
    }
    if(self.minion2 != nil){
        [self.minion2 runAction:[SKAction hide]];
        [self.minion2.healthBar runAction:[SKAction hide]];
        
    }
    if(self.minion3 != nil){
        [self.minion3 runAction:[SKAction hide]];
        [self.minion3.healthBar runAction:[SKAction hide]];
    }
    if(self.minion4 != nil){
        [self.minion4 runAction:[SKAction hide]];
        [self.minion4.healthBar runAction:[SKAction hide]];
    }
    if(self.minion5 != nil){
        [self.minion5 runAction:[SKAction hide]];
        [self.minion5.healthBar runAction:[SKAction hide]];
    }
    if(self.minion6 != nil){
        [self.minion6 runAction:[SKAction hide]];
        [self.minion6.healthBar runAction:[SKAction hide]];
    }
    if(self.finalBoss != nil){
        [self.finalBoss runAction:[SKAction hide]];
        [self.finalBoss.healthBar runAction:[SKAction hide]];
    }
}


-(void)handleGokuCollision:(SKPhysicsContact *) contact{
    
    if(!self.goku.isDead){
        NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
        if ([nodeNames containsObject:@"minion1"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion1.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion2"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion2.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion3"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion3.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion4"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion4.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion5"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion5.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion6"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion6.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"boss"] && [nodeNames containsObject:@"goku"]) {
            if(!self.finalBoss.isDead)
                [self.goku handleHitByMinion:contact isBoss:YES];
        }
    }
    
}

@end
