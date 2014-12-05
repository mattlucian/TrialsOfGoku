//
//  SecondLevel.h
//  trialsofgoku
//
//  Created by Matt on 11/16/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Minion.h"
#import "Minion2.h"
#import "Globals.h"
#import "SafeObstacle.h"
#import "Cell.h"
#import "Buu.h"
#import "BaseLevel.h"
#import "GameScene.h"
@import AVFoundation;

@interface SecondLevel : BaseLevel <GokuDelegate>

@property (nonatomic) NSInteger currentLevelLocation;

@property (nonatomic, strong) Buu* finalBoss;
@property (strong, nonatomic) AVAudioPlayer* backgroundMusicPlayer;

@property (nonatomic) SKSpriteNode* background1;
@property (nonatomic) SKSpriteNode* background2;
@property (nonatomic) BOOL bgIsMoving;


@property (nonatomic, strong) Minion2* minion1;
@property (nonatomic, strong) Minion2* minion2;
@property (nonatomic) Minion2* minion3;
@property (nonatomic) Minion2* minion4;
@property (nonatomic) Minion2* minion5;
@property (nonatomic) Minion2* minion6;

-(void)handleBossCollisions:(SKPhysicsContact *)contact;
-(void)setUpLevelForScene:(GameScene*)scene;
-(void)runLevelFor:(GameScene*)scene;
-(void) setupMusic;
-(void)handleObstacleCollisions:(SKPhysicsContact *) contact;
-(void)handleCollisionEnd:(SKPhysicsContact *)contact;


@end
