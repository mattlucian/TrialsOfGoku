//
//  Goku.h
//  SonOfGoku
//
//  Created by Matt on 10/20/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BaseObject.h"
#import "Globals.h"
@import AVFoundation;
@protocol GokuDelegate;
@class BaseLevel;

@interface  Goku : BaseObject

@end


@interface Goku ()

// provides more realistic movement by tracking velocity
@property (nonatomic) NSInteger halting_velocity;
@property (nonatomic) BOOL rightLock;
@property (nonatomic) BOOL leftLock;
@property (nonatomic) BOOL obstacleRightLock;
@property (nonatomic) BOOL obstacleLeftLock;

@property (nonatomic) BOOL fallingLock;

@property (nonatomic) NSInteger jumpCount; // double jumps

@property (nonatomic,strong) id <GokuDelegate> delegate;


@property (nonatomic) BOOL stillCharging;
@property (nonatomic) NSInteger speedLimit;

// normal = 0, ss1 = 1, ss3 = 2, ss4 = 3
@property (nonatomic) NSInteger transformationLevel;

@property (strong, nonatomic) AVAudioPlayer* kamehaBlast;

-(Goku*)setUpGokuForLevel:(NSInteger)levelIndicator;
-(NSArray *)getAnimationFrames:(NSString*)gokuAnimationKey;
-(void)increaseVelocity:(NSString*)axis addVelocity:(NSInteger)additionToVelocity;
-(void)moveGoku;

// power balls
-(int)getBallSize:(int)whichBall;
-(BOOL)oneBallIsNil;
-(void)setUpPowerBalls:(float)difference onScene:(SKScene*)scene;
-(void)spawnAndMoveBallsAlongScene:(SKScene*)scene;

@end

@protocol GokuDelegate <NSObject>
-(void)moveBackground:(BOOL)isMoving inRelationTo:(Goku*)goku;
@end


