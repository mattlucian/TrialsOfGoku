//
//  FirstLevel.m
//  trialsofgoku
//
//  Created by Matt on 11/16/14.
//  Copyright (c) 2014 Matt Myers. All rights reserved.
//

#import "FirstLevel.h"

@implementation FirstLevel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.levelRange = 20;
        self.currentLevelLocation = 0;
        self.alreadySpawned = false;
        
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
            if(!self.finalBoss.isActivated){
                self.finalBoss.isActivated = true;
            }
            break;
        
        case 2:
            
            break;
     
        default:
            break;
    }
}

@end
