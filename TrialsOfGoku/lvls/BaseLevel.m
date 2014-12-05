//
//  BaseLevel.m
//  trialsofgoku
//
//  Created by Matt on 11/22/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "BaseLevel.h"

@implementation BaseLevel


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



@end
