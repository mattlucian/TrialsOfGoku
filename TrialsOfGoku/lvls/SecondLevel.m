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

- (instancetype)init{
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
        self.minion1 = [self.minion1 setUpMinionWithName:@"minion21"]; //new minions
        [self.minion1 setUpHealthBar];
        self.minion2 = [[Minion2 alloc] init];
        self.minion2 = [self.minion2 setUpMinionWithName:@"minion22"];
        [self.minion2 setUpHealthBar];
        self.minion3 = [[Minion2 alloc] init];
        self.minion3 = [self.minion3 setUpMinionWithName:@"minion23"];
        [self.minion3 setUpHealthBar];
        self.minion4 = [[Minion2 alloc] init];
        self.minion4 = [self.minion4 setUpMinionWithName:@"minion24"];
        [self.minion4 setUpHealthBar];
        self.minion5 = [[Minion2 alloc] init];
        self.minion5 = [self.minion5 setUpMinionWithName:@"minion25"];
        [self.minion5 setUpHealthBar];
        self.minion6 = [[Minion2 alloc] init];
        self.minion6 = [self.minion6 setUpMinionWithName:@"minion26"];
        [self.minion6 setUpHealthBar];

        self.beginningOfLevel = YES;
        
        

        
#pragma mark Set Up Buu
        self.finalBoss = [[Buu alloc] init];
        self.finalBoss = [self.finalBoss setUpBuu];
        self.finalBoss.position = CGPointMake(4500, 60);
        [self.finalBoss setUpHealthBar];
#pragma setupMusic
        [self setupMusic];
    }
    return self;
}

-(void)setUpLevelForScene:(SKScene *)scene{
    
    self.minion1.position = CGPointMake(1000,60);
    self.minion1.isActivated = YES;
    self.minion2.position = CGPointMake(1600,60);
    self.minion3.position = CGPointMake(2000,60);
    self.minion4.position = CGPointMake(2700,60);
    self.minion5.position = CGPointMake(3700,60);
    self.minion6.position = CGPointMake(4200, 60);
    
    self.finalBoss.position = CGPointMake(self.goku.position.x + 3000, 60);
    
    [scene addChild:self.background1];
    [scene addChild:self.background2];
    [scene addChild:self.minion1];
    [scene addChild:self.minion2];
    [scene addChild:self.minion3];
    [scene addChild:self.minion4];
    [scene addChild:self.minion5];
    [scene addChild:self.minion6];
    [scene addChild:self.goku];
    [scene addChild:self.goku.healthBar];
    
}

-(void)handleMinionCollisions:(SKPhysicsContact *)contact{
    if(self.minion1 != nil) {
        if(self.minion1.isActivated){
            if(!self.minion1.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion21"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion1 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion21"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion1 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion2 != nil) {
        if(self.minion2.isActivated){
            if(!self.minion2.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion22"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion2 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion22"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion2 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion3 != nil) {
        if(self.minion3.isActivated){
            if(!self.minion3.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion23"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion3 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion23"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion3 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    
    if(self.minion4 != nil) {
        if(self.minion4.isActivated){
            if(!self.minion4.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion24"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion4 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion24"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion4 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion5 != nil) {
        if(self.minion5.isActivated){
            if(!self.minion5.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion25"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion5 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion25"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion5 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    if(self.minion6 != nil) {
        if(self.minion6.isActivated){
            if(!self.minion6.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"minion26"] && [nodeNames containsObject:@"ball1"]) {
                    [self.minion6 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"minion26"] && [nodeNames containsObject:@"ball2"]) {
                    [self.minion6 handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
}

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
            
            break;
            
            // not beginning of level anymore
        case 1:
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            
            if(!self.minion2.isActivated)
                self.minion2.isActivated = YES;
            
            if(!self.minion3.isActivated)
                self.minion3.isActivated = YES;
            break;
            
        case 2:
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            
            break;
            
            
            // not end of level anymore
        case 3:
            
            if(self.goku.rightLock)
                self.goku.rightLock = NO;
            
            if(!self.minion4.isActivated)
                self.minion4.isActivated = YES;
            
            if(!self.minion5.isActivated)
                self.minion5.isActivated = YES;
                
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
            
            if(!self.minion6.isActivated)
                self.minion6.isActivated = YES;

            if(!self.finalBoss.isActivated)
                self.finalBoss.isActivated = YES;
            
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
    
    if(!self.finalBoss.isActivated && (self.minion1.isDead && self.minion2.isDead && self.minion3.isDead && self.minion4.isDead)){
        self.finalBoss.isActivated = true;
        self.finalBoss.position = CGPointMake(self.goku.position.x+700,60);
        [scene addChild:self.finalBoss];
        [scene addChild:self.finalBoss.healthBar];
    }

    [self spawnObstaclesAndCheckLevelBoundaries:scene];
    
    [self.goku spawnAndMoveBallsAlongScene:scene bgIsMoving:self.bgIsMoving];
    [self.goku moveGoku]; // also moves background
    
    // Only 4 minions
    if(self.minion1 != nil)
        [self.minion1 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:2.5];
    if(self.minion2 != nil)
        [self.minion2 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:2.8];
    if(self.minion3 != nil)
        [self.minion3 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:3.0];
    if(self.minion4 != nil)
        [self.minion4 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:3.3];
    if(self.finalBoss != nil)
        [self.finalBoss moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:3.6];
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
    
    // obstacle collisions excluded for lvl 2
    
    // goku collisions
    [self handleGokuCollision:contact];

    
}

#pragma handleObstacleCollisions
-(void)handleObstacleCollisions:(SKPhysicsContact *) contact{
    // do nothing because we disabled obstacles
}
-(void)handleCollisionEnd:(SKPhysicsContact *)contact{
    // do nothing because we disabled obstacles
}
-(void)moveObstacles{
    // do nothing because we disabled obstacles
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
        if ([nodeNames containsObject:@"minion21"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion1.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion22"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion2.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion23"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion3.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion24"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion4.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion25"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion5.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"minion26"] && [nodeNames containsObject:@"goku"]) {
            if(!self.minion6.isDead)
                [self.goku handleHitByMinion:contact isBoss:NO];
        }else if ([nodeNames containsObject:@"buu"] && [nodeNames containsObject:@"goku"]) {
            if(!self.finalBoss.isDead)
                [self.goku handleHitByMinion:contact isBoss:YES];
        }
    }
    
}


@end
