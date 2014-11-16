//
//  BaseCharacter.m
//  trialsofgoku
//
//  Created by Matt on 11/15/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "BaseObject.h"

@implementation BaseObject

-(void)runAnimation:(NSArray*)animationFrames atFrequency:(float)frequency withKey:(NSString*)animationKey{
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:animationFrames
                                      timePerFrame:frequency
                                            resize:NO
                                           restore:YES]] withKey:animationKey];
    return;
}
-(void)runCountedAnimation:(NSArray*)animationFrames withCount:(int)myCount atFrequency:(float)frequency withKey:(NSString*)animationKey{
    [self runAction:[SKAction repeatAction:
                     [SKAction animateWithTextures:animationFrames
                                      timePerFrame:frequency
                                            resize:NO
                                           restore:YES] count:myCount] withKey:animationKey];
    return;
    
}

-(void)haltVelocity:(NSString*)axis
{
    if([[axis uppercaseString] isEqualToString:@"X"]){
        self.velocity = CGPointMake(0, self.velocity.y);
    }else if([[axis uppercaseString] isEqualToString:@"Y"]){
        self.velocity = CGPointMake(self.velocity.x, 0);
    }else{
        self.velocity = CGPointMake(0, 0);
    }
}



@end
