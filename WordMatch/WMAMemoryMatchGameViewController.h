//
//  WMAMemoryMatchGameViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-21.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WMAMMGamePauseMenuViewController.h"
#import "WMAMMLevelCompleteViewController.h"
#import "Card.h"

@class WMAMemoryMatchGameViewController;

@protocol WMAMemoryMatchGameViewControllerDelegate <NSObject>
- (void)mmMemoryMatchGameViewControllerDidGoToLevelSelection:
(WMAMemoryMatchGameViewController *)controller;
- (void)mmMemoryMatchGameViewControllerDidGoToMainMenu:
(WMAMemoryMatchGameViewController *)controller;
@end

@interface WMAMemoryMatchGameViewController : UIViewController<WMAMMGamePauseMenuViewControllerDelegate,WMAMMLevelCompleteViewControllerDelegate>
{
    NSTimer  *myTimer;
    CGPoint starPosition;
    int tagNumberCongratsObjects;
    int WIDTH_OF_CARD;
    int HEIGHT_OF_CARD;
    int HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN;
    int HORIZONTAL_SPACE_BETWEEN_CARDS;
    int VERTICAL_SPACE_BEFORE_FIRST_ROW;
    int VERTICAL_SPACE_BETWEEN_CARDS;
    int SCREEN_WIDTH;
    int SCREEN_HEIGHT;
    int STAR_WIDTH;
    int STAR_HEIGHT;
}


@property (nonatomic, weak) id <WMAMemoryMatchGameViewControllerDelegate> delegate;

@property (nonatomic,retain)  NSMutableArray *arrayOfTwentyCards;
@property (nonatomic,retain)  NSArray *arrayOfAllCardCategories;
//@property (nonatomic,retain)  NSArray *starArrangements;
@property (nonatomic,retain)  NSMutableArray *selectedPairOfCards;
@property (nonatomic,retain)  NSMutableArray *selectedStarsOnBackOfCards;
@property (nonatomic,retain)  NSMutableArray *arrayOfParticleImages;
@property (nonatomic,assign)  NSInteger      numberOfImagesFlipped;
@property (nonatomic,assign)  NSInteger      numberOfImagesRemainingUnmatched;
@property (nonatomic,assign)  NSInteger      totalStarsEarnedInLevel;
@property (nonatomic,assign)  NSInteger      totalTimeInSecondsElapsed;
@property (nonatomic,assign)  NSInteger      totalNumberOfCardFlips;
@property (nonatomic,retain)  Card  *previousFlippedCard;
@property (nonatomic, assign) NSInteger currentMMGameLevel;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *timerDisplay;
@property (nonatomic, retain) NSTimer  *stopWatchTimer;
@property (nonatomic, retain) NSDate  *startDate;
@property (nonatomic,retain) UIImage *starTrailImage;
@property (nonatomic, retain) UIImage* flakeImage;
@property (nonatomic,retain) NSString *selectedLanguage;
@property (weak, nonatomic) IBOutlet UIView *matchGameView;
@property (strong, nonatomic)  AVAudioPlayer *theNewAudio;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
//@property (weak, nonatomic) IBOutlet UIImageView *starPlaceHolderOne;
//@property (weak, nonatomic) IBOutlet UIImageView *starPlaceHolderTwo;
//@property (weak, nonatomic) IBOutlet UIImageView *starPlaceHolderThree;

-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event;
-(NSString *)getCurrentMMGameLevel;
-(void)loadMMGameLevel:(NSString *)aLevel;
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
//-(void)updateTotalNumberOfStarsImages;
- (IBAction)reLoadMMGameLevel:(id)sender;
@end
