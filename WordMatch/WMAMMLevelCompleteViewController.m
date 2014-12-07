//
//  WMAMMLevelCompleteViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 12-04-10.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import "WMAMMLevelCompleteViewController.h"

@interface WMAMMLevelCompleteViewController ()

@end

@implementation WMAMMLevelCompleteViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)reloadSameLevelButtonClicked:(id)sender
{
    [self.delegate mmLevelCompleteViewControllerDidReloadLevel:self];
}

- (IBAction)nextLevelButtonClicked:(id)sender
{
    [self.delegate mmLevelCompleteViewControllerDidGoNextLevel:self];
}

- (IBAction)levelSelectionButtonClicked:(id)sender
{
    [self.delegate mmLevelCompleteViewControllerDidGoToLevelSelection:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StartBackgroundMusicNotification"
     object:self];
}

- (IBAction)mainMenuButtonClicked:(id)sender
{
    [self.delegate mmLevelCompleteViewControllerDidGoToMainMenu:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StartBackgroundMusicNotification"
     object:self];
}


@end
