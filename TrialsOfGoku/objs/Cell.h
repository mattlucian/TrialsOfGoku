//
//  Cell.h
//  trialsofgoku
//
//  Created by Matt on 11/15/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "BaseObject.h"
#import "Globals.h"

@interface Cell : BaseObject

-(NSArray *)getAnimationFrames:(NSString*)cellAnimationKey;
-(Cell*)setUpCell;
// test edit 2

@end
