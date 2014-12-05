//
//  Minion2.h
//  trialsofgoku
//
//  Created by Marcus on 11/30/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseObject.h"
#import "Globals.h"

@class Goku;
@interface Minion2 : BaseObject

-(Minion2*)setUpMinionWithName:(NSString *)name andHealth:(NSInteger)health andPower:(NSInteger)power;
-(NSArray *)getAnimationFrames:(NSString*)minionAnimationKey;
-(BOOL)checkEligibilityForAttackWith:(Goku*)goku;

@end
