//
//  BaseLevel.h
//  trialsofgoku
//
//  Created by Matt on 11/22/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Goku.h"
#import "Minion.h"
#import "SafeObstacle.h"

@interface BaseLevel : NSObject <GokuDelegate>

@property (nonatomic) NSInteger levelScore;
@property (nonatomic) NSInteger finalLevelPoint;
@property (nonatomic) BOOL beginningOfLevel;
@property (nonatomic) BOOL endOfLevel;
@property (nonatomic) NSInteger currentLevelLocation;
@property (nonatomic) NSInteger bossSpawnNumber;


@property (nonatomic, strong) SafeObstacle* obstacle1;
@property (nonatomic, strong) SafeObstacle* obstacle2;
@property (nonatomic, strong) SafeObstacle* obstacle3;
@property (nonatomic, strong) SafeObstacle* obstacle4;
@property (nonatomic, strong) SafeObstacle* obstacle5;
@property (nonatomic, strong) SafeObstacle* obstacle6;
@property (nonatomic, strong) SafeObstacle* obstacle7;
@property (nonatomic, strong) SafeObstacle* obstacle8;
@property (nonatomic, strong) SafeObstacle* obstacle9;
@property (nonatomic, strong) SafeObstacle* obstacle10;

@property (nonatomic, strong) Minion* minion1;
@property (nonatomic, strong) Minion* minion2;
@property (nonatomic) Minion* minion3;
@property (nonatomic) Minion* minion4;
@property (nonatomic) Minion* minion5;
@property (nonatomic) Minion* minion6;

@property (nonatomic) SKSpriteNode* background1;
@property (nonatomic) SKSpriteNode* background2;
@property (nonatomic) BOOL bgIsMoving;

@property (nonatomic, strong) Goku* goku;

-(void)handleMinionCollisions:(SKPhysicsContact *)contact;
-(void)handleTapGestureWithLocation:(CGPoint)location andDirection:(NSInteger)direction;
-(void)moveObstacles;
-(void)handleObstacleCollisions:(SKPhysicsContact *) contact;
-(void)handleCollisionEnd:(SKPhysicsContact *) contact;

@end
