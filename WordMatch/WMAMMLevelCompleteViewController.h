//
//  WMAMMLevelCompleteViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 12-04-10.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMAMMLevelCompleteViewController;

@protocol WMAMMLevelCompleteViewControllerDelegate <NSObject>
- (void)mmLevelCompleteViewControllerDidReloadLevel:
(WMAMMLevelCompleteViewController *)controller;
- (void)mmLevelCompleteViewControllerDidGoNextLevel:
(WMAMMLevelCompleteViewController *)controller;
- (void)mmLevelCompleteViewControllerDidGoToLevelSelection:
(WMAMMLevelCompleteViewController *)controller;
- (void)mmLevelCompleteViewControllerDidGoToMainMenu:
(WMAMMLevelCompleteViewController *)controller;
@end

@interface WMAMMLevelCompleteViewController : UIViewController

@property (nonatomic, weak) id <WMAMMLevelCompleteViewControllerDelegate> delegate;

- (IBAction)reloadSameLevelButtonClicked:(id)sender;
- (IBAction)nextLevelButtonClicked:(id)sender;
- (IBAction)levelSelectionButtonClicked:(id)sender;
- (IBAction)mainMenuButtonClicked:(id)sender;

@end
