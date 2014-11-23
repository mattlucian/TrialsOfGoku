//
//  BaseCharacter.h
//  trialsofgoku
//
//  Created by Matt on 11/15/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@class Goku;
@interface BaseObject : SKSpriteNode

// range 0 - 100 - offense points
@property (nonatomic) NSInteger attackPower;

// range 0 - 100 - defense points
@property (nonatomic) NSInteger defensePower;

// Goku's health and chi (mana)
@property (nonatomic) NSInteger health;
@property (nonatomic) NSInteger totalHealth;

@property (nonatomic) BOOL isActivated;
@property (nonatomic) BOOL isHit;

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic) BOOL isDead;
@property (nonatomic) NSString* lastDirection;

@property (nonatomic) NSString* typeOfObject;
@property (nonatomic, strong) SKSpriteNode* healthBar;



-(void)haltVelocity:(NSString*)axis;
-(void)runAnimation:(NSArray*)animationFrames atFrequency:(float)frequency withKey:(NSString*)animationKey;
-(void)runCountedAnimation:(NSArray*)animationFrames withCount:(int)myCount atFrequency:(float)frequency withKey:(NSString*)animationKey;
-(void)moveInRelationTo:(Goku*)goku andBackgroundFlag:(BOOL)bgIsMoving;
-(void)handleCollisionWithGoku:(Goku*)goku;

-(void)moveHealthBar;
-(void)setUpHealthBar;

@end
