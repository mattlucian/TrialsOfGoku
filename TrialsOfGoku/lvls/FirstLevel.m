//
//  FirstLevel.m
//  trialsofgoku
//
//  Created by Matt on 11/16/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

// Level 1
// - Supports 4 minions
// - Supports 5 Obstacles

#import "FirstLevel.h"

@implementation FirstLevel
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
        self.goku = [self.goku setUpGokuForLevel:1]; self.goku.leftLock = NO; self.goku.rightLock = NO;
        [self.goku setUpHealthBar];
        self.goku.delegate = self;  // passes back move background object
        
        #pragma mark Set Up Minions
        self.minion1 = [[Minion alloc] init];
        self.minion1 = [self.minion1 setUpMinionWithName:@"minion1" andHealth:60 andPower:5];
        [self.minion1 setUpHealthBar];
        self.minion2 = [[Minion2 alloc] init];
        self.minion2 = [self.minion2 setUpMinionWithName:@"minion2" andHealth:80 andPower:7];
        [self.minion2 setUpHealthBar];
        self.minion3 = [[Minion alloc] init];
        self.minion3 = [self.minion3 setUpMinionWithName:@"minion3" andHealth:100 andPower:9];
        [self.minion3 setUpHealthBar];
        self.minion4 = [[Minion2 alloc] init];
        self.minion4 = [self.minion4 setUpMinionWithName:@"minion4" andHealth:120 andPower:11];
        [self.minion4 setUpHealthBar];
        self.minion5 = [[Minion alloc] init];
        self.minion5 = [self.minion5 setUpMinionWithName:@"minion5" andHealth:140 andPower:13];
        [self.minion5 setUpHealthBar];
        self.minion6 = [[Minion2 alloc] init];
        self.minion6 = [self.minion6 setUpMinionWithName:@"minion6" andHealth:160 andPower:15];
        [self.minion6 setUpHealthBar];

        
        self.beginningOfLevel = YES;
        
        self.realFinalBoss = [[Buu alloc] init];
        self.realFinalBoss = [self.realFinalBoss setUpBuu];
        [self.realFinalBoss setUpHealthBar];
        
        #pragma mark Set Up Cell
        self.finalBoss = [[Cell alloc] init];
        self.finalBoss = [self.finalBoss setUpCell];
        [self.finalBoss setUpHealthBar];
#pragma add music
        [self setupMusic];
    
    }
    return self;
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

-(void)setUpLevelForScene:(SKScene *)scene{
    
    
    self.finalBoss.position = CGPointMake(self.goku.position.x + 1000, 60);
    
    [scene addChild:self.background1];
    [scene addChild:self.background2];
    [scene addChild:self.goku];
    [scene addChild:self.goku.healthBar];

}

-(void)activateMinions:(GameScene*)scene{
    
    // minion 2
    if(!self.minion2.isActivated && self.minion1.isDead){
        self.minion2.position = CGPointMake(self.goku.position.x + 1000,60);
        self.minion2.isActivated = true;
        [scene addChild:self.minion2];
        [scene addChild:self.minion2.healthBar];
    }
    
    // minion 3
    if(!self.minion3.isActivated && self.minion2.isDead)
    {
        self.minion3.position = CGPointMake(self.goku.position.x + 1000,60);
        self.minion3.isActivated = true;
        [scene addChild:self.minion3];
        [scene addChild:self.minion3.healthBar];
    }
    
    //minion 4
    if(!self.minion4.isActivated && self.minion3.isDead){
        self.minion4.position = CGPointMake(self.goku.position.x + 1000, 60);
        self.minion4.isActivated = true;
        [scene addChild:self.minion4];
        [scene addChild:self.minion4.healthBar];
    }
    
    // final boss
    if(!self.finalBoss.isActivated && self.minion4.isDead){
        self.finalBoss.isActivated = true;
        self.finalBoss.position = CGPointMake(self.goku.position.x+720,60);
        [scene addChild:self.finalBoss];
        [scene addChild:self.finalBoss.healthBar];
    }

}

-(void)spawnObstaclesAndCheckLevelBoundaries:(GameScene*)scene{
    switch (self.currentLevelLocation) {
            // very beginning of level
        case -1:
            if(!self.goku.leftLock){
                self.goku.leftLock = YES;
                self.bgIsMoving = NO;
            }
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
            
            // minion 1
            if (!self.minion1.isActivated) {
                self.minion1.position = CGPointMake(self.goku.position.x + 1000, 60);
                self.minion1.isActivated=true;
                [scene addChild:self.minion1];
                [scene addChild:self.minion1.healthBar];
            }
            
            
            if(self.obstacle1 == nil){
                self.obstacle1.isActivated= YES;
                self.obstacle1 = [[SafeObstacle alloc] init];
                self.obstacle1 = [self.obstacle1 setUpObstacleAtPoint:CGPointMake(1200, 60) withName:@"rock1"];
                [scene addChild:self.obstacle1];
            }
            
            break;
            
            // not beginning of level anymore
        case 1:
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            
            if(!self.obstacle2.isActivated){
                self.obstacle2 = [[SafeObstacle alloc] init];
                self.obstacle2 = [self.obstacle2 setUpObstacleAtPoint:CGPointMake(1200, 60) withName:@"rock1"];
                [scene addChild:self.obstacle2];
            }
            
            // minion 2
            if (!self.minion2.isActivated) {
                self.minion2.position = CGPointMake(self.goku.position.x + 1000, 60);
                self.minion2.isActivated=true;
                [scene addChild:self.minion2];
                [scene addChild:self.minion2.healthBar];
            }
            

            
            
            break;
            
        case 2:
            if(self.goku.leftLock)
                self.goku.leftLock = NO;
            
            if(!self.obstacle3.isActivated){
                self.obstacle3 = [[SafeObstacle alloc] init];
                self.obstacle3 = [self.obstacle3 setUpObstacleAtPoint:CGPointMake(1200, 60) withName:@"rock1"];
                [scene addChild:self.obstacle3];
            }
            
            // minion 1
            if (!self.minion3.isActivated) {
                self.minion3.position = CGPointMake(self.goku.position.x + 1000, 60);
                self.minion3.isActivated=true;
                [scene addChild:self.minion3];
                [scene addChild:self.minion3.healthBar];
            }
            
            // minion 2
            if (!self.minion4.isActivated) {
                self.minion4.position = CGPointMake(self.goku.position.x + 1600, 60);
                self.minion4.isActivated=true;
                [scene addChild:self.minion4];
                [scene addChild:self.minion4.healthBar];
            }

            
            break;

            
            // not end of level anymore
        case 3:
            
            if(self.goku.rightLock)
                self.goku.rightLock = NO;
            
            if(!self.obstacle4.isActivated){
                self.obstacle4 = [[SafeObstacle alloc] init];
                self.obstacle4 = [self.obstacle4 setUpObstacleAtPoint:CGPointMake(1200, 60) withName:@"rock1"];
                [scene addChild:self.obstacle4];
            }
            if(!self.obstacle5.isActivated){
                self.obstacle5 = [[SafeObstacle alloc] init];
                self.obstacle5 = [self.obstacle5 setUpObstacleAtPoint:CGPointMake(1800, 60)withName:@"rock1"];
                [scene addChild:self.obstacle5];
            }

            
            // minion 1
            if (!self.minion5.isActivated) {
                self.minion5.position = CGPointMake(self.goku.position.x + 1000, 60);
                self.minion5.isActivated=true;
                [scene addChild:self.minion5];
                [scene addChild:self.minion5.healthBar];
            }
            
            // minion 2
            if (!self.minion6.isActivated) {
                self.minion6.position = CGPointMake(self.goku.position.x + 1600, 60);
                self.minion6.isActivated=true;
                [scene addChild:self.minion6];
                [scene addChild:self.minion6.healthBar];
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
            if(!self.goku.rightLock){
                self.bgIsMoving = NO;
                self.goku.rightLock = YES;
            }
            break;
            
        default:
            break;
    }
}

-(void)runLevelFor:(GameScene*)scene{
    
    // activates mininos
  //  [self activateMinions:scene];
    
    // minion 2
    if (!self.finalBoss.isActivated && (self.minion1.isDead && self.minion2.isDead && self.minion3.isDead && self.minion4.isDead && self.minion5.isDead && self.minion6.isDead)) {
        [self changeMusic];
        self.finalBoss.position = CGPointMake(self.goku.position.x + 1200, 60);
        self.finalBoss.isActivated=true;
        [scene addChild:self.finalBoss];
        [scene addChild:self.finalBoss.healthBar];
    }

    
    if(self.finalBoss.isDead && !self.realFinalBoss.isActivated){
        self.realFinalBoss.isActivated = YES;
        self.realFinalBoss.position = CGPointMake(self.goku.position.x + 1200, 60);
        [scene addChild:self.realFinalBoss];
        [scene addChild:self.realFinalBoss.healthBar];

        //scene.levelIndicator = 2;
    }

    // spawns obstacles at proper times
    [self spawnObstaclesAndCheckLevelBoundaries:scene];
    
    // if balls exist, spawn and move them
    [self.goku spawnAndMoveBallsAlongScene:scene bgIsMoving:self.bgIsMoving];
    
    [self.goku moveGoku]; // also moves background
    
    // Only 4 minions
    if(self.minion1 != nil)
        [self.minion1 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:2.0];
    if(self.minion2 != nil)
        [self.minion2 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:2.2];
    if(self.minion3 != nil)
        [self.minion3 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:2.3];
    if(self.minion4 != nil)
        [self.minion4 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:2.7];

    if(self.minion5 != nil)
        [self.minion5 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:3.0];
    if(self.minion6 != nil)
        [self.minion6 moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:3.2];
    
    if(self.finalBoss != nil)
        [self.finalBoss moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:3.5];
    if(self.realFinalBoss != nil)
        [self.realFinalBoss moveInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving withVelocity:3.5];

}

-(void)handleBossCollisions:(SKPhysicsContact *)contact{
    // final boss collisions
    if(self.finalBoss != nil) {
        if(self.finalBoss.isActivated){
            if(!self.finalBoss.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"cell"] && [nodeNames containsObject:@"ball1"]) {
                    [self.finalBoss handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"cell"] && [nodeNames containsObject:@"ball2"]) {
                    [self.finalBoss handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }
            }
        }
    }
    
    if(self.realFinalBoss != nil) {
        if(self.realFinalBoss.isActivated){
            if(!self.realFinalBoss.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"buu"] && [nodeNames containsObject:@"ball1"]) {
                    [self.realFinalBoss handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
                }else if ([nodeNames containsObject:@"buu"] && [nodeNames containsObject:@"ball2"]) {
                    [self.realFinalBoss handleCollisionWithGoku:self.goku attackTypeIsPowerBall:YES];
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

-(void)handleObstacleCollisions:(SKPhysicsContact *) contact{
    NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
    if ([nodeNames containsObject:@"rock1"] && [nodeNames containsObject:@"goku"]) {
        if(!self.goku.isCollidingWithObstacle){
            NSLog(@"collision");
            float difference = contact.bodyA.node.position.x - contact.bodyB.node.position.x;
            if([contact.bodyA.node.name isEqualToString:@"goku"]){
                if([contact.bodyB.node isEqual:self.obstacle1]){
                    NSLog(@"obstacle 1");
                }else if([contact.bodyB.node isEqual:self.obstacle2]){
                    NSLog(@"obstacle 2");
                }else if([contact.bodyB.node isEqual:self.obstacle3]){
                    NSLog(@"obstacle 3");
                }else if([contact.bodyB.node isEqual:self.obstacle4]){
                    NSLog(@"obstacle 4");
                }else if([contact.bodyB.node isEqual:self.obstacle5]){
                    NSLog(@"obstacle 5");
                }
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
            
            
            NSLog(@"contactB %s \n",contact.bodyB.node.name.UTF8String);
            NSLog(@"contactA %s \n",contact.bodyA.node.name.UTF8String);
            if(abs(contact.bodyA.node.position.y - contact.bodyB.node.position.y) > 30)
                self.goku.fallingLock = YES;
            self.goku.isCollidingWithObstacle = YES;
            [self.goku.delegate moveBackground:NO inRelationTo:self.goku];
        }
    }
}

-(void)handleCollisionEnd:(SKPhysicsContact *)contact {
    NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
    if ([nodeNames containsObject:@"rock1"] && [nodeNames containsObject:@"goku"]) {
        self.goku.obstacleRightLock = NO;
        self.goku.obstacleLeftLock = NO;
        self.goku.isCollidingWithObstacle = NO;
        self.goku.fallingLock = NO;
        self.goku.jumpCount++;
    }
    
}

-(void)moveObstacles{
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
}

-(void)setupMusic{
    NSString *musicPath = [[NSBundle mainBundle]
                           pathForResource:@"RockTheDragon" ofType:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:NULL];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    self.backgroundMusicPlayer.volume = .5;
    [self.backgroundMusicPlayer play];
}

-(void)killFirstLevel{
    if(self.minion1 != nil){
        [self.minion1 removeFromParent];
        self.minion1 = nil;
    }
    if(self.minion2 != nil){
        [self.minion2 removeFromParent];
        self.minion2 = nil;
    }
    
    if(self.minion3 != nil){
        [self.minion3 removeFromParent];
        self.minion3 = nil;
    }
    if(self.minion4 != nil){
        [self.minion4 removeFromParent];
        self.minion4 = nil;
    }
    if(self.obstacle1 != nil){
        self.obstacle1.physicsBody = nil;
        self.obstacle1.position = CGPointMake(500, -200);
        [self.obstacle1 removeFromParent];
        self.obstacle1 = nil;
    }
    if(self.obstacle2 != nil){
        self.obstacle2.position = CGPointMake(500, -200);
        [self.obstacle2 removeFromParent];
        self.obstacle2 = nil;
    }
    if(self.obstacle3 != nil){
        [self.obstacle3 removeFromParent];
        self.obstacle3 = nil;
    }
    if(self.obstacle4 != nil){
        [self.obstacle4 removeFromParent];
        self.obstacle4 = nil;
    }
    if(self.obstacle5 != nil){
        [self.obstacle5 removeFromParent];
        self.obstacle5 = nil;
    }
    if(self.finalBoss != nil){
        [self.finalBoss removeFromParent];
        self.finalBoss = nil;
    }
    if(self.background1 != nil){
        [self.background1 removeFromParent];
        self.background1 = nil;
    }
    if(self.background2 != nil){
        [self.background2 removeFromParent];
        self.background2 = nil;
    }
    
    if(self.backgroundMusicPlayer != nil){
        [self.backgroundMusicPlayer stop];
        self.backgroundMusicPlayer = nil;
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
    if(self.realFinalBoss != nil){
        [self.realFinalBoss runAction:[SKAction unhide]];
        [self.realFinalBoss.healthBar runAction:[SKAction unhide]];
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
    if(self.realFinalBoss != nil){
        [self.realFinalBoss runAction:[SKAction hide]];
        [self.realFinalBoss.healthBar runAction:[SKAction hide]];
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
        }else if ([nodeNames containsObject:@"cell"] && [nodeNames containsObject:@"goku"]) {
            if(!self.finalBoss.isDead)
                [self.goku handleHitByMinion:contact isBoss:YES];
        }else if ([nodeNames containsObject:@"buu"] && [nodeNames containsObject:@"goku"]) {
            if(!self.realFinalBoss.isDead)
                [self.goku handleHitByMinion:contact isBoss:YES];
        }

    }
    
}

- (void) changeMusic{
    
    [self.backgroundMusicPlayer stop];
    self.backgroundMusicPlayer = nil;
    
    NSString *musicPath = [[NSBundle mainBundle]
                           pathForResource:@"buu_dub" ofType:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:NULL];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    self.backgroundMusicPlayer.volume = .2;
    [self.backgroundMusicPlayer play];
}



@end
