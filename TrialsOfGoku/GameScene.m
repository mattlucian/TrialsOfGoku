//
//  MyScene.m
//  SonOfGoku
//
//  Created by Matt on 10/20/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "GameScene.h"
#import "Globals.h"
#import "FirstLevel.h"
#import "SecondLevel.h"

@implementation GameScene
{
    FirstLevel* firstLevel;
    SecondLevel* secondLevel;
    
    NSDate *start;          // start timer
    NSTimer *pressTimer;    // tracks how long user holds down tap
}


#pragma mark Set-Up Methods
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.gravity = CGVectorMake(0,0); // turn off gravities
        self.physicsWorld.contactDelegate = self; // set delegate for collision detection
        
        self.levelIndicator = 1;
        
        firstLevel = [[FirstLevel alloc] init];
        
        [firstLevel setUpLevelForScene:self];
           }
    return self;
}


#pragma mark Main Update Method
-(void)update:(CFTimeInterval)currentTime {
    
    if(self.levelIndicator == 1){
        [firstLevel runLevelFor:self];
    }else{
        if(firstLevel != nil){
            [firstLevel killFirstLevel];
            firstLevel = nil;
            secondLevel = [[SecondLevel alloc] init];
            [secondLevel setUpLevelForScene:self];
        }
        [secondLevel runLevelFor:self];
    }
}

#pragma mark Touch Handlers & Related Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    start = [NSDate date];
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self]; // get location
        
        if(self.levelIndicator == 1){
            
            if(((abs(location.x - firstLevel.goku.position.x) < 30)&&(location.y > firstLevel.goku.position.y))&&(!firstLevel.goku.hasTransformed)){
                [firstLevel.goku transformToSuperSaiyan:[[NSNumber alloc] initWithInt:1]];
            }else{
                if([firstLevel.goku oneBallIsNil]){
                    pressTimer = [NSTimer scheduledTimerWithTimeInterval: .5
                                                                  target:self
                                                                selector:@selector(handleTimer:)
                                                                userInfo:nil
                                                                 repeats:NO];
                }
            }
        }else{
            
            if(((abs(location.x - secondLevel.goku.position.x) < 30)&&(location.y > secondLevel.goku.position.y))&&(!secondLevel.goku.hasTransformed)){
                [secondLevel.goku transformToSuperSaiyan:[[NSNumber alloc] initWithInt:1]];
            }else{
                if([secondLevel.goku oneBallIsNil]){
                    pressTimer = [NSTimer scheduledTimerWithTimeInterval: .5
                                                                  target:self
                                                                selector:@selector(handleTimer:)
                                                                userInfo:nil
                                                                 repeats:NO];
                }
            }
        }
    }
}

-(void)handleTimer: (NSTimer *) timer{
    // still presssed down, start charging goku
    NSArray* currentFrames;
    if(self.levelIndicator == 1){
        if([firstLevel.goku oneBallIsNil]){
            [firstLevel.goku haltVelocity:@"X"];
            if([firstLevel.goku.lastDirection isEqualToString:@"right"]){
                if(firstLevel.goku.transformationLevel == 0)
                    currentFrames= [firstLevel.goku getAnimationFrames:@"goku_norm_ball_charge_right"];
                else if(firstLevel.goku.transformationLevel == 1)
                    currentFrames= [firstLevel.goku getAnimationFrames:@"goku_ss1_ball_charge_right"];
                else
                    currentFrames= [firstLevel.goku getAnimationFrames:@"goku_ss3_ball_charge_right"];
                
                [firstLevel.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
            }else if([firstLevel.goku.lastDirection isEqualToString:@"left"]){
              
                if(firstLevel.goku.transformationLevel == 0)
                    currentFrames= [firstLevel.goku getAnimationFrames:@"goku_norm_ball_charge_left"];
                else if(firstLevel.goku.transformationLevel == 1)
                    currentFrames= [firstLevel.goku getAnimationFrames:@"goku_ss1_ball_charge_left"];
                else
                    currentFrames= [firstLevel.goku getAnimationFrames:@"goku_ss3_ball_charge_left"];

                [firstLevel.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
            }
        }
    }else{
        if([secondLevel.goku oneBallIsNil]){
            [secondLevel.goku haltVelocity:@"X"];
            if([secondLevel.goku.lastDirection isEqualToString:@"right"]){
                if(secondLevel.goku.transformationLevel == 0)
                    currentFrames= [secondLevel.goku getAnimationFrames:@"goku_norm_ball_charge_right"];
                else if(secondLevel.goku.transformationLevel == 1)
                    currentFrames= [secondLevel.goku getAnimationFrames:@"goku_ss1_ball_charge_right"];
                else
                    currentFrames= [secondLevel.goku getAnimationFrames:@"goku_ss3_ball_charge_right"];

                [secondLevel.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
                
            }else if([secondLevel.goku.lastDirection isEqualToString:@"left"]){
                if(secondLevel.goku.transformationLevel == 0)
                    currentFrames= [secondLevel.goku getAnimationFrames:@"goku_norm_ball_charge_left"];
                else if(secondLevel.goku.transformationLevel == 1)
                    currentFrames= [secondLevel.goku getAnimationFrames:@"goku_ss1_ball_charge_left"];
                else
                    currentFrames= [secondLevel.goku getAnimationFrames:@"goku_ss3_ball_charge_left"];
                
                [secondLevel.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
            }
        }
    }
    currentFrames = nil;
}
-(void)handleTapMovementAtLocation:(CGPoint)location inDirection:(NSInteger)direction{
   
    if(self.levelIndicator == 1){
        [firstLevel handleTapGestureWithLocation:location andDirection:direction];
        // test change
        SKNode *node = [self nodeAtPoint:location];
        // [firstLevel checkNodeTap:firstLevel.goku inRelationTo:firstLevel.goku];
        if([node isEqual:firstLevel.minion1] && abs((firstLevel.goku.position.x - firstLevel.minion1.position.x) < 10)){
            [node runAction:[SKAction fadeOutWithDuration:0]];
        }else if([node isEqual:firstLevel.finalBoss] && abs((firstLevel.goku.position.x - firstLevel.minion1.position.x) < 10)){
            [node runAction:[SKAction fadeOutWithDuration:0]];
        }
        
    }else{
        [secondLevel handleTapGestureWithLocation:location andDirection:direction];
        // test change
        SKNode *node = [self nodeAtPoint:location];
        // [secondLevel checkNodeTap:firstLevel.goku inRelationTo:secondLevel.goku];
        if([node isEqual:secondLevel.minion1] && abs((secondLevel.goku.position.x - secondLevel.minion1.position.x) < 10)){
            [node runAction:[SKAction fadeOutWithDuration:0]];
        }else if([node isEqual:secondLevel.finalBoss] && abs((secondLevel.goku.position.x - secondLevel.minion1.position.x) < 10)){
            [node runAction:[SKAction fadeOutWithDuration:0]];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSDate *end = [NSDate date];
    float beg = [start timeIntervalSinceNow];
    float fin = [end timeIntervalSinceNow];
    start = nil; end = nil;
    float difference = fin - beg;
    
    // kills timer so blast isnt shot
    [pressTimer invalidate];
    
    // for touches:
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self]; // get location
        NSInteger direction = 0; // init direction
        
        if(self.levelIndicator == 1){
            if(location.x > firstLevel.goku.position.x +10){
                firstLevel.goku.lastDirection = @"right";
                direction = 1;
            }else{
                firstLevel.goku.lastDirection = @"left";
                direction = -1;
            }
        }else{
            if(location.x > secondLevel.goku.position.x +10){
                secondLevel.goku.lastDirection = @"right";
                direction = 1;
            }else{
                secondLevel.goku.lastDirection = @"left";
                direction = -1;
            }
            
        }

        if(difference < .5){ // was a tap
            [self handleTapMovementAtLocation:location inDirection:direction];
          
            // eventually add an attack if location = on enemy
            
        }else if (difference >= .5){ // not a tap
            if(self.levelIndicator == 1){
                [firstLevel.goku setUpPowerBalls:difference onScene:self];
            }else{
                [secondLevel.goku setUpPowerBalls:difference onScene:self];
                
            }
        }
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    if(self.levelIndicator == 1){
        [firstLevel handleCollisionEnd:contact];
    }else{
        [secondLevel handleCollisionEnd:contact];
    }
}

#pragma mark Collision Detection
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    if(self.levelIndicator == 1){
        [firstLevel handleBossCollisions:contact];
    }else{
        [secondLevel handleBossCollisions:contact];
    }
    
}


@end
