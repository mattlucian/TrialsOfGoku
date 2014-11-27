//
//  PowerBall.m
//  trialsofgoku
//
//  Created by Matt on 11/11/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "PowerBall.h"
#import "Globals.h"

@implementation PowerBall


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(NSArray*)getFrames:(NSString*)animationKey{
    NSMutableArray* workingArrayOfFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *atlasImages = [SKTextureAtlas atlasNamed:@"misc"];

    // should be fine
    NSString *textureName = [NSString stringWithFormat:animationKey];
    SKTexture *temp = [atlasImages textureNamed:textureName];
    [workingArrayOfFrames addObject:temp];

    NSArray* finalFrames = workingArrayOfFrames;
    return finalFrames;
}

-(NSArray*)setSizeAndShow:(NSInteger)newSize inDirection:(NSString*)direction
{
    self.ball_size = newSize;
    NSArray *frames = [[NSArray alloc] init];
    
    if([direction isEqualToString:@"left"]){
        switch(self.ball_size){
            case 1:
                frames = [self getFrames:@"powerball_small_left"];
                break;
            case 2:
                frames = [self getFrames:@"powerball_medium_left"];
                break;
            case 3:
                frames = [self getFrames:@"powerball_large_left"];
                break;
        }
    }else if([direction isEqualToString:@"right"]){
        switch(self.ball_size){
            case 1:
                frames = [self getFrames:@"powerball_small_right"];
                break;
            case 2:
                frames = [self getFrames:@"powerball_medium_right"];
                break;
            case 3:
                frames = [self getFrames:@"powerball_large_right"];
                break;
        }
    }
    return frames;
}

-(void)performSetupFor:(float)difference atVelocity:(NSInteger)velocity inRelationTo:(Goku*)goku{
    // init variables
    NSArray* framesToRun = [[NSArray alloc] init];
    NSInteger siz = 0;
    NSInteger offset = 0;
    offset = (velocity*20);
    if(offset > 0)
        offset -= 20;
    else
        offset += 20;
    
    // create certain sized powerball
    if(difference >= .5 && difference < 1.0){
        self.size = CGSizeMake(50, 40);
        framesToRun = [self setSizeAndShow:3 inDirection:goku.lastDirection];
        siz = 1;
    }else if (difference >= 1.0 && difference < 1.5){
        self.size = CGSizeMake(80, 75);
        framesToRun = [self setSizeAndShow:2 inDirection:goku.lastDirection];
        siz = 2;
    }else if(difference >= 1.5){
        self.size = CGSizeMake(100, 90);
        framesToRun = [self setSizeAndShow:3 inDirection:goku.lastDirection];
        siz = 3;
    }
    [self runAnimation:framesToRun atFrequency:.5f withKey:@"power_ball_animation_key"];
    
    // set physics
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = POWERBALL_CATEGORY;
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.contactTestBitMask = ENEMY_CATEGORY;
    self.physicsBody.collisionBitMask = 0;
    self.typeOfObject = @"ball";
    
    // set other properties
    self.ball_size = siz;
    self.position = CGPointMake(goku.position.x+offset,goku.position.y);
    self.velocity = CGPointMake( velocity ,self.velocity.y);
}

-(void)animateExplosion
{
    
}


@end
