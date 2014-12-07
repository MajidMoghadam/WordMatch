//
//  WMAMainMenuViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-17.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import <UIKit/UIKit.h>
#import "WMAMemoryMatchLevelsViewController.h"
#import "WMALanguageSelectionViewController.h"
#import "WMAFlashCardsGameViewController.h"

#import "WMAAboutUsViewController.h"

@interface WMAMainMenuViewController : UIViewController <WMAMemoryMatchLevelsViewControllerDelegate,WMALanguageSelectionViewControllerDelegate,
    WMAAboutUsViewControllerDelegate,WMAFlashCardsGameViewControllerDelegate>

@property (strong, nonatomic)  AVAudioPlayer *theNewAudio;
@property (weak, nonatomic) IBOutlet UIView *buttonImageView;

- (IBAction)goToAppReviewPage;

@end
