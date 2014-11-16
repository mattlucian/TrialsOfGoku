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

@interface FirstLevel : NSObject

@property (nonatomic) NSInteger levelRange;
@property (nonatomic) NSInteger currentLevelLocation;
@property (nonatomic) NSInteger bossSpawnNumber;
@property (nonatomic) BOOL alreadySpawned;

@property (nonatomic) Minion* minion1;
@property (nonatomic) Minion* minion2;
@property (nonatomic) Minion* minion3;
@property (nonatomic) Minion* minion4;

@property (nonatomic) SKSpriteNode* background1;
@property (nonatomic) SKSpriteNode* background2;

@property (nonatomic) Buu* finalBoss;


-(void)runLevelFor:(SKScene*)scene;
-(void)setUpLevelForScene:(SKScene*)scene;

@end
