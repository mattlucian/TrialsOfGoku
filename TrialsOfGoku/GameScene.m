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


@implementation GameScene
{
    NSInteger levelIndicator;
    FirstLevel* firstLevel;
    
    NSDate *start;          // start timer
    NSTimer *pressTimer;    // tracks how long user holds down tap
}


#pragma mark Set-Up Methods
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.gravity = CGVectorMake(0,0); // turn off gravities
        self.physicsWorld.contactDelegate = self; // set delegate for collision detection
        
        levelIndicator = 1;
        
        firstLevel = [[FirstLevel alloc] init];
        
        [firstLevel setUpLevelForScene:self];
        [self addChild:firstLevel.background1];
        [self addChild:firstLevel.background2];
        [self addChild:firstLevel.goku];
    }
    return self;
}


#pragma mark Main Update Method
-(void)update:(CFTimeInterval)currentTime {
    
    if(levelIndicator == 1){
        [firstLevel runLevelFor:self];
    }else{
        // level 2
    }
}

#pragma mark Touch Handlers & Related Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    start = [NSDate date];
    if(levelIndicator == 1){
        if([firstLevel.goku oneBallIsNil]){
            pressTimer = [NSTimer scheduledTimerWithTimeInterval: .5
                                                          target:self
                                                        selector:@selector(handleTimer:)
                                                        userInfo:nil
                                                         repeats:NO];
        }
    }else{
        // level 2
    }
}

-(void)handleTimer: (NSTimer *) timer{
    // still presssed down, start charging goku
    NSArray* currentFrames;
    if(levelIndicator == 1){
        if([firstLevel.goku oneBallIsNil]){
            [firstLevel.goku haltVelocity:@"X"];
            if([firstLevel.goku.lastDirection isEqualToString:@"right"]){
                currentFrames= [firstLevel.goku getAnimationFrames:@"goku_norm_ball_charge_right"];
                [firstLevel.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
            }else if([firstLevel.goku.lastDirection isEqualToString:@"left"]){
                currentFrames= [firstLevel.goku getAnimationFrames:@"goku_norm_ball_charge_left"];
                [firstLevel.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
            }
        }
    }else{
        // level 2
        
        // super sayian
    }
    
}
-(void)handleTapMovementAtLocation:(CGPoint)location inDirection:(NSInteger)direction{
   
    if(levelIndicator == 1){
        [firstLevel handleTapGestureWithLocation:location andDirection:direction];
    }else{
        // level 2
        
        
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
        
        if(levelIndicator == 1){
            if(location.x > firstLevel.goku.position.x +10){
                firstLevel.goku.lastDirection = @"right";
                direction = 1;
            }else{
                firstLevel.goku.lastDirection = @"left";
                direction = -1;
            }
        }else{
            // level 2
            
        }

        if(difference < .5){ // was a tap
            [self handleTapMovementAtLocation:location inDirection:direction];
          
            // eventually add an attack if location = on enemy
          
            
        }else if (difference >= .5){ // not a tap
            if(levelIndicator == 1){
                [firstLevel.goku setUpPowerBalls:difference onScene:self];
            }else{
                // level 2
                
            }
        }
    }
}


#pragma mark Collision Detection
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    if(levelIndicator == 1){
        [firstLevel handleBossCollisions:contact];
    }else{
        // level 2
        
    }
    
}


@end
