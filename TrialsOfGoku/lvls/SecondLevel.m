//
//  FirstLevel.m
//  trialsofgoku
//
//  Created by Matt on 11/16/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "SecondLevel.h"
@import AVFoundation;

@implementation SecondLevel
{
    NSTimer *enemyHitTimer; // pauses the enemy when hit
    BOOL ballSpawnFlag;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
#pragma mark Initial Set Up
        ballSpawnFlag = NO;
        self.currentLevelLocation = 0;
        
#pragma mark Set Up Background
        self.background1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bg2"] size:[[UIScreen mainScreen] bounds].size];
        self.background1.position = CGPointMake( CGRectGetMidX([[UIScreen mainScreen] bounds]) , CGRectGetMidY([[UIScreen mainScreen] bounds]));
        self.background2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bg2"] size:[[UIScreen mainScreen] bounds].size];
        self.background2.position = CGPointMake( CGRectGetMidX([[UIScreen mainScreen] bounds])+self.background2.frame.size.width , CGRectGetMidY([[UIScreen mainScreen] bounds]));
        
#pragma mark Set Up Goku
        self.goku = [[Goku alloc] init];
        self.goku = [self.goku setUpGokuForLevel:2]; self.goku.leftLock = NO; self.goku.rightLock = NO;
        [self.goku setUpHealthBar];
        self.goku.delegate = self;  // passes back move background object
        
#pragma mark Set Up Minions
        self.minion1 = [[Minion2 alloc] init];
        self.minion1 = [self.minion1 setUpMinionWithName:@"minion1"];
        [self.minion1 setUpHealthBar];
        self.minion2 = [[Minion2 alloc] init];
        self.minion2 = [self.minion2 setUpMinionWithName:@"minion2"];
        [self.minion2 setUpHealthBar];
        self.minion3 = [[Minion2 alloc] init];
        self.minion3 = [self.minion3 setUpMinionWithName:@"minion3"];
        [self.minion3 setUpHealthBar];
        self.minion4 = [[Minion2 alloc] init];
        self.minion4 = [self.minion4 setUpMinionWithName:@"minion4"];
        [self.minion4 setUpHealthBar];
        self.beginningOfLevel = YES;
        
#pragma mark Set Up Buu
        self.finalBoss = [[Buu alloc] init];
        self.finalBoss = [self.finalBoss setUpBuu];
        [self.finalBoss setUpHealthBar];
#pragma setupMusic
        [self setupMusic];
    }
    return self;
}


-(void)setUpLevelForScene:(SKScene *)scene{
    
    self.minion1.position = CGPointMake(1000,60);
    self.minion2.position = CGPointMake(1600,60);
    self.minion3.position = CGPointMake(2000,60);
    self.minion4.position = CGPointMake(2600,60);
    
    self.finalBoss.position = CGPointMake(self.goku.position.x + 3000, 60);
    
    [scene addChild:self.background1];
    [scene addChild:self.background2];
    [scene addChild:self.goku];
    [scene addChild:self.goku.healthBar];
    
}

-(void)runLevelFor:(SKScene*)scene{
    
    switch (self.currentLevelLocation) {  // activates enemies at necessary times
            // very beginning of level, dont add anything here
        case -1:
            if(!self.goku.leftLock)
                self.goku.leftLock = YES;
            break;
            
        case 0:
            if(((self.background1.position.x >= ((scene.view.bounds.size.width/2))) &&
                (self.background1.position.x < scene.view.bounds.size.width))       ||
               ((self.background2.position.x >= (scene.view.bounds.size.width/2))   &&
                (self.background2.position.x < scene.view.bounds.size.width)))
            {
                if(!self.goku.leftLock)
                    self.goku.leftLock = YES;
            }else if(((self.background1.position.x < ((scene.view.bounds.size.width/2))) &&
                      (self.background1.position.x < scene.view.bounds.size.width))       ||
                     ((self.background2.position.x < (scene.view.bounds.size.width/2))   &&
                      ((self.background2.position.x < scene.view.bounds.size.width)&&(self.background2.position.x > 0))))
            {
                if(self.goku.leftLock)
                    self.goku.leftLock = NO;
            }
            //minion 1
            if (!self.minion1.isActivated) {
                self.minion1.isActivated=true;
                [scene addChild:self.minion1];
                [scene addChild:self.minion1.healthBar];
            }
            if(!self.obstacle1.isActivated){
                self.obstacle1 = [[SafeObstacle alloc] init];
                self.obstacle1 = [self.obstacle1 setUpObstacleAtPoint:CGPointMake(400, 60)];
                [scene addChild:self.obstacle1];
            }

            break;
            
        case 1:
            //minion 2
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            
            if(!self.minion2.isActivated){
                self.minion2.isActivated = true;
                [scene addChild:self.minion2];
                [scene addChild:self.minion2.healthBar];
            }
            //minion 3
            if(!self.minion3.isActivated)
            {
                self.minion3.isActivated = true;
                [scene addChild:self.minion3];
                [scene addChild:self.minion3.healthBar];
            }
            if(!self.obstacle2.isActivated){
                self.obstacle2 = [[SafeObstacle alloc] init];
                self.obstacle2 = [self.obstacle2 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                self.obstacle2.xScale = -1;
                [scene addChild:self.obstacle2];
            }
            if(!self.obstacle3.isActivated){
                self.obstacle3 = [[SafeObstacle alloc] init];
                self.obstacle3 = [self.obstacle3 setUpObstacleAtPoint:CGPointMake(1700, 60)];
                [scene addChild:self.obstacle3];
            }



            break;
            
        case 2:
            
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            //minion4
            if(!self.minion4.isActivated){
                self.minion4.isActivated = true;
                [scene addChild:self.minion4];
                [scene addChild:self.minion4.healthBar];
            }
                if(!self.obstacle4.isActivated){
                self.obstacle4 = [[SafeObstacle alloc] init];
                self.obstacle4 = [self.obstacle4 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle4];
            }
            if(!self.obstacle5.isActivated){
                self.obstacle5 = [[SafeObstacle alloc] init];
                self.obstacle5 = [self.obstacle5 setUpObstacleAtPoint:CGPointMake(1400, 60)];
                [scene addChild:self.obstacle5];
            }
            if(!self.obstacle6.isActivated){
                self.obstacle6 = [[SafeObstacle alloc] init];
                self.obstacle6 = [self.obstacle6 setUpObstacleAtPoint:CGPointMake(1700, 60)];
                [scene addChild:self.obstacle6];
            }
            if(!self.obstacle7.isActivated){
                self.obstacle7 = [[SafeObstacle alloc] init];
                self.obstacle7 = [self.obstacle7 setUpObstacleAtPoint:CGPointMake(1800, 60)];
                [scene addChild:self.obstacle7];
            }

            
            break;
            
        case 3:
            
            if(self.goku.rightLock)
                self.goku.rightLock = NO;
            
            if(!self.obstacle8.isActivated){
                self.obstacle8 = [[SafeObstacle alloc] init];
                self.obstacle8 = [self.obstacle8 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle8];
            }
            if(!self.obstacle9.isActivated){
                self.obstacle9 = [[SafeObstacle alloc] init];
                self.obstacle9 = [self.obstacle9 setUpObstacleAtPoint:CGPointMake(1700, 60)];
                [scene addChild:self.obstacle9];
            }
            break;
            
            
        case 4:
            if(((self.background1.position.x <= ((scene.view.bounds.size.width/2))) &&
                (self.background1.position.x > scene.view.bounds.size.width))       ||
               ((self.background2.position.x <= (scene.view.bounds.size.width/2))   &&
                (self.background2.position.x > scene.view.bounds.size.width)))
            {
                if(!self.goku.rightLock)
                    self.goku.rightLock = YES;
            }else if(self.background1.position.x > ((scene.view.bounds.size.width/2))){
                if(self.goku.rightLock)
                    self.goku.rightLock = NO;
            }
            if(!self.obstacle10.isActivated){
                self.obstacle10= [[SafeObstacle alloc] init];
                self.obstacle10 = [self.obstacle10 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle10];
            }
            
            break;
            
            // very end of level, dont add anything here
        case 5:
            if(!self.goku.rightLock)
                self.goku.rightLock = YES;
            break;
            
        default:
            break;
            
    }
    
    if(!self.finalBoss.isActivated && (self.minion1.isDead && self.minion2.isDead && self.minion3.isDead && self.minion4.isDead)){
        self.finalBoss.isActivated = true;
        self.finalBoss.position = CGPointMake(self.goku.position.x+550,60);
        [scene addChild:self.finalBoss];
        [scene addChild:self.finalBoss.healthBar];
    }

    
    
    [self.goku spawnAndMoveBallsAlongScene:scene];
    [self.goku moveGoku]; // also moves background
    
    // Only 4 minions
    if(self.minion1 != nil)
        [self.minion1 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    if(self.minion2 != nil)
        [self.minion2 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    if(self.minion3 != nil)
        [self.minion3 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    if(self.minion4 != nil)
        [self.minion4 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    if(self.finalBoss != nil)
        [self.finalBoss moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
}

-(void)handleBossCollisions:(SKPhysicsContact *)contact
{
    // final boss collisions
    if(self.finalBoss != nil) {
        if(self.finalBoss.isActivated){
            if(!self.finalBoss.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"boss"] && [nodeNames containsObject:@"ball1"]) {
                    [self.finalBoss handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"boss"] && [nodeNames containsObject:@"ball2"]) {
                    [self.finalBoss handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    
    // minion collisions
    [self handleMinionCollisions:contact];
    
}
- (void) setupMusic
{
    NSString *musicPath = [[NSBundle mainBundle]
                           pathForResource:@"buu_dub" ofType:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:NULL];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    self.backgroundMusicPlayer.volume = .2;
    [self.backgroundMusicPlayer play];
}


@end
