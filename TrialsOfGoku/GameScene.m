//
//  MyScene.m
//  SonOfGoku
//
//  Created by Matt on 10/20/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "GameScene.h"
#import "Globals.h"
#import "Goku.h"
#import "PowerBall.h"
#import "Buu.h"
#import "Minion.h"
#import "FirstLevel.h"


@implementation GameScene
{
    Goku * goku;            // hero object
    PowerBall* ball;        // powerball 1
    PowerBall* ball2;       // poewrball 2
    SKSpriteNode* bg1;      // background 1
    SKSpriteNode* bg2;      // background 2
    Buu* buu;               // Buu enemy
    Minion* minion;         // Minion object
                            // possibly add a second minion object
    FirstLevel* firstLevel;
    
    
    SKLabelNode *myLabel;   // debugging
    
    NSInteger levelScore;   // keeps track of level score
    BOOL bgisMoving;        // keeps track of background movement
    NSArray *currentFrames; // animation frame holder
    NSDate *start;          // start timer
    NSTimer *pressTimer;    // tracks how long user holds down tap
    NSTimer *enemyHitTimer; // pauses the enemy when hit
}


#pragma mark Main Update Method
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [goku moveGoku];
    [self moveBall];
    [self moveEnemies];
    [firstLevel runLevelFor:self];
    //NSLog([NSString stringWithFormat:@"%f",goku.position.x]);
}


#pragma mark Set-Up Methods
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // init variables
        bgisMoving = false;
        ball = nil;
        ball2 = nil;
        buu = nil;
        minion = nil;
        levelScore = 0;
        
        self.physicsWorld.gravity = CGVectorMake(0,0); // turn off gravities
        self.physicsWorld.contactDelegate = self; // set delegate for collision detection
        
        // create first level
        firstLevel = [[FirstLevel alloc] init];
        
        // create our goku object and set him up
        goku = [[Goku alloc] init];
        goku = [goku setUpGoku];
        
        // create our background images and set them up
        
        bg1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bg1"] size:[[UIScreen mainScreen] bounds].size];
        bg1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        bg2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bg1"] size:[[UIScreen mainScreen] bounds].size];
        bg2.position = CGPointMake(CGRectGetMidX(self.frame)+bg2.frame.size.width, CGRectGetMidY(self.frame)); // spawn off to side
        
        [self addChild:bg1]; // add to screen in this order..
        [self addChild:bg2];
        
        [firstLevel setUpLevelForScene:self];
        
        [self addChild:goku];
        
        // debugging
        myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];

    }
    return self;
}
-(void)setUpPowerBalls:(float)difference{
    NSInteger ballVelocity = 0;
    if([goku.lastDirection isEqualToString:@"right"]){
        currentFrames= [goku getAnimationFrames:@"goku_norm_ball_release_right"];
        ballVelocity = 4;
        [goku runCountedAnimation:currentFrames withCount:1 atFrequency:.5f withKey:@"goku_animation_key"];
    }else{
        currentFrames= [goku getAnimationFrames:@"goku_norm_ball_release_left"];
        ballVelocity = -4;
        [goku runCountedAnimation:currentFrames withCount:1 atFrequency:.5f withKey:@"goku_animation_key"];
    }

    if(ball == nil){
        ball = [[PowerBall alloc] init];
        NSArray* frames = [ball getFrames:@"powerball_small_left"]; // filler ball
        ball = [PowerBall spriteNodeWithTexture:frames[0]];
        [ball performSetupFor:difference atVelocity:ballVelocity inRelationTo:goku];
        ball.name = @"ball1";
        [self addChild:ball];
        
    }else if(ball2 == nil){
        ball2 = [[PowerBall alloc] init];
        NSArray* frames = [ball2 getFrames:@"powerball_small_left"]; // filler ball
        ball2 = [PowerBall spriteNodeWithTexture:frames[0]];
        [ball2 performSetupFor:difference atVelocity:ballVelocity inRelationTo:goku];
        ball2.name = @"ball2";
        [self addChild:ball2];
    }
}


#pragma mark Touch Handlers & Related Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    start = [NSDate date];
    if(ball == nil || ball2 == nil){
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
    if(ball == nil || ball2 == nil){
        [goku haltVelocity:@"X"];
        if([goku.lastDirection isEqualToString:@"right"]){
            currentFrames= [goku getAnimationFrames:@"goku_norm_ball_charge_right"];
            [goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
        }else if([goku.lastDirection isEqualToString:@"left"]){
            currentFrames= [goku getAnimationFrames:@"goku_norm_ball_charge_left"];
            [goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
        }
    }
}
-(void)handleTapMovementAtLocation:(CGPoint)location inDirection:(NSInteger)direction{
    if(location.x > (goku.position.x+30)){
        [goku increaseVelocity:@"X" addVelocity:direction];
        currentFrames = [goku getAnimationFrames:@"goku_norm_walk_right"];
    }
    else if(location.x < (goku.position.x-30)){
        [goku increaseVelocity:@"X" addVelocity:direction];
        currentFrames = [goku getAnimationFrames:@"goku_norm_walk_left"];
    }
    
    if(goku.velocity.x > 0){
        if([goku.lastDirection isEqualToString:@"left"]){
            [goku haltVelocity:@"x"];
        }
    }
    else if(goku.velocity.x < 0){
        if([goku.lastDirection isEqualToString:@"right"]){
            [goku haltVelocity:@"x"];
        }
    }
    
    // if tap was a jump
    if(location.y > goku.position.y+30 && goku.jumpCount < 2){
        goku.jumpCount++;
        goku.velocity = CGPointMake(goku.velocity.x,goku.velocity.y+6);
        if(direction > 0){
            currentFrames = [goku getAnimationFrames:@"goku_norm_jump_right"];
        }else if(direction < 0){
            currentFrames = [goku getAnimationFrames:@"goku_norm_jump_left"];
        }
    }
    // animate whatever we decided on
    [goku runAnimation:currentFrames atFrequency:.2f withKey:@"goku_animation_key"];
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

        // set direction
        if(location.x > goku.position.x +10){
            goku.lastDirection = @"right";
            direction = 1;
        }else{
            goku.lastDirection = @"left";
            direction = -1;
        }
        
        // if it was not held down for longer than .5, move Goku
        if(difference < .5){
            
            // handle tap movemnet
            [self handleTapMovementAtLocation:location inDirection:direction];
            
            // eventually add an attack if location = on enemy
            
            
         // if it was not a tap, and was held down... check how long and react
        }else if (difference >= .5){
            
            // create powerballs
            [self setUpPowerBalls:difference];
        }
    }
}


#pragma mark Move Methods
-(void)moveBall{
    // moves power balls if they are currently on screen.
    if(ball != nil){
        ball.position = CGPointMake(ball.position.x+ball.velocity.x, ball.position.y);
        if(((ball.position.x-40) > self.view.bounds.size.width)||((ball.position.x + 40 ) < 0 )){
            ball = nil; // set powerballs to nil when they go off the screen
        }
    }
    if(ball2 != nil){
        ball2.position = CGPointMake(ball2.position.x+ball2.velocity.x, ball2.position.y);
        if(((ball2.position.x - 40 ) > self.view.bounds.size.width)||((ball2.position.x + 40) < 0 )){
            ball2 = nil;
        }
    }
}
-(void)moveBackground{
    
    bgisMoving = true;
    
    // updates bg's position if they are currently on the screen
    if(bg1 != nil)
        bg1.position = CGPointMake(bg1.position.x-goku.velocity.x,bg1.position.y);
    
    if(bg2 != nil)
        bg2.position = CGPointMake(bg2.position.x-goku.velocity.x,bg2.position.y);
    
    // if goku is traveling right
    if(goku.velocity.x > 0){
        if((bg1.position.x+(bg1.size.width/2)) < 0){ // reset the background to the begining
            bg1.position = CGPointMake((bg2.position.x+(bg2.size.width)),bg1.position.y);
            firstLevel.currentLevelLocation += 1;
            myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
        }
        if((bg2.position.x+(bg2.size.width/2)) < 0){
            bg2.position = CGPointMake((bg1.position.x+(bg1.size.width)),bg2.position.y);
            firstLevel.currentLevelLocation += 1;
            myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
        }
    }else{ // else he's traveling left
        if((bg1.position.x-(bg1.size.width/2)) > self.view.bounds.size.width){
            bg1.position = CGPointMake((bg2.position.x-(bg2.size.width)),bg1.position.y);
            firstLevel.currentLevelLocation -= 1;
            myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
        }
        if((bg2.position.x-(bg2.size.width/2)) > self.view.bounds.size.width){
            bg2.position = CGPointMake((bg1.position.x-(bg1.size.width)),bg2.position.y);
            firstLevel.currentLevelLocation -= 1;
            myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
        }
    }
}
-(void)moveEnemies{
    if(firstLevel.finalBoss != nil){                 // all final bosses
        if(firstLevel.finalBoss.isActivated){
            if(!firstLevel.finalBoss.isDead){ // not dead
                if(!firstLevel.finalBoss.isHit){ // not hit
                    if(firstLevel.finalBoss.position.x > goku.position.x){ // buu to the right
                        if([firstLevel.finalBoss.lastDirection isEqualToString:@"right"]){
                            firstLevel.finalBoss.velocity = CGPointMake(-1,firstLevel.finalBoss.velocity.y);
                            firstLevel.finalBoss.lastDirection = @"left";
                        }
                    }else{ // buu to the left
                        if([firstLevel.finalBoss.lastDirection isEqualToString:@"left"]){
                            firstLevel.finalBoss.velocity = CGPointMake(1,firstLevel.finalBoss.velocity.y);
                            firstLevel.finalBoss.lastDirection = @"right";
                        }
                    }
                    if(bgisMoving)
                        firstLevel.finalBoss.position = CGPointMake(firstLevel.finalBoss.position.x+firstLevel.finalBoss.velocity.x- goku.velocity.x,firstLevel.finalBoss.position.y);
                    else
                        firstLevel.finalBoss.position = CGPointMake(firstLevel.finalBoss.position.x+firstLevel.finalBoss.velocity.x-(goku.velocity.x/50),firstLevel.finalBoss.position.y);
                }else{ // is hit
                    if(bgisMoving)
                        firstLevel.finalBoss.position = CGPointMake(firstLevel.finalBoss.position.x-goku.velocity.x,firstLevel.finalBoss.position.y);
                    else
                        firstLevel.finalBoss.position = CGPointMake(firstLevel.finalBoss.position.x,firstLevel.finalBoss.position.y);
                }
                
            }else{
                if(bgisMoving){
                    firstLevel.finalBoss.position = CGPointMake(firstLevel.finalBoss.position.x - goku.velocity.x, firstLevel.finalBoss.position.y);
                }
            }
        }
    }
    
    if(minion != nil){              // MINION
        if(minion.isActivated){
            if(!minion.isDead){
                if(minion.position.x > goku.position.x){ // minion to the right
                    if([minion.lastDirection isEqualToString:@"right"]){
                        minion.velocity = CGPointMake(-1,minion.velocity.y);
                        minion.lastDirection = @"left";
                    }
                }else{ // buu to the left
                    if([minion.lastDirection isEqualToString:@"left"]){
                        minion.velocity = CGPointMake(1,minion.velocity.y);
                        minion.lastDirection = @"right";
                    }
                }
                if(bgisMoving)
                    firstLevel.finalBoss.position = CGPointMake(firstLevel.finalBoss.position.x+firstLevel.finalBoss.velocity.x- goku.velocity.x,firstLevel.finalBoss.position.y);
                else
                    firstLevel.finalBoss.position = CGPointMake(firstLevel.finalBoss.position.x+firstLevel.finalBoss.velocity.x-(goku.velocity.x/50),firstLevel.finalBoss.position.y);
            }
        }
    }
}


#pragma mark Collision Detection
- (void)didBeginContact:(SKPhysicsContact *)contact{

    // buu collision detection
    if(firstLevel.finalBoss != nil) {
        if(firstLevel.finalBoss.isActivated){
            if(!firstLevel.finalBoss.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"buu"] && [nodeNames containsObject:@"ball1"]) {
                    
                    switch (ball.ball_size) {
                        case 1:
                            firstLevel.finalBoss.health -= 10;
                            break;
                        case 2:
                            firstLevel.finalBoss.health -= 20;
                            break;
                        case 3:
                            firstLevel.finalBoss.health -= 30;
                            break;
                    }
                    
                    if(firstLevel.finalBoss.health < 0){
                        firstLevel.finalBoss.isDead = true;
                        // animate death
                        NSMutableArray* deadFrame = [[NSMutableArray alloc] init];
                        [deadFrame insertObject:[SKTexture textureWithImageNamed:@"buu_deadfrom_right"]  atIndex:0];
                        [firstLevel.finalBoss runAnimation:deadFrame atFrequency:.2f withKey:@"final_boss_animation_key"]; // animate deaths
                        
                    }else{
                        // animate a hit
                        firstLevel.finalBoss.isHit = true;
                        enemyHitTimer= [NSTimer scheduledTimerWithTimeInterval: 1
                                                                      target:self
                                                                    selector:@selector(handleHit:)
                                                                    userInfo:nil
                                                                     repeats:NO];
                        
                        NSMutableArray* hitFrame = [[NSMutableArray alloc] init];
                        [hitFrame insertObject:[SKTexture textureWithImageNamed:@"buu_hitfrom_right_3"]  atIndex:0];
                        [firstLevel.finalBoss runCountedAnimation:hitFrame withCount:1 atFrequency:.5f withKey:@"final_boss_animation_key"];

                    }
                    
                }else if ([nodeNames containsObject:@"buu"] && [nodeNames containsObject:@"ball2"]) {
                    
                    // handle collision
                    firstLevel.finalBoss.isDead = true;
                    
                    // change texture in some other way
                    NSMutableArray* deadFrame = [[NSMutableArray alloc] init];
                    [deadFrame insertObject:[SKTexture textureWithImageNamed:@"buu_deadfrom_right"]  atIndex:0];
                    [firstLevel.finalBoss runAnimation:deadFrame atFrequency:.2f withKey:@"final_boss_animation_key"];
                    
                }
            }
        }
    }
    
    // minion collision detection
    
}


@end
