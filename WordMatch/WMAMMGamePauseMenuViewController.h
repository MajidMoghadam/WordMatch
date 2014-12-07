//
//  WMAMMGamePauseMenuViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-24.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMAMMGamePauseMenuViewController;

@protocol WMAMMGamePauseMenuViewControllerDelegate <NSObject>
- (void)mmGamePauseMenuViewControllerDidContinue:
(WMAMMGamePauseMenuViewController *)controller;
- (void)mmGamePauseMenuViewControllerDidGoNextLevel:
(WMAMMGamePauseMenuViewController *)controller;
- (void)mmGamePauseMenuViewControllerDidGoToLevelSelection:
(WMAMMGamePauseMenuViewController *)controller;
- (void)mmGamePauseMenuViewControllerDidGoToMainMenu:
(WMAMMGamePauseMenuViewController *)controller;
@end

@interface WMAMMGamePauseMenuViewController : UIViewController

@property (nonatomic, weak) id <WMAMMGamePauseMenuViewControllerDelegate> delegate;

- (IBAction)continueButtonClicked:(id)sender;
- (IBAction)nextLevelButtonClicked:(id)sender;
- (IBAction)levelSelectionButtonClicked:(id)sender;
- (IBAction)mainMenuButtonClicked:(id)sender;

@end
