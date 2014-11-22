//
//  PowerBall.h
//  trialsofgoku
//
//  Created by Matt on 11/11/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Goku.h"

@interface PowerBall : BaseObject

@property (nonatomic) NSInteger ball_size;

-(NSArray*)setSizeAndShow:(NSInteger)newSize inDirection:(NSString*)direction;
-(NSArray*)getFrames:(NSString*)animationKey;
-(void)performSetupFor:(float)difference atVelocity:(NSInteger)velocity inRelationTo:(Goku*)goku;


@end
