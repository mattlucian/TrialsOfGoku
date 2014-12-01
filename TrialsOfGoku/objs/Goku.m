//
//  Goku.m
//  SonOfGoku
//
//  Created by Matt on 10/20/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "Goku.h"
#import "PowerBall.h"

@implementation Goku
{
    PowerBall* ball;        // powerball 1
    PowerBall* ball2;       // poewrball 2
    NSTimer* hitTimer;
    NSTimer* attackTimer;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.xScale = 1;
    }
    return self;
}


-(void)spawnAndMoveBallsAlongScene:(SKScene*)scene{
    // moves power balls if they are currently on screen.
    
    if(ball != nil){
        ball.position = CGPointMake(ball.position.x+ball.velocity.x, ball.position.y);
        if(((ball.position.x-40) > scene.view.bounds.size.width)||((ball.position.x + 40 ) < 0 )){
            [ball removeFromParent];
            ball = nil; // set powerballs to nil when they go off the screen
        }
    }
    if(ball2 != nil){
        ball2.position = CGPointMake(ball2.position.x+ball2.velocity.x, ball2.position.y);
        if(((ball2.position.x - 40 ) > scene.view.bounds.size.width)||((ball2.position.x + 40) < 0 )){
            [ball2 removeFromParent];
            ball2 = nil;
        }
    }
}

-(BOOL)oneBallIsNil{
    if(ball == nil || ball2 == nil)
        return true;
    else
        return false;
}

-(BOOL)bothBallsAreNil{
    if(ball == nil && ball2 == nil)
        return true;
    else
        return false;
}

-(int)getBallSize:(int)whichBall{
    switch (whichBall) {
        case 1:
            if(ball != nil){
                switch (ball.ball_size) {
                    case 1:
                        return 1;
                        break;
                    case 2:
                        return 2;
                        break;
                    case 3:
                        return 3;
                        break;
                }
            }
            break;
            
        case 2:
            if(ball2 != nil){
                switch (ball2.ball_size) {
                    case 1:
                        return 1;
                        break;
                    case 2:
                        return 2;
                        break;
                    case 3:
                        return 3;
                        break;
                }
            }
            break;
    }
    return -1;
}

-(void)handleRelease:(NSTimer*)timer{
    self.performingAnAction = NO;
    [self.releaseTimer invalidate];
}

-(void)setUpPowerBalls:(float)difference onScene:(SKScene*)scene{
    NSArray * currentFrames = nil;
    NSInteger ballVelocity = 0;
    
    if([self.lastDirection isEqualToString:@"right"]){
        if(self.transformationLevel == 0){
            currentFrames= [self getAnimationFrames:@"goku_norm_ball_release_right"];
        }else if (self.transformationLevel == 1){
            currentFrames= [self getAnimationFrames:@"goku_ss1_ball_release_right"];
        }else{
            currentFrames= [self getAnimationFrames:@"goku_ss3_ball_release_right"];
        }
        
        ballVelocity = 4;
        [self runCountedAnimation:currentFrames withCount:1 atFrequency:.5f withKey:@"goku_animation_key"];
        self.releaseTimer =  [NSTimer scheduledTimerWithTimeInterval: .5
                                                         target:self
                                                       selector:@selector(handleRelease:)
                                                       userInfo:nil
                                                        repeats:NO];

    }else{
        if(self.transformationLevel == 0){
            currentFrames= [self getAnimationFrames:@"goku_norm_ball_release_left"];
        }else if (self.transformationLevel == 1){
            currentFrames= [self getAnimationFrames:@"goku_ss1_ball_release_left"];
        }else{
            currentFrames= [self getAnimationFrames:@"goku_ss3_ball_release_left"];
        }
        ballVelocity = -4;
        [self runCountedAnimation:currentFrames withCount:1 atFrequency:.5f withKey:@"goku_animation_key"];
        self.releaseTimer =  [NSTimer scheduledTimerWithTimeInterval: .5
                                                         target:self
                                                       selector:@selector(handleRelease:)
                                                       userInfo:nil
                                                        repeats:NO];

    }
    
    if(ball == nil){
        ball = [[PowerBall alloc] init];
        NSArray* frames = [ball getFrames:@"powerball_small_left"]; // filler ball
        ball = [PowerBall spriteNodeWithTexture:frames[0]];
        [ball performSetupFor:difference atVelocity:ballVelocity inRelationTo:self];
        ball.name = @"ball1";
        [self setUpSoundBlast];
        [scene addChild:ball];
    }else if(ball2 == nil){
        ball2 = [[PowerBall alloc] init];
        NSArray* frames = [ball2 getFrames:@"powerball_small_left"]; // filler ball
        ball2 = [PowerBall spriteNodeWithTexture:frames[0]];
        [ball2 performSetupFor:difference atVelocity:ballVelocity inRelationTo:self];
        ball2.name = @"ball2";
        [self setUpSoundBlast];
        [scene addChild:ball2];
    }
}

-(void)increaseVelocity:(NSString*)axis addVelocity:(NSInteger)additionToVelocity{
    if([[axis uppercaseString] isEqualToString:@"X"]){
        if(additionToVelocity > 0){
            if((additionToVelocity + self.velocity.x) >= 5){
                additionToVelocity = 5 - self.velocity.x;
            }
        }else{
            additionToVelocity = fabs(additionToVelocity);
            float tempX = fabs(self.velocity.x);
            if((additionToVelocity + tempX) >= 5){
                additionToVelocity = 5 - tempX;
            }
            additionToVelocity = 0 - additionToVelocity;
        }
        self.velocity = CGPointMake(self.velocity.x+additionToVelocity, self.velocity.y);
    }else if([[axis uppercaseString] isEqualToString:@"Y"]){
        if(self.jumpCount < 2){
            self.velocity = CGPointMake(self.velocity.x, self.velocity.y+additionToVelocity);
            self.fallingLock = NO;
        }
    }
}

-(Goku*)setUpGokuForLevel:(NSInteger)levelIndicator{
   
    Goku* temp = [Goku spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"goku_norm_stance_right"] size:CGSizeMake(80, 100)];
    
    if(levelIndicator == 1){
        temp.transformationLevel = 0;
    }else if (levelIndicator == 2){
        temp.transformationLevel = 1;
        temp.texture = [SKTexture textureWithImageNamed:@"goku_ss1_stance_right"];
    }
    temp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:temp.size];
    temp.physicsBody.categoryBitMask = GOKU_CATEGORY;
    temp.physicsBody.dynamic = YES;
    temp.physicsBody.affectedByGravity = NO;
    temp.physicsBody.contactTestBitMask = ENEMY_CATEGORY | SAFE_OBSTACLE_CATEGORY | ENEMY_BLAST_CATEGORY;
    temp.physicsBody.collisionBitMask = 0;
    temp.lastDirection = @"right";
    temp.name = @"goku";
    temp.typeOfObject = @"goku";
    temp.isCollidingWithObstacle = NO;
    temp.attackPower = 5;
    temp.health = 100;
    temp.totalHealth = 100;
    temp.jumpCount = 1;
    temp.position = CGPointMake(30,50);
    return temp;
}

-(void)transformToSuperSaiyan:(NSNumber*)ssLevel{
    NSArray* frames = nil;
    if([ssLevel integerValue] == 3){
        frames = [self getAnimationFrames:@"goku_ss1_power_right"];
    }else{
        frames = [self getAnimationFrames:@"goku_norm_power_right"];
    }
    [self runCountedAnimation:frames withCount:1 atFrequency:.13f withKey:@"goku_transformation"];
    self.isTransforming = YES;
    self.transformTimer = [NSTimer scheduledTimerWithTimeInterval: 1.7
                                                target:self
                                              selector:@selector(reachedTransformation:)
                                              userInfo:ssLevel
                                               repeats:NO];
}

-(void)reachedTransformation:(NSTimer*)timer{
    if([[timer userInfo] integerValue] == 1){
        self.transformationLevel = 1;
        NSArray * frames = [self getAnimationFrames:@"goku_ss1_stance_right"];
        if(frames != nil)
            [self runAnimation:frames atFrequency:1 withKey:@"ss1_stance"];
    }else if([[timer userInfo] integerValue] == 3){
        self.transformationLevel = 3;
        NSArray * frames = [self getAnimationFrames:@"goku_ss3_stance_right"];
        if(frames != nil)
            [self runAnimation:frames atFrequency:1 withKey:@"ss3_stance"];

    }
    self.attackPower *= 2;
    self.hasTransformed = YES;
    self.performingAnAction = NO;
}

-(void)animateStance{
    NSArray* frames = nil;
    if(self.transformationLevel == 0){
        if([self value:self.velocity.x isInBetween:-1.1 and:1.1])
        {
            if([self value:self.velocity.x isInBetween:-.1 and:.2] && [self.lastDirection isEqualToString:@"right"])
                frames = [self getAnimationFrames:@"goku_norm_stance_right"];
            else
                frames = [self getAnimationFrames:@"goku_norm_stance_left"];
        }else{
            if(self.velocity.x >= 0)
                frames = [self getAnimationFrames:@"goku_norm_walk_right"];
            else
                frames = [self getAnimationFrames:@"goku_norm_walk_left"];
        }
    }else if(self.transformationLevel == 1){
        if([self value:self.velocity.x isInBetween:-.2 and:.2])
        {
            if(self.velocity.x >= 0)
                frames = [self getAnimationFrames:@"goku_ss1_stance_right"];
            else
                frames = [self getAnimationFrames:@"goku_ss1_stance_left"];
        }else{
            if(self.velocity.x >= 0)
                frames = [self getAnimationFrames:@"goku_ss1_walk_right"];
            else
                frames = [self getAnimationFrames:@"goku_ss1_walk_left"];
        }
    }else{
        if([self value:self.velocity.x isInBetween:-.05 and:.05])
        {
            if(self.velocity.x >= 0)
                frames = [self getAnimationFrames:@"goku_ss3_stance_right"];
            else
                frames = [self getAnimationFrames:@"goku_ss3_stance_left"];
        }else{
            if(self.velocity.x >= 0)
                frames = [self getAnimationFrames:@"goku_ss3_walk_right"];
            else
                frames = [self getAnimationFrames:@"goku_ss3_walk_left"];
        }
    }
    [self runAnimation:frames atFrequency:.3f withKey:@"animate_stance"];
}

-(BOOL)value:(float)val isInBetween:(float)first and:(float)second{
    if((val >= first)&&(val <= second))
        return YES;
    else return NO;
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
            self.xScale = 1;

        // goku_norm_attack_left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_attack_left"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_attack_right_%d", i];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
            self.xScale = -1;
            
        // goku_norm_power_right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_power_right"]){
            int ids[] = { 0,0,1,0,0,1,0,1,0,1,0,1,1,0,1};
            for (int i=0; i <  15 ; i++) {
                NSString* txtN = (ids[i] == 0)?@"goku_norm_power_right_0":@"goku_ss1_power_right_0";
                SKTexture *temp = [SKTexture textureWithImageNamed:txtN];
                [workingArrayOfFrames addObject:temp];
            }
            self.xScale = 1;
            
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_power_left"]){
            int ids[] = { 0,0,1,0,0,1,0,1,0,1,0,1,1,0,1};
            for (int i=0; i <  15 ; i++) {
                NSString* txtN = (ids[i] == 0)?@"goku_norm_power_right_0":@"goku_ss1_power_right_0";
                SKTexture *temp = [SKTexture textureWithImageNamed:txtN];
                [workingArrayOfFrames addObject:temp];
            }
            self.xScale = -1;

        // goku_norm_walk_right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_walk_right"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_walk_right_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
            self.xScale = 1;
            
        // goku norm walk left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_walk_left"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_norm_walk_right_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
            }
            self.xScale = -1;
            
        // goku norm stance right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_stance_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_stance_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
        // goku norm stance left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_stance_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_stance_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
            
        // goku norm jump right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_jump_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_jump_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
        // goku norm jump left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_jump_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_jump_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
            
        // goku norm ball charge left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_charge_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_charge_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
        
        // goku norm ball charge right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_charge_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_charge_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
        
        // goku norm ball release right
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_release_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_release_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
        
        // goku norm ball release left
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_ball_release_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_ball_release_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
        
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_hitfrom_right"]){
            int randomNummber = (rand() % 3)+1;
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_hitfrom_right_%d",randomNummber];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
        }else if([gokuAnimationKey isEqualToString:@"goku_norm_hitfrom_left"]){
            int randomNummber = (rand() % 3)+1;
            NSString *textureName = [NSString stringWithFormat:@"goku_norm_hitfrom_right_%d",randomNummber];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
        }

    #pragma mark Super Saiyan 1 Goku
    }else if([gokuAnimationKey hasPrefix:@"goku_ss1"]){
        SKTextureAtlas *gokuAnimatedAtlas = [SKTextureAtlas atlasNamed:@"goku_ss1"];
        
        // goku ss1 attack right
        if([gokuAnimationKey isEqualToString:@"goku_ss1_attack_right"]){
            int random = (rand() % 5)+1;
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_attack_right_%d", random];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];

            self.xScale = 1;

        // goku_ss1_attack_left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_attack_left"]){
            int random = (rand() % 5)+1;
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_attack_right_%d", random];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            
            self.xScale = -1;

        // goku_ss1_power_right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_power_right"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"goku_ss1_power_right_%d", i];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
                self.xScale = 1;
            }
        
        // goku_ss1_walk_right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_walk_right"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_ss1_walk_right_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
                self.xScale = 1;
            }
        
        // goku ss1 walk left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_walk_left"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_ss1_walk_right_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
                self.xScale = -1;
            }
          
        // goku ss1 stance right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_stance_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_stance_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;

        // goku ss1 stance left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_stance_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_stance_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;

        // goku ss1 jump right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_jump_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_jump_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
        
        // goku ss1 jump left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_jump_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_jump_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
        // goku ss1 ball charge left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_ball_charge_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_ball_charge_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
            
        // goku ss1 ball charge right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_ball_charge_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_ball_charge_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;

        // goku ss1 ball release right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_ball_release_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_ball_release_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;

        // goku ss1 ball release left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_ball_release_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_ball_release_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
        }
        
        
    #pragma mark Super Saiyan 3 Goku
    }else if([gokuAnimationKey hasPrefix:@"goku_ss3"]){
        SKTextureAtlas *gokuAnimatedAtlas = [SKTextureAtlas atlasNamed:@"goku_ss3"];
        
        // goku ss1 attack right
        if([gokuAnimationKey isEqualToString:@"goku_ss3_attack_right"]){
            int random = (rand() % 5)+1;
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_attack_right_%d", random];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            
            self.xScale = 1;
            
            // goku_ss1_attack_left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_attack_left"]){
            int random = (rand() % 5)+1;
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_attack_right_%d", random];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            
            self.xScale = -1;
            
            // goku_ss1_power_right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_power_right"]){
            for (int i=1; i <= 3; i++) {
                NSString *textureName = [NSString stringWithFormat:@"goku_ss3_power_right_%d", i];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
                self.xScale = 1;
            }
            
            // goku_ss1_walk_right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_walk_right"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_ss3_walk_right_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
                self.xScale = 1;
            }
            
            // goku ss1 walk left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_walk_left"]){
            int ids[] = { 3,2,3,2,3};
            for (int i=1; i < 5; i++) {
                int index = ids[i];
                NSString *textureName = [NSString stringWithFormat:@"goku_ss3_walk_right_%d", index];
                SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
                [workingArrayOfFrames addObject:temp];
                self.xScale = -1;
            }
            
            // goku ss1 stance right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_stance_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_stance_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
            // goku ss1 stance left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_stance_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_stance_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
            
            // goku ss1 jump right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_jump_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_jump_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
            
            // goku ss1 jump left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_jump_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_jump_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
            // goku ss1 ball charge left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_ball_charge_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_ball_charge_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
            
            // goku ss1 ball charge right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_ball_charge_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_ball_charge_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
            // goku ss1 ball release right
        }else if([gokuAnimationKey isEqualToString:@"goku_ss1_ball_release_right"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss1_ball_release_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = 1;
            
            // goku ss1 ball release left
        }else if([gokuAnimationKey isEqualToString:@"goku_ss3_ball_release_left"]){
            NSString *textureName = [NSString stringWithFormat:@"goku_ss3_ball_release_right"];
            SKTexture *temp = [gokuAnimatedAtlas textureNamed:textureName];
            [workingArrayOfFrames addObject:temp];
            self.xScale = -1;
        }
        
        
    #pragma mark Super Saiyan 4 Goku
    }else if([gokuAnimationKey hasPrefix:@"goku_ss4"]){
        
    }
    if(workingArrayOfFrames != nil){
        return (NSArray*)workingArrayOfFrames;
    }else{
        return [[NSArray alloc] initWithObjects:[SKTexture textureWithImageNamed:@"goku_norm_stance_right"], nil];
    }
}

-(void)moveGoku{
    
    if(!self.isDead){
        [self moveHealthBar];
        
        if(self.fallingLock){
            self.obstacleLeftLock = NO;
            self.obstacleRightLock = NO;
        }
        
        if([self value:self.velocity.x isInBetween:-.2 and:.2] && !self.performingAnAction)
        {
            [self animateStance];
        }
        
        if(self.velocity.x > 0){ // updates position with velocity
            if(self.position.x >  500 && [self.lastDirection isEqualToString:@"right"]){
                if(self.rightLock){
                    if(self.position.x > 980){
                        self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
                    }else{
                        if(!self.obstacleRightLock)
                            self.position = CGPointMake(self.position.x+self.velocity.x,self.position.y+self.velocity.y);
                        else
                            self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
                    }
                }else{
                    self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
                    if(!self.isCollidingWithObstacle)
                        [self.delegate moveBackground:YES inRelationTo:self];
                }
            }else {
                [self.delegate moveBackground:NO inRelationTo:self];
                self.velocity = CGPointMake(self.velocity.x-.03, self.velocity.y);
                if(!self.obstacleRightLock)
                    self.position = CGPointMake(self.position.x+self.velocity.x,self.position.y+self.velocity.y);
                else
                    self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
            }
            
        }else if (self.velocity.x < 0){
            if(self.position.x < 200 && [self.lastDirection isEqualToString:@"left"]){
                self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
                if(!self.leftLock && !self.obstacleLeftLock){
                    [self.delegate moveBackground:YES inRelationTo:self];
                }
            }else{
                [self.delegate moveBackground:NO inRelationTo:self];
                self.velocity = CGPointMake(self.velocity.x+.03-self.halting_velocity, self.velocity.y);
                if(!self.obstacleLeftLock)
                    self.position = CGPointMake(self.position.x+self.velocity.x,self.position.y+self.velocity.y);
                else
                    self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
            }
        }else{
            if(!self.obstacleLeftLock)
                self.position = CGPointMake(self.position.x+self.velocity.x,self.position.y+self.velocity.y);
            else{
                self.position = CGPointMake(self.position.x,self.position.y+self.velocity.y);
                
            }
        }
        
        // goku hits the ground here
        if(self.position.y < 60){
            if(self.jumpCount != 0){
                self.jumpCount = 0; // reset jumps
                self.performingAnAction = NO;
                self.velocity = CGPointMake(self.velocity.x,0); // halt his Y velocity
                self.position = CGPointMake(self.position.x, 60);
                [self animateStance];
            }
        }else{
            if(self.jumpCount != 0){
                if(!self.fallingLock)
                    self.velocity = CGPointMake(self.velocity.x, self.velocity.y-GRAVITY);
                else{
                    self.velocity = CGPointMake(self.velocity.x, 0);
                    self.jumpCount = 0;
                    self.performingAnAction = NO;
                    [self animateStance];
                }
            }
        }
    }else{
        
        if(self.position.y > 62){
            [self.healthBar removeFromParent];
            self.position = CGPointMake(self.position.x,self.position.y-(GRAVITY*3));
        }
    }
}

-(void)animateAttack{
    SKAction *musicAction = [SKAction playSoundFileNamed:@"punch.wav" waitForCompletion:NO];
    [self runAction:musicAction];
    switch (self.transformationLevel) {
        case 0:
            if([self.lastDirection isEqualToString:@"right"]){
                [self runCountedAnimation:[self getAnimationFrames:@"goku_norm_attack_right"] withCount:1 atFrequency:.2f withKey:@"attack_key"];
            }else{
             [self runCountedAnimation:[self getAnimationFrames:@"goku_norm_attack_left"] withCount:1 atFrequency:.2f withKey:@"attack_key"];
            }
            break;
        case 1:
            if([self.lastDirection isEqualToString:@"right"]){
                [self runCountedAnimation:[self getAnimationFrames:@"goku_ss1_attack_right"] withCount:1 atFrequency:.2f withKey:@"attack_key"];
            }else{
                [self runCountedAnimation:[self getAnimationFrames:@"goku_ss1_attack_left"] withCount:1 atFrequency:.2f withKey:@"attack_key"];
            }
            break;
        case 3:
            if([self.lastDirection isEqualToString:@"right"]){
                [self runCountedAnimation:[self getAnimationFrames:@"goku_ss3_attack_right"] withCount:1 atFrequency:.2f withKey:@"attack_key"];
            }else{
                [self runCountedAnimation:[self getAnimationFrames:@"goku_ss3_attack_left"] withCount:1 atFrequency:.2f withKey:@"attack_key"];
            }
            break;
            
        default:
            break;
    }
    attackTimer = [NSTimer scheduledTimerWithTimeInterval: .2
                                                target:self
                                              selector:@selector(handleAttack:)
                                              userInfo:nil
                                               repeats:NO];

}

-(void)handleAttack:(NSTimer*)timer
{
    self.isAttacking = NO;
    
}

-(void)animateHitInDirection:(NSInteger)direction{
    NSArray * frames = nil;
    float newVelocity = (0 - direction)*2;
    self.velocity = CGPointMake(newVelocity, self.velocity.y);
    switch (self.transformationLevel) {
        
        case 0:
            if(direction == 1)
                frames = [self getAnimationFrames:@"goku_norm_hitfrom_right"];
            else
                frames = [self getAnimationFrames:@"goku_norm_hitfrom_left"];
            break;
        case 1:
            if(direction == 1)
                frames = [self getAnimationFrames:@"goku_ss1_hitfrom_right"];
            else
                frames = [self getAnimationFrames:@"goku_ss1_hitfrom_left"];

            break;
        case 3:
            if(direction == 1)
                frames = [self getAnimationFrames:@"goku_ss3_hitfrom_right"];
            else
                frames = [self getAnimationFrames:@"goku_ss3_hitfrom_left"];
            break;
            
        default:
            if(direction == 1)
                frames = [self getAnimationFrames:@"goku_norm_hitfrom_right"];
            else
                frames = [self getAnimationFrames:@"goku_norm_hitfrom_left"];
            break;
    }
    // frames should never be nil here
    if(frames != nil){
        [self runCountedAnimation:frames withCount:1 atFrequency:.5f withKey:@"hit_yo"];
    }
    
}

-(void)handleHitByMinion:(SKPhysicsContact *)contact isBoss:(BOOL)isABoss{
    
    if(self.isAttacking){
        // he's attacking
        
    }else{
        if(!self.isHit){
            float difference = contact.bodyA.node.position.x - contact.bodyB.node.position.x;
            if([contact.bodyA.node.name isEqualToString:@"goku"]){
                // node A == Goku
                if(difference > 0 ){ // goku hit from the left
                    [self animateHitInDirection:-1];
                    if(isABoss)
                        self.health -= 20;
                    else
                        self.health -= 10;
                }
                else if(difference < 0){ // goku hit from the right
                    [self animateHitInDirection:1];
                    if(isABoss)
                        self.health -= 20;
                    else
                        self.health -= 10;
                }
            }else{
                if(difference > 0 ){ // goku hit from the right
                    [self animateHitInDirection:1];
                    if(isABoss)
                        self.health -= 20;
                    else
                        self.health -= 10;
                }
                else if(difference < 0 ){ // goku hit from the left
                    [self animateHitInDirection:-1];
                    if(isABoss)
                        self.health -= 20;
                    else
                        self.health -= 10;
                }
            }
            if(self.health <= 0){
                self.health = 0;
                self.isDead = YES;
                [self.delegate pauseAnimations];
                
                switch (self.transformationLevel) {
                    case 0:
                        [self runAnimation:[NSMutableArray arrayWithObject:[SKTexture textureWithImageNamed:@"goku_norm_dead"]] atFrequency:10 withKey:@"goku_dead"];
                        break;
                    case 1:
                        [self runAnimation:[NSMutableArray arrayWithObject:[SKTexture textureWithImageNamed:@"goku_ss1_dead"]] atFrequency:10 withKey:@"goku_dead"];
                        break;
                        
                    case 3:
                        [self runAnimation:[NSMutableArray arrayWithObject:[SKTexture textureWithImageNamed:@"goku_ss3_dead"]] atFrequency:10 withKey:@"goku_dead"];
                        break;
                    default:
                        break;
                }
                
            }
            [self updateHealthBar];
            self.isHit = YES;
            hitTimer = [NSTimer scheduledTimerWithTimeInterval: .5
                                                        target:self
                                                      selector:@selector(handleHit:)
                                                      userInfo:nil
                                                       repeats:NO];
            
        }
    }
}

-(void)handleHit:(NSTimer*)timer{
    self.isHit = NO;
    if([self.transformTimer isValid]){
        [self removeActionForKey:@"goku_transformation"];
        [self.transformTimer invalidate];
    }
    [hitTimer invalidate];
}

-(void)updateHealthBar{
    // 3 sizes
    float ratio = (float)self.health/(float)self.totalHealth;
    
    if(ratio == 0){
        [self.healthBar runAction:[SKAction animateWithTextures:[NSArray arrayWithObject:[SKTexture textureWithImageNamed:@"dead_health"]] timePerFrame:0]];
    }else if(ratio < .34){
        [self.healthBar runAction:[SKAction animateWithTextures:[NSArray arrayWithObject:[SKTexture textureWithImageNamed:@"low_health"]] timePerFrame:0]];
    }else if (ratio < .67){
        [self.healthBar runAction:[SKAction animateWithTextures:[NSArray arrayWithObject:[SKTexture textureWithImageNamed:@"medium_health"]] timePerFrame:0]];
    }
    
}

- (void) setUpSoundBlast{
    NSString *musicPath = [[NSBundle mainBundle]
                           pathForResource:@"aura-big" ofType:@"wav"];
    self.kamehaBlast = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:NULL];

    self.kamehaBlast.volume = .75;
    [self.kamehaBlast play];
}


@end
