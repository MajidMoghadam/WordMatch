//
//  WMAFlashCardsGameViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 2013-02-25.
//  Copyright (c) 2013 individual. All rights reserved.
//

#import "WMAFlashCardsPauseMenuViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Card.h"

@class WMAFlashCardsGameViewController;

@protocol WMAFlashCardsGameViewControllerDelegate <NSObject>
- (void)mmWMAFlashCardsGameViewControllerDidGoToMainMenu:
(WMAFlashCardsGameViewController *)controller;
@end

@interface WMAFlashCardsGameViewController : UIViewController<WMAFlashCardsPauseMenuViewControllerDelegate>
{
    int categoryID;
    int pictureID;
    NSString *keyName;
    
}


@property (nonatomic, weak) id <WMAFlashCardsGameViewControllerDelegate> delegate;
@property (nonatomic,retain) NSString *selectedLanguage;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@property (nonatomic,retain)  NSArray *arrayOfAllCardCategories;
@property (nonatomic,retain)  NSMutableArray *arrayOfCardInfoFromPlist;
@property (weak, nonatomic) IBOutlet UILabel *imageName;
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UIView *speedSliderView;
@property (nonatomic,retain)  NSMutableDictionary *dictionaryOfCardSets;
@property int categoryID;
@property int pictureID;
@property NSString *keyName;
@property NSTimer *myTimer;
@property (strong, nonatomic)  AVAudioPlayer *theNewAudio;
@property int sliderSpeedValue;

@end
