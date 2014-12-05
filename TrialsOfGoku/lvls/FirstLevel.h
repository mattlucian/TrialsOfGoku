//
//  FirstLevel.h
//  trialsofgoku
//
//  Created by Matt on 11/16/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Minion.h"
#import "Globals.h"
#import "SafeObstacle.h"
#import "Cell.h"
#import "Buu.h"
#import "BaseLevel.h"
#import "GameScene.h"
@import AVFoundation;

@interface FirstLevel : BaseLevel <GokuDelegate>

@property (nonatomic) NSInteger currentLevelLocation;

@property (nonatomic, strong) SafeObstacle* obstacle1;
@property (nonatomic, strong) SafeObstacle* obstacle2;
@property (nonatomic, strong) SafeObstacle* obstacle3;
@property (nonatomic, strong) SafeObstacle* obstacle4;
@property (nonatomic, strong) SafeObstacle* obstacle5;
@property (nonatomic, strong) Cell* finalBoss;


@property (nonatomic) SKSpriteNode* background1;
@property (nonatomic) SKSpriteNode* background2;
@property (nonatomic) BOOL bgIsMoving;


@property (nonatomic, strong) Minion* minion1;
@property (nonatomic, strong) Minion* minion2;
@property (nonatomic) Minion* minion3;
@property (nonatomic) Minion* minion4;
@property (nonatomic) Minion* minion5;
@property (nonatomic) Minion* minion6;


@property (strong, nonatomic) AVAudioPlayer* backgroundMusicPlayer;

-(void)handleBossCollisions:(SKPhysicsContact *)contact;
-(void)setUpLevelForScene:(GameScene*)scene;
-(void)runLevelFor:(GameScene*)scene;
-(void)killFirstLevel;
-(void)handleCollisionEnd:(SKPhysicsContact *)contact;
-(void)handleObstacleCollisions:(SKPhysicsContact *) contact;
-(void)moveObstacles;

@end
