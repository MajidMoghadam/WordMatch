//
//  WMAAboutUsViewController.h
//  WordMatch
//
//  Created by Majid Moghadam on 2013-04-11.
//  Copyright (c) 2013 individual. All rights reserved.
//


#import <UIKit/UIKit.h>

@class WMAAboutUsViewController;

@protocol WMAAboutUsViewControllerDelegate <NSObject>
- (void)aboutUsViewControllerDidGoBack:
(WMAAboutUsViewController *)controller;
@end

@interface WMAAboutUsViewController : UIViewController

@property (nonatomic, weak) id <WMAAboutUsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *linkVikki;
@property (weak, nonatomic) IBOutlet UITextView *linkJoel;
@property (weak, nonatomic) IBOutlet UITextView *linkStephanie;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *backButtonView;

- (IBAction)back:(id)sender;
- (IBAction)goToVikkiWebsite;
- (IBAction)goToJoelWebsite;
- (IBAction)goToStephanieWebsite;


@end

