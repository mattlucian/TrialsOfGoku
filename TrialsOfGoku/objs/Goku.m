//
//  Goku.m
//  SonOfGoku
//
//  Created by Matt on 10/20/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Goku.h"
#import "Globals.h"

@implementation Goku

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// single image, init with image and set frames
-(Goku*)createAnimatedGoku:(NSString *)gokuAnimationKey{
    self.currentAnimationFrames = [[NSMutableArray alloc] init];
    Goku * workingObjectGoku = [[Goku alloc] init];
    self.currentAnimationFrames = [workingObjectGoku getAnimationFrames:gokuAnimationKey];
    workingObjectGoku = [Goku spriteNodeWithTexture:self.currentAnimationFrames[0] ];
    return workingObjectGoku;
}
-(void)increaseVelocity:(NSString*)axis addVelocity:(NSInteger)additionToVelocity
{
    if([[axis uppercaseString] isEqualToString:@"X"]){
        if(additionToVelocity > 0){
            if((additionToVelocity + self.velocity.x) >= 2.5){
                additionToVelocity = 2.5 - self.velocity.x;
            }
        }else{
            additionToVelocity = fabs(additionToVelocity);
            float tempX = fabs(self.velocity.x);
            if((additionToVelocity + tempX) >= 2.5){
                additionToVelocity = 2.5 - tempX;
            }
            additionToVelocity = 0 - additionToVelocity;
        }
        self.velocity = CGPointMake(self.velocity.x+additionToVelocity, self.velocity.y);
    }else if([[axis uppercaseString] isEqualToString:@"Y"]){
        if(self.jumpCount < 2)
            self.velocity = CGPointMake(self.velocity.x, self.velocity.y+additionToVelocity);
    }
}
-(Goku*)setUpGoku{
    Goku* temp = [self createAnimatedGoku:@"goku_norm_stance_right"];
    
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:temp.size];
    temp.physicsBody.categoryBitMask = GOKU_CATEGORY;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.contactTestBitMask = ENEMY_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.name = @"goku";
    
    temp.attackPower = 5;
    temp.health = 100;
    
    temp.jumpCount = 1;
    
    temp.position = CGPointMake(30,50);
    return temp;
}

-(void)performBlast:(NSTimer *)timer{
    switch([(NSString*)[timer userInfo] integerValue]){
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
    }
}

-(NSArray *)getAnimationFrames:(NSString*)gokuAnimationKey{
    NSMutableArray* workingArrayOfFrames = [[NSMutableArray alloc] init];
    
    #pragma mark Normal Goku
    if([gokuAnimationKey hasPrefix:@"goku_norm"]){
        SKTextureAtlas *gokuAnimatedAtlas = [SKTextureAtlas atlasNamed:@"goku_norm"];
        // goku_norm_attack_right
        if([gokuAnimationKey isEqualToString:@"goku_norm_attack_right"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_attack_right_%d", i];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        // goku_norm_attack_left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_attack_left"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_attack_left_%d", i];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        // goku_norm_power_right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_power_right"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_power_right_%d", i];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        // goku_norm_power_left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_power_left"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_power_left_%d", i];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        // goku_norm_walk_right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_walk_right"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_walk_right_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        // goku norm walk left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_walk_left"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_walk_left_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
        // goku norm stance right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_stance_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_stance_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        
        // goku norm jump right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_jump_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_jump_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        
        // goku norm jump left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_jump_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_jump_left"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        
        // goku norm ball charge left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_charge_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_charge_left"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        
        // goku norm ball charge right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_charge_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_charge_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        
        // goku norm ball release right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_release_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_release_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        
        // goku norm ball release left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_release_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_release_left"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
        }

    #pragma mark Super Saiyan 1 Goku
    }else if([gokuAnimationKey hasPrefix:@"goku_ss1"]){

    #pragma mark Super Saiyan 3 Goku
    }else if([gokuAnimationKey hasPrefix:@"goku_ss2"]){
        
    #pragma mark Super Saiyan 4 Goku
    }else if([gokuAnimationKey hasPrefix:@"goku_ss3"]){
        
    }
    
    return (NSArray*)workingArrayOfFrames;
}

-(void)moveGoku{
    if(self.velocity.x > 0){ // updates position with velocity
        if(self.position.x >  225 && [self.lastDirection isEqualToString:@"right"]){
            self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y); //
          //  [self moveBackground];
        }else{
            
            //bgisMoving = false;
            self.velocity = CGPointMake(self.velocity.x-.01, self.velocity.y);
            self.position = CGPointMake(self.position.x+self.velocity.x,self.position.y+self.velocity.y);
        }
    }else if (self.velocity.x < 0){
        if(self.position.x < 75 && [self.lastDirection isEqualToString:@"left"]){
            self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
        //    [self moveBackground];
        }else{
          //  bgisMoving = false;
            self.velocity = CGPointMake(self.velocity.x+.01-self.halting_velocity, self.velocity.y);
            self.position = CGPointMake(self.position.x+self.velocity.x,self.position.y+self.velocity.y);
        }
    }else{
        self.position = CGPointMake(self.position.x+self.velocity.x,self.position.y+self.velocity.y);
    }
    // goku hits the ground here
    if(self.position.y < 30){
        if(self.jumpCount != 0){
            self.jumpCount = 0; // reset jumps
            self.velocity = CGPointMake(self.velocity.x,0); // halt his Y velocity
            self.position = CGPointMake(self.position.x, 30);
        }
    }else{
        if(self.jumpCount != 0){
            self.velocity = CGPointMake(self.velocity.x, self.velocity.y-GRAVITY);
        }
    }
}

@end
