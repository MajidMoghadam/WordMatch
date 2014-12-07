//
//  WMAFlashCardsPauseMenuViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 2014-05-04.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMAFlashCardsPauseMenuViewController;

@protocol WMAFlashCardsPauseMenuViewControllerDelegate <NSObject>
- (void)mmFlashCardsPauseMenuViewControllerDidContinue:
(WMAFlashCardsPauseMenuViewController *)controller;
- (void)mmFlashCardsPauseMenuViewControllerDidGoToMainMenu:
(WMAFlashCardsPauseMenuViewController *)controller;
@end

@interface WMAFlashCardsPauseMenuViewController : UIViewController

@property (nonatomic, weak) id <WMAFlashCardsPauseMenuViewControllerDelegate> delegate;

- (IBAction)continueButtonClicked:(id)sender;
- (IBAction)mainMenuButtonClicked:(id)sender;

@end
