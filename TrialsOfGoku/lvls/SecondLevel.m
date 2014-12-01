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
        self.minion1 = [self.minion1 setUpMinionWithName:@"minion1"]; //new minions
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

-(void)spawnObstaclesAndCheckLevelBoundaries:(GameScene*)scene{
    switch (self.currentLevelLocation) {
            // very beginning of level
        case -1:
            if(!self.goku.leftLock)
                self.goku.leftLock = YES;
            break;
            
            // beginning of level approaching
        case 0:
            if(((self.background1.position.x < (scene.view.bounds.size.width/2))
                &&((self.background1.position.x < scene.view.bounds.size.width)&&(self.background1.position.x > 0)))
               ||((self.background2.position.x < (scene.view.bounds.size.width/2))
                  &&((self.background2.position.x < scene.view.bounds.size.width)&&(self.background2.position.x > 0))))
            {
                if(self.goku.leftLock)
                    self.goku.leftLock = NO;
            }
            
            if(!self.obstacle1.isActivated){
                self.obstacle1 = [[SafeObstacle alloc] init];
                self.obstacle1 = [self.obstacle1 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle1];
            }
            
            break;
            
            // not beginning of level anymore
        case 1:
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            
            if(!self.obstacle2.isActivated){
                self.obstacle2 = [[SafeObstacle alloc] init];
                self.obstacle2 = [self.obstacle2 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle2];
            }
            break;
            
        case 2:
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            
            if(!self.obstacle3.isActivated){
                self.obstacle3 = [[SafeObstacle alloc] init];
                self.obstacle3 = [self.obstacle3 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle3];
            }
            break;
            
            
            // not end of level anymore
        case 3:
            
            if(self.goku.rightLock)
                self.goku.rightLock = NO;
            
            if(!self.obstacle4.isActivated){
                self.obstacle4 = [[SafeObstacle alloc] init];
                self.obstacle4 = [self.obstacle4 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle4];
            }
            if(!self.obstacle5.isActivated){
                self.obstacle5 = [[SafeObstacle alloc] init];
                self.obstacle5 = [self.obstacle5 setUpObstacleAtPoint:CGPointMake(1200, 60)];
                [scene addChild:self.obstacle5];
            }
            
            break;
            
            // end of level approaching
        case 4:
            if(((self.background1.position.x > (scene.view.bounds.size.width/2)) && (self.background1.position.x < scene.view.bounds.size.width)) ||
               ((self.background2.position.x > (scene.view.bounds.size.width/2)) && (self.background2.position.x < scene.view.bounds.size.width)))
            {
                if(self.goku.rightLock){
                    self.goku.rightLock = NO;
                }
            }
            break;
            
            // very end of level
        case 5:
            if(!self.goku.rightLock)
                self.goku.rightLock = YES;
            break;
            
        default:
            break;
    }
}

-(void)runLevelFor:(GameScene*)scene{
    
    // spawns obstacles at proper times
    [self spawnObstaclesAndCheckLevelBoundaries:scene];

        
    if(!self.finalBoss.isActivated && (self.minion1.isDead && self.minion2.isDead && self.minion3.isDead && self.minion4.isDead)){
        self.finalBoss.isActivated = true;
        self.finalBoss.position = CGPointMake(self.goku.position.x+700,60);
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
    
    // obstacle collisions
    [self handleObstacleCollisions:contact];
    
    // goku collisions
    [self handleGokuCollision:contact];

    
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
