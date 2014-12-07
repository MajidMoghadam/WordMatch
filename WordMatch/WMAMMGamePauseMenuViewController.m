//
//  WMAMMGamePauseMenuViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-24.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import "WMAMMGamePauseMenuViewController.h"

@implementation WMAMMGamePauseMenuViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[self initialDelayEnded];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)continueButtonClicked:(id)sender
{
    [self.delegate mmGamePauseMenuViewControllerDidContinue:self];
}

- (IBAction)nextLevelButtonClicked:(id)sender
{
    [self.delegate mmGamePauseMenuViewControllerDidGoNextLevel:self];
}

- (IBAction)levelSelectionButtonClicked:(id)sender
{
    [self.delegate mmGamePauseMenuViewControllerDidGoToLevelSelection:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StartBackgroundMusicNotification"
     object:self];
}

- (IBAction)mainMenuButtonClicked:(id)sender
{
    [self.delegate mmGamePauseMenuViewControllerDidGoToMainMenu:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StartBackgroundMusicNotification"
     object:self];
}



@end
