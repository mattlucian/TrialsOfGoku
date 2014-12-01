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

@interface SecondLevel : BaseLevel

@property (nonatomic, strong) Buu* finalBoss;
@property (strong, nonatomic) AVAudioPlayer* backgroundMusicPlayer;

-(void)handleBossCollisions:(SKPhysicsContact *)contact;
-(void)setUpLevelForScene:(GameScene*)scene;
-(void)runLevelFor:(GameScene*)scene;

@end
