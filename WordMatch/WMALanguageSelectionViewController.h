//
//  WMALanguageSelectionViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 12-04-14.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMALanguageSelectionViewController;

@protocol WMALanguageSelectionViewControllerDelegate <NSObject>
- (void)languageSelectionViewControllerDidGoBack:
(WMALanguageSelectionViewController *)controller;
@end

@interface WMALanguageSelectionViewController : UIViewController

@property (nonatomic, weak) id <WMALanguageSelectionViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *englishCheckMark;
@property (weak, nonatomic) IBOutlet UIImageView *frenchCheckMark;
@property (weak, nonatomic) IBOutlet UIImageView *spanishCheckMark;

- (IBAction)back:(id)sender;
- (IBAction)pressLanguageButtonEnglish:(id)sender;
- (IBAction)pressLanguageButtonFrench:(id)sender;
- (IBAction)pressLanguageButtonSpanish:(id)sender;

@end
