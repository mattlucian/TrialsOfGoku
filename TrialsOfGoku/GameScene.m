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
    NSTimer* endTimer;
    BOOL paused;
    SKSpriteNode* pauseButton;
    SKSpriteNode* mainMenu;
}


#pragma mark Set-Up Methods
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.gravity = CGVectorMake(0,0); // turn off gravities
        self.physicsWorld.contactDelegate = self; // set delegate for collision detection
        
        pauseButton = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"pause"] color:[[UIColor alloc] init] size:CGSizeMake(100, 100)];
        
        self.levelIndicator = 1;
        
        firstLevel = [[FirstLevel alloc] init];
                
        [firstLevel setUpLevelForScene:self];
        pauseButton.position = CGPointMake(900,600);
        [self addChild:pauseButton];
    }
    return self;
}

-(void)handlePauseButtonPress{
    if(paused){
        paused = NO;
        pauseButton.texture = [SKTexture textureWithImageNamed:@"pause"];
        // stop animations
        if(self.levelIndicator == 1){
            [firstLevel unpauseAnimations];
            [mainMenu removeFromParent];
            [firstLevel.backgroundMusicPlayer play];
        }else{
            // second level unpause
        }
    }else{
        paused = YES;
        pauseButton.texture = [SKTexture textureWithImageNamed:@"play"];
        if(self.levelIndicator == 1){
            [firstLevel pauseAnimations];
            mainMenu = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"menu_button"] color:[[UIColor alloc] init] size:CGSizeMake(150,100)];
            mainMenu.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-200);
            
            [self addChild:mainMenu];
            [firstLevel.backgroundMusicPlayer pause];

            
        }else{
            // first level pause
        }
    }
}

#pragma mark Main Update Method
-(void)update:(CFTimeInterval)currentTime {
    if(!paused){
        if(self.levelIndicator == 1){
            if(firstLevel.goku.isDead && (firstLevel.goku.position.y <= 62 || firstLevel.goku.fallingLock )){
                [self handlePauseButtonPress];
                
                SKSpriteNode* gameOver = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"game_over"]];
                gameOver.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
                [pauseButton removeFromParent];
                
                mainMenu = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"menu_button"] color:[[UIColor alloc] init] size:CGSizeMake(150,100)];
                mainMenu.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-200);
                
                
                [self addChild:gameOver];
                [self addChild:mainMenu];
                
                
                
            }
            
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
}

#pragma mark Touch Handlers & Related Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    start = [NSDate date];
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self]; // get location
        
        
        if(self.levelIndicator == 1){
            if(!firstLevel.goku.isDead){
                if(((abs(location.x - firstLevel.goku.position.x) < 30)&&(location.y > firstLevel.goku.position.y))&&(!firstLevel.goku.hasTransformed)){
                    
                    [firstLevel.goku transformToSuperSaiyan:[[NSNumber alloc] initWithInt:1]];
                    firstLevel.goku.performingAnAction = YES;
                }else{
                    if([firstLevel.goku oneBallIsNil] && !firstLevel.goku.isTransforming){
                        pressTimer = [NSTimer scheduledTimerWithTimeInterval: .5
                                                                      target:self
                                                                    selector:@selector(handleTimer:)
                                                                    userInfo:nil
                                                                     repeats:NO];
                    }
                    firstLevel.goku.performingAnAction = YES;
                }
            }
        }else{
            if(!secondLevel.goku.isDead){
                if(((abs(location.x - secondLevel.goku.position.x) < 30)&&(location.y > secondLevel.goku.position.y))&&(!secondLevel.goku.hasTransformed)){
                    [secondLevel.goku transformToSuperSaiyan:[[NSNumber alloc] initWithInt:1]];
                }else{
                    if([secondLevel.goku oneBallIsNil] && !secondLevel.goku.isTransforming){
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
}

-(void)handleTimer: (NSTimer *) timer{
    // still presssed down, start charging goku
    NSArray* currentFrames;
    if(self.levelIndicator == 1){
        if([firstLevel.goku oneBallIsNil]){
            firstLevel.goku.performingAnAction = YES;
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
            secondLevel.goku.performingAnAction = YES;
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
        
        SKNode *node = [self nodeAtPoint:location];
        if([node isEqual:pauseButton]){
            [self handlePauseButtonPress];
        }else if([node isEqual:mainMenu]){
            [self.delegate mySceneDidFinish:self];
        }else if([node isEqual:firstLevel.minion1]){
            firstLevel.goku.isAttacking = YES;
            if([firstLevel.minion1 checkEligibilityForAttackWith:firstLevel.goku])
            {
                //firstLevel.minion1.velocity = CGPointMake(-3,0);
                firstLevel.goku.performingAnAction = YES;
                firstLevel.goku.isAttacking = YES;
                [firstLevel.goku animateAttack];
            }
        }else if([node isEqual:firstLevel.minion2]){
            if([firstLevel.minion2 checkEligibilityForAttackWith:firstLevel.goku])
            {
                //firstLevel.minion2.velocity = CGPointMake(-3,0);
                firstLevel.goku.isAttacking = YES;
                [firstLevel.goku animateAttack];
            }
        }else if([node isEqual:firstLevel.minion3]){
            [firstLevel.minion3 checkEligibilityForAttackWith:firstLevel.goku];
        }else if([node isEqual:firstLevel.minion4]){
            [firstLevel.minion4 checkEligibilityForAttackWith:firstLevel.goku];
        }else if([node isEqual:firstLevel.minion5]){
            [firstLevel.minion5 checkEligibilityForAttackWith:firstLevel.goku];
        }else if([node isEqual:firstLevel.minion6]){
            [firstLevel.minion6 checkEligibilityForAttackWith:firstLevel.goku];
        }else if ([node isEqual:firstLevel.finalBoss]){
            [firstLevel.finalBoss checkEligibilityForAttackWith:firstLevel.goku];
        }else{
            [firstLevel handleTapGestureWithLocation:location andDirection:direction];
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

-(void)handleEnd:(NSTimer*)timer{
    if(self.levelIndicator == 1){
        if(![firstLevel.goku.releaseTimer isValid])
            firstLevel.goku.performingAnAction = NO;
    }else{
    //    secondLevel.goku.performingAnAction = NO;
    }
    //[timer invalidate];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSDate *end = [NSDate date];
    float beg = [start timeIntervalSinceNow];
    float fin = [end timeIntervalSinceNow];
    start = nil; end = nil;
    float difference = fin - beg;
    
    // kills timer so blast isnt shot
    [pressTimer invalidate];
    
    endTimer = [NSTimer scheduledTimerWithTimeInterval: .25
                                                target:self
                                                selector:@selector(handleEnd:)
                                                userInfo:nil
                                                 repeats:NO];


    // for touches:
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self]; // get location
        NSInteger direction = 0; // init direction
        
        if(self.levelIndicator == 1){
            if(!firstLevel.goku.isDead){
                if([firstLevel.goku.transformTimer isValid]){
                    [firstLevel.goku.transformTimer invalidate];
                    [firstLevel.goku removeActionForKey:@"goku_transformation"];
                }
                if(location.x > firstLevel.goku.position.x +10){
                    firstLevel.goku.lastDirection = @"right";
                    direction = 1;
                }else{
                    firstLevel.goku.lastDirection = @"left";
                    direction = -1;
                }
            }
        }else{
            if(!secondLevel.goku.isDead){
                if([secondLevel.goku.transformTimer isValid]){
                    [secondLevel.goku.transformTimer invalidate];
                }
                if(location.x > secondLevel.goku.position.x +10){
                    secondLevel.goku.lastDirection = @"right";
                    direction = 1;
                }else{
                    secondLevel.goku.lastDirection = @"left";
                    direction = -1;
                }
            }
        }

        if(difference < .5){ // was a tap
            [self handleTapMovementAtLocation:location inDirection:direction];

            
        }else if (difference >= .5){ // not a tap
            if(self.levelIndicator == 1){
                if(!firstLevel.goku.isTransforming && !firstLevel.goku.isDead){
                    [firstLevel.goku setUpPowerBalls:difference onScene:self];
                }
            }else{
                if(!secondLevel.goku.isTransforming && !secondLevel.goku.isDead){
                    [secondLevel.goku setUpPowerBalls:difference onScene:self];
                }
            }
        }
        
        
        if(self.levelIndicator == 1){
            if(firstLevel.goku.isTransforming)
                firstLevel.goku.isTransforming = NO;
        }else{
            if(secondLevel.goku.isTransforming)
                secondLevel.goku.isTransforming = NO;
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
