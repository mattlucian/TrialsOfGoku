//
//  FirstLevel.m
//  trialsofgoku
//
//  Created by Matt on 11/16/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "FirstLevel.h"



@implementation FirstLevel
{
    NSTimer *enemyHitTimer; // pauses the enemy when hit
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.levelRange = 20;
        self.currentLevelLocation = 0;
        
        self.background1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bg1"] size:[[UIScreen mainScreen] bounds].size];
        self.background1.position = CGPointMake( CGRectGetMidX([[UIScreen mainScreen] bounds]) , CGRectGetMidX([[UIScreen mainScreen] bounds]));
        self.background2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bg1"] size:[[UIScreen mainScreen] bounds].size];
        self.background2.position = CGPointMake( CGRectGetMidX([[UIScreen mainScreen] bounds])+self.background2.frame.size.width , CGRectGetMidX([[UIScreen mainScreen] bounds]));
        
        self.goku = [[Goku alloc] init];
        self.goku = [self.goku setUpGoku];
        self.goku.delegate = self;
        
        // TODO:
            // Create minion objects
//        self.minion1 = [Minion initali];
  //      [self.minion1 setUpMinion];
    
            // Create obstacle objects
        
        // Create boss object
        self.finalBoss = [Buu spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"buu_walk_right_1"] size:CGSizeMake(50, 50)];
        [self.finalBoss setUpBuu];
    
    }
    return self;
}

-(void)handleCollisionsWithContact:(SKPhysicsContact *)contact
{
    if(self.finalBoss != nil) {
        if(self.finalBoss.isActivated){
            if(!self.finalBoss.isDead){
                NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
                if ([nodeNames containsObject:@"boss"] && [nodeNames containsObject:@"ball1"]) {
                    switch ([self.goku getBallSize:1]) {
                        case 1:
                            self.finalBoss.health -= 10;
                            break;
                        case 2:
                            self.finalBoss.health -= 20;
                            break;
                        case 3:
                            self.finalBoss.health -= 30;
                            break;
                    }
                    if(self.finalBoss.health < 0){
                        self.finalBoss.isDead = true;
                        NSMutableArray* deadFrame = [[NSMutableArray alloc] init];
                        [deadFrame insertObject:[SKTexture textureWithImageNamed:@"buu_deadfrom_right"]  atIndex:0];
                        [self.finalBoss runAnimation:deadFrame atFrequency:.2f withKey:@"final_boss_animation_key"]; // animate death
                    }else{
                        // animate a hit
                        self.finalBoss.isHit = true;
                        
                        enemyHitTimer= [NSTimer scheduledTimerWithTimeInterval: 1
                                                                        target:self.finalBoss
                                                                      selector:@selector(handleHit:)
                                                                      userInfo:nil
                                                                       repeats:NO];
                        
                        NSMutableArray* hitFrame = [[NSMutableArray alloc] init];
                        [hitFrame insertObject:[SKTexture textureWithImageNamed:@"buu_hitfrom_right_3"]  atIndex:0];
                        [self.finalBoss runCountedAnimation:hitFrame withCount:1 atFrequency:.5f withKey:@"final_boss_animation_key"];
                        
                    }
                    
                }else if ([nodeNames containsObject:@"boss"] && [nodeNames containsObject:@"ball2"]) {
                    
                    // handle collision
                    self.finalBoss.isDead = true;
                    
                    // change texture in some other way
                    NSMutableArray* deadFrame = [[NSMutableArray alloc] init];
                    [deadFrame insertObject:[SKTexture textureWithImageNamed:@"buu_deadfrom_right"]  atIndex:0];
                    [self.finalBoss runAnimation:deadFrame atFrequency:.2f withKey:@"final_boss_animation_key"];
                    
                }
            }
        }
    }
    
    // minion collision detection
}

-(void)sendChild:(id)childNode
{
    
}

-(void)moveBackground:(BOOL)isMoving{

    if(isMoving){
        self.bgIsMoving = YES;
        
        // updates bg's position if they are currently on the screen
        if(self.background1 != nil)
            self.background1.position = CGPointMake(self.background1.position.x-self.goku.velocity.x,self.background1.position.y);
        
        if(self.background2 != nil)
            self.background2.position = CGPointMake(self.background2.position.x-self.goku.velocity.x,self.background2.position.y);
        
        // if goku is traveling right
        if(self.goku.velocity.x > 0){
            if((self.background1.position.x+(self.background1.size.width/2)) < 0){ // reset the background to the begining
                self.background1.position = CGPointMake((self.background2.position.x+(self.background2.size.width)),self.background1.position.y);
                self.currentLevelLocation += 1;
                //myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
            }
            if((self.background2.position.x+(self.background2.size.width/2)) < 0){
                self.background2.position = CGPointMake((self.background1.position.x+(self.background1.size.width)),self.background2.position.y);
                self.currentLevelLocation += 1;
                // myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
            }
        }else{ // else he's traveling left
            if((self.background1.position.x-(self.background1.size.width/2)) > [[UIScreen mainScreen] bounds].size.width){
                self.background1.position = CGPointMake((self.background2.position.x-(self.background2.size.width)),self.background1.position.y);
                self.currentLevelLocation -= 1;
                //myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
            }
            if((self.background2.position.x-(self.background2.size.width/2)) > [[UIScreen mainScreen] bounds].size.width){
                self.background2.position = CGPointMake((self.background1.position.x-(self.background1.size.width)),self.background2.position.y);
                self.currentLevelLocation -= 1;
                //myLabel.text = [NSString stringWithFormat:@"%ld",(long)firstLevel.currentLevelLocation];
            }
        }
    }else{
        self.bgIsMoving = NO;
    }
    
}

-(void)setUpLevelForScene:(SKScene *)scene{
    

    // TODO:
        // Set positions for everything
        // Add childs to the scene
    
    //self.minion.position =
    
    
                                        // 700 = a little after scene 1
    self.finalBoss.position = CGPointMake(800, 40);
    [scene addChild:self.finalBoss];
    
    // minion position 400
    
    
    // may not be necessary to do in this method, we could do in init
    
    
}

-(void)runLevelFor:(SKScene*)scene{
    
    switch (self.currentLevelLocation) {  // activates enemies at necessary times
        case 1:
            // minion 2
            if(!self.finalBoss.isActivated){
                self.finalBoss.isActivated = true;
            }
            break;
        
        case 2:
            
            break;
     
        default:
            break;
    }
    
    
    [self runMovement];
    [self.goku moveBallAlongScene:scene];
    
    
}
-(void)runMovement{
    

    // goku move
    [self.goku moveGoku];
    
    [self.minion1 moveMinionInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    [self.minion2 moveMinionInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    [self.minion3 moveMinionInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    [self.minion4 moveMinionInRelationTo:self.goku andBackgroundFlag:self.bgIsMoving];
    
//    [self.finalBoss]
    // move buu
    
    
    
}

@end
