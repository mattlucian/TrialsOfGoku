//
//  Buu.h
//  trialsofgoku
//
//  Created by Matt on 11/13/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseObject.h"
#import "Globals.h"

@interface Buu : BaseObject

-(Buu*)setUpBuu;
-(NSArray *)getAnimationFrames:(NSString*)buuAnimationKey;


@end
