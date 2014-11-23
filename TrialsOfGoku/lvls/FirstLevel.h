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

@interface FirstLevel : BaseLevel


@property (nonatomic, strong) Buu* finalBoss;

-(void)handleBossCollisions:(SKPhysicsContact *)contact;
-(void)setUpLevelForScene:(GameScene*)scene;
-(void)runLevelFor:(GameScene*)scene;


@end
