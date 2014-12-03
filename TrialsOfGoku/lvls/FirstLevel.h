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

@interface FirstLevel : BaseLevel

@property (nonatomic, strong) SafeObstacle* obstacle1;
@property (nonatomic, strong) SafeObstacle* obstacle2;
@property (nonatomic, strong) SafeObstacle* obstacle3;
@property (nonatomic, strong) SafeObstacle* obstacle4;
@property (nonatomic, strong) SafeObstacle* obstacle5;
@property (nonatomic, strong) Cell* finalBoss;
@property (strong, nonatomic) AVAudioPlayer* backgroundMusicPlayer;

-(void)handleBossCollisions:(SKPhysicsContact *)contact;
-(void)setUpLevelForScene:(GameScene*)scene;
-(void)runLevelFor:(GameScene*)scene;
-(void)killFirstLevel;
-(void)handleCollisionEnd:(SKPhysicsContact *)contact;
-(void)handleObstacleCollisions:(SKPhysicsContact *) contact;
-(void)moveObstacles;

@end
