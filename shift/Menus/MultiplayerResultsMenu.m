//
//  MultiplayerResultsMenu.m
//  shift
//
//  Created by Brad Misik on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiplayerResultsMenu.h"
#import "GameCenterHub.h"
#import "RoundedRectangle.h"

@implementation MultiplayerResultsMenu

-(id) initWithMatch:(OhShiftMatchData *)match
{
    if ((self = [super init])) {
        [self addBackButton];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        NSString *myName, *partnerName;
        NSTimeInterval myTime, partnerTime;
        int myMoves, partnerMoves;
        if ([match.p1id isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            myName = match.p1alias;
            myMoves = match.p1moves;
            myTime = match.p1time;
            partnerName = match.p2alias;
            partnerMoves = match.p2moves;
            partnerTime = match.p2time;
        }
        else {
            myName = match.p2alias;
            myMoves = match.p2moves;
            myTime = match.p2time;
            partnerName = match.p1alias;
            partnerMoves = match.p1moves;
            partnerTime = match.p1time;
        }
        
        CCLabelTTF *winLose;
        if (myTime < partnerTime) {
            winLose = [CCLabelTTF labelWithString:@"You won!" fontName:platformFontName fontSize:platformFontSize*1.5];
        }
        else {
            winLose = [CCLabelTTF labelWithString:@"You lost!" fontName:platformFontName fontSize:platformFontSize*1.5];
        }
        winLose.color = ccBLACK;
        [winLose addStrokeWithSize:1 color:ccWHITE];
        winLose.position = ccp(screenSize.width / 2, screenSize.height - platformPadding - winLose.contentSize.height / 2);
        
        CCLabelTTF *myNameLabel = [CCLabelTTF labelWithString:myName fontName:platformFontName fontSize:platformFontSize];
        myNameLabel.color = ccBLACK;
        [myNameLabel addStrokeWithSize:1 color:ccWHITE];
        
        CCLabelTTF *partnerNameLabel = [CCLabelTTF labelWithString:partnerName fontName:platformFontName fontSize:platformFontSize];
        partnerNameLabel.color = ccBLACK;
        [partnerNameLabel addStrokeWithSize:1 color:ccWHITE];
        
        int myMin = myTime / 60;
        float mySec = myTime - (myMin * 60);
        CCLabelTTF *myTimeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d:%0.2f", myMin, mySec]
                                                   fontName:platformFontName fontSize:platformFontSize];
        myTimeLabel.color = ccWHITE;
        [myTimeLabel addStrokeWithSize:1 color:ccBLACK];
        
        CCLabelTTF *myMovesLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d moves", myMoves]
                                                    fontName:platformFontName fontSize:platformFontSize];
        myMovesLabel.color = ccWHITE;
        [myMovesLabel addStrokeWithSize:1 color:ccBLACK];
        
        int partnerMin = partnerTime / 60;
        float partnerSec = partnerTime - (partnerMin * 60);
        CCLabelTTF *partnerTimeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d:%0.2f", partnerMin, partnerSec]
                                                     fontName:platformFontName fontSize:platformFontSize];
        partnerTimeLabel.color = ccWHITE;
        [partnerTimeLabel addStrokeWithSize:1 color:ccBLACK];
        
        CCLabelTTF *partnerMovesLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d moves", partnerMoves]
                                                      fontName:platformFontName fontSize:platformFontSize];
        partnerMovesLabel.color = ccWHITE;
        [partnerMovesLabel addStrokeWithSize:1 color:ccBLACK];
        
        RoundedRectangle *myRect = [[RoundedRectangle alloc] initWithWidth:(screenSize.width / 2 - platformPadding * 1.5)
                                                                    height:(screenSize.height - platformPadding * 3 - winLose.contentSize.height) pressed:NO];
        RoundedRectangle *partnerRect = [[RoundedRectangle alloc] initWithWidth:myRect.contentSize.width
                                                                         height:myRect.contentSize.height pressed:NO];
        
        myRect.position = ccp(platformPadding + myRect.contentSize.width / 2,
                              winLose.position.y - winLose.contentSize.height / 2 - platformPadding - myRect.contentSize.height / 2);
        partnerRect.position = ccp(screenSize.width - myRect.position.x, myRect.position.y);
        
        myNameLabel.position = partnerNameLabel.position = ccp(myRect.contentSize.width / 2,
                                                             myRect.contentSize.height - platformPadding * 2 - myNameLabel.contentSize.height / 2);
        myTimeLabel.position = partnerTimeLabel.position = ccp(myNameLabel.position.x,
                                                               myNameLabel.position.y - platformPadding * 2 - myTimeLabel.contentSize.height / 2);
        myMovesLabel.position = partnerMovesLabel.position = ccp(myTimeLabel.position.x,
                                                                 myTimeLabel.position.y - platformPadding * 2 - myMovesLabel.contentSize.height / 2);
        
        [myRect addChild:myNameLabel];
        [myRect addChild:myTimeLabel];
        [myRect addChild:myMovesLabel];
        [partnerRect addChild:partnerNameLabel];
        [partnerRect addChild:partnerTimeLabel];
        [partnerRect addChild:partnerMovesLabel];
        [self addChild:winLose];
        [self addChild:myRect];
        [self addChild:partnerRect];
    }
    
    return self;
}

@end
