//
//  WMAMemoryMatchLevelsViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-18.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMAMemoryMatchGameViewController.h"

@class WMAMemoryMatchLevelsViewController;

@protocol WMAMemoryMatchLevelsViewControllerDelegate <NSObject>
- (void)memoryMatchLevelsViewControllerDidGoBack:
(WMAMemoryMatchLevelsViewController *)controller;
- (void)mmMemoryMatchLevelsViewControllerDidGoToMainMenu:
(WMAMemoryMatchLevelsViewController *)controller;
@end


@interface WMAMemoryMatchLevelsViewController : UIViewController <WMAMemoryMatchGameViewControllerDelegate> 

@property (nonatomic, weak) id <WMAMemoryMatchLevelsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *memoryMatchLevelsView;
@property (weak, nonatomic) IBOutlet UIView *memoryMatchLevelsBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *memoryMatchLevelsBackArrowImageView;


- (IBAction)back:(id)sender;
- (void)loadLevelButtons;

@end
