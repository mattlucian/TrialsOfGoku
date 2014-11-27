//
//  Rock.h
//  trialsofgoku
//
//  Created by Matt on 11/14/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Globals.h"
#import "BaseObject.h"
#import "Goku.h"

@interface SafeObstacle : SKSpriteNode

@property (nonatomic) BOOL isActivated;

-(SafeObstacle*)setUpObstacleAtPoint:(CGPoint)point;
-(void)moveInRelationTo:(Goku *)goku;

@end
