//
//  GameViewController.h
//  TrialsOfGoku
//

//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface GameViewController : UIViewController <GameSceneDelegate>

- (void)mySceneDidFinish:(GameScene *)myScene;

@end
