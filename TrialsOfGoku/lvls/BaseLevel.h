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
#import "Minion2.h"
#import "SafeObstacle.h"

@interface BaseLevel : NSObject <GokuDelegate>

@property (nonatomic) NSInteger levelScore;
@property (nonatomic) NSInteger finalLevelPoint;
@property (nonatomic) BOOL beginningOfLevel;
@property (nonatomic) BOOL endOfLevel;
@property (nonatomic) NSInteger currentLevelLocation;
@property (nonatomic) NSInteger bossSpawnNumber;

@property (nonatomic, strong) BaseObject* minion1;
@property (nonatomic, strong) BaseObject* minion2;
@property (nonatomic) BaseObject* minion3;
@property (nonatomic) BaseObject* minion4;
@property (nonatomic) BaseObject* minion5;
@property (nonatomic) BaseObject* minion6;

@property (nonatomic) BaseObject* finalBoss;

@property (nonatomic) SKSpriteNode* background1;
@property (nonatomic) SKSpriteNode* background2;
@property (nonatomic) BOOL bgIsMoving;

@property (nonatomic, strong) Goku* goku;

-(void)handleMinionCollisions:(SKPhysicsContact *)contact;
-(void)handleTapGestureWithLocation:(CGPoint)location andDirection:(NSInteger)direction;
-(void)moveObstacles;


-(void)handleGokuCollision:(SKPhysicsContact *) contact;
-(void)pauseAnimations;
-(void)unpauseAnimations;


@end
