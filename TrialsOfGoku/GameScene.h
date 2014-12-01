//
//  MyScene.h
//  SonOfGoku
//

//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class GameScene;

@protocol GameSceneDelegate <NSObject>
- (void)mySceneDidFinish:(GameScene *)myScene;
@end

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSInteger levelIndicator;

@property (nonatomic) id <GameSceneDelegate> delegate;

@end

