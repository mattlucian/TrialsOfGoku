//
//  Minion.h
//  trialsofgoku
//
//  Created by Matt on 11/15/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseObject.h"
#import "Globals.h"

@class Goku;
@interface Minion : BaseObject

-(void)runAnimation:(NSArray*)animationFrames atFrequency:(float)frequency;
-(Minion*)setUpMinionWithName:(NSString*)name;

@end
