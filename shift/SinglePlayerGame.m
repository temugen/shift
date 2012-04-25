//
//  SinglePlayerGame.m
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinglePlayerGame.h"
#import "MainMenu.h"
#import "GameCenterHub.h"
#import "TutorialLayer.h"
#import "SinglePlayerGameMenu.h"
#import "LevelPack.h"

@implementation SinglePlayerGame

static SinglePlayerGame *lastGame = nil;

+(SinglePlayerGame *) gameWithLevel:(int)level
{
    return [[SinglePlayerGame alloc] initWithLevel:level];
}

+(SinglePlayerGame *) lastGame
{
    return lastGame;
}

-(id) initWithLevel:(int)level
{
    if ((self = [super init])) {
        currentLevel = level;
        
        TutorialLayer *tutorials = [[TutorialLayer alloc] init];
        [self addChild:tutorials];
        
        board = [BoardLayer boardWithDictionary:[[[LevelPack sharedPack] levelWithNumber:currentLevel] objectForKey:@"board"]
                                       cellSize:cellSize];
        board.position = boardCenter;
        [self addChild:board];
        
        lastGame = self;
    }
    return self;
}

-(void) onGameStart
{
  //Your stuff here
  
  [super onGameStart];
}

-(void) onGameEnd
{
  [super onGameEnd];
  
  GKAchievement* achievement = [[GameCenterHub sharedHub] addOrFindIdentifier:@"beat_game"];
  if (![achievement isCompleted]) 
  {
    [[GameCenterHub sharedHub] reportAchievementIdentifier:@"beat_game" percentComplete:100.0];
    [[GameCenterHub sharedHub] achievementCompleted:@"Oh Shift! Conqueror" message:@"Successfully completed a level of Oh Shift!"];
  }
}

+(CCSprite *)previewForLevel:(int)level
{
    if ([[LevelPack sharedPack] levelNameWithNumber:level] == nil) {
        return [CCSprite node];
    }

    BoardLayer *board = [BoardLayer boardWithDictionary:[[[LevelPack sharedPack] levelWithNumber:level] objectForKey:@"board"]
                                               cellSize:CGSizeMake(20, 20)];
    return [board screenshot];
}

-(void) onNextGame
{
    [self removeChild:board cleanup:YES];
    currentLevel++;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger highestLevel = [defaults integerForKey:@"highestLevel"];
    
    //If user beat a new level, save the progress
    if(currentLevel > highestLevel)
    {
        [defaults setInteger:currentLevel forKey:@"highestLevel"];
        [defaults synchronize];
    }

    //If user completed all levels, return to Main Menu (for now). Maybe display some congratulatory message? Fireworks?
    if(currentLevel > [[LevelPack sharedPack] numLevels])
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
    }
    else
    {
        board = [BoardLayer boardWithDictionary:[[[LevelPack sharedPack] levelWithNumber:currentLevel] objectForKey:@"board"]
                                       cellSize:cellSize];
        board.position = boardCenter;
        [self addChild:board];
    }
}

-(void) onPauseButtonPressed:(NSNotification *)notification
{
    InGameMenu *menu = [[SinglePlayerGameMenu alloc] init];
    [super onPauseButtonPressed:notification menu:menu];
}
                             
@end
