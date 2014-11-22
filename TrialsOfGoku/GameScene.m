//
//  MyScene.m
//  SonOfGoku
//
//  Created by Matt on 10/20/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "GameScene.h"
#import "Globals.h"
#import "PowerBall.h"
#import "Buu.h"
#import "Minion.h"
#import "FirstLevel.h"


@implementation GameScene
{
    FirstLevel* firstLevel;
    
    
    SKLabelNode *myLabel;   // debugging
    
    NSInteger levelScore;   // keeps track of level score
    BOOL bgisMoving;        // keeps track of background movement
    NSArray *currentFrames; // animation frame holder
    NSDate *start;          // start timer
    NSTimer *pressTimer;    // tracks how long user holds down tap
    
    NSInteger levelIndicator;
}


#pragma mark Main Update Method
-(void)update:(CFTimeInterval)currentTime {
    
    //[self moveEnemies];
    
    // if first level
    
    // else if second level
    
    [firstLevel runLevelFor:self];
}


#pragma mark Set-Up Methods
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.gravity = CGVectorMake(0,0); // turn off gravities
        self.physicsWorld.contactDelegate = self; // set delegate for collision detection
        
        // create first level
        firstLevel = [[FirstLevel alloc] init];
        
        [firstLevel setUpLevelForScene:self];
        [self addChild:firstLevel.background1];
        [self addChild:firstLevel.background2];
        [self addChild:firstLevel.goku];
    
    }
    return self;
}


// currentFrames (this can be a local)
// powerballs, maybe objects of goku or maybe i pass them down?
//

#pragma mark Touch Handlers & Related Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    start = [NSDate date];
    if([firstLevel.goku oneBallIsNil]){
        pressTimer = [NSTimer scheduledTimerWithTimeInterval: .5
                                                      target:self
                                                    selector:@selector(handleTimer:)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}
-(void)handleHit: (NSTimer *) timer{
    firstLevel.finalBoss.isHit = false;
}
-(void)handleTimer: (NSTimer *) timer{
    // still presssed down, start charging goku
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
}
-(void)handleTapMovementAtLocation:(CGPoint)location inDirection:(NSInteger)direction{
    if(location.x > (firstLevel.goku.position.x+30)){
        [firstLevel.goku increaseVelocity:@"X" addVelocity:direction];
        currentFrames = [firstLevel.goku getAnimationFrames:@"goku_norm_walk_right"];
    }
    else if(location.x < (firstLevel.goku.position.x-30)){
        [firstLevel.goku increaseVelocity:@"X" addVelocity:direction];
        currentFrames = [firstLevel.goku getAnimationFrames:@"goku_norm_walk_left"];
    }
    
    if(firstLevel.goku.velocity.x > 0){
        if([firstLevel.goku.lastDirection isEqualToString:@"left"]){
            [firstLevel.goku haltVelocity:@"x"];
        }
    }
    else if(firstLevel.goku.velocity.x < 0){
        if([firstLevel.goku.lastDirection isEqualToString:@"right"]){
            [firstLevel.goku haltVelocity:@"x"];
        }
    }
    
    // if tap was a jump
    if(location.y > firstLevel.goku.position.y+30 && firstLevel.goku.jumpCount < 2){
        firstLevel.goku.jumpCount++;
        firstLevel.goku.velocity = CGPointMake(firstLevel.goku.velocity.x,firstLevel.goku.velocity.y+6);
        if(direction > 0){
            currentFrames = [firstLevel.goku getAnimationFrames:@"goku_norm_jump_right"];
        }else if(direction < 0){
            currentFrames = [firstLevel.goku getAnimationFrames:@"goku_norm_jump_left"];
        }
    }
    // animate whatever we decided on
    [firstLevel.goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
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

        
        // if firstlevel
            // determine direction
        
        // else second level
            // determine direction
        
        // set direction
        if(location.x > firstLevel.goku.position.x +10){
            firstLevel.goku.lastDirection = @"right";
            direction = 1;
        }else{
            firstLevel.goku.lastDirection = @"left";
            direction = -1;
        }

        if(difference < .5){ // was a tap
            [self handleTapMovementAtLocation:location inDirection:direction];
            // eventually add an attack if location = on enemy
            
        }else if (difference >= .5){ // not a tap
            [firstLevel.goku setUpPowerBalls:difference onScene:self];
        }
    }
}


#pragma mark Collision Detection
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    // if first level
    [firstLevel handleCollisionsWithContact:contact];
    
    // else second level
}


@end
