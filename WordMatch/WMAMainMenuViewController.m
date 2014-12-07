//
//  WMAMainMenuViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-17.
//  Copyright (c) 2012 individual. All rights reserved.
//



#import "WMAMainMenuViewController.h"
#import "Utility.h"

@implementation WMAMainMenuViewController

@synthesize buttonImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)PlaySound:(NSString *)aSoundFile
{
    
    NSString *imageSoundFile = aSoundFile; //card.imageSoundFile; //@"lightning.mp3"; //
    /*
     NSArray *chunks = [imageSoundFile componentsSeparatedByString: @"."];
     NSString *squishPath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
     NSURL *squishURL = [NSURL fileURLWithPath:squishPath];
     SystemSoundID squishSoundID;
     AudioServicesCreateSystemSoundID((__bridge_retained  CFURLRef)squishURL, &squishSoundID);
     AudioServicesPlaySystemSound(squishSoundID);
     */
    
    NSArray *chunks = [imageSoundFile componentsSeparatedByString: @"."];
    NSString *squishPath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
    NSURL *soundurl = [NSURL fileURLWithPath:squishPath];
    NSError *error = nil;
    
    
    //NSURL *soundurl   = [[NSBundle mainBundle] URLForResource: @"mysound" withExtension: @"caf"];
    _theNewAudio =[[AVAudioPlayer alloc] initWithContentsOfURL:soundurl error:&error];
    _theNewAudio.volume=0.2; //between 0 and 1
    [_theNewAudio prepareToPlay];
    _theNewAudio.numberOfLoops=-1; //or more if needed
    
    [_theNewAudio play];
}

- (void) receivedEndMusicNotification:(NSNotification *) notification
{
    [_theNewAudio stop];
}

- (void) receivedStartMusicNotification:(NSNotification *) notification
{
    [_theNewAudio play];
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
    [self PlaySound:@"background_music.mp3"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedEndMusicNotification:)
                                                 name:@"EndBackgroundMusicNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedStartMusicNotification:)
                                                 name:@"StartBackgroundMusicNotification"
                                               object:nil];
    
    if ( IS_IPHONE_4_OR_LESS )
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat widthOfScreen  = screenSize.width;
        CGFloat heightOfScreen = screenSize.height;
        buttonImageView.center = CGPointMake(widthOfScreen/2, heightOfScreen-buttonImageView.frame.size.height/2);
        
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - WMAMemoryMatchLevelsViewControllerDelegate

#define APP_URL_STRING  @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=821926685&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"

- (IBAction)goToAppReviewPage{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: APP_URL_STRING]];
}

- (void)memoryMatchLevelsViewControllerDidGoBack:
(WMAMemoryMatchLevelsViewController *)controller;
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)languageSelectionViewControllerDidGoBack:
(WMALanguageSelectionViewController *)controller;
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)aboutUsViewControllerDidGoBack:
(WMAAboutUsViewController *)controller;
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mmMemoryMatchLevelsViewControllerDidGoToMainMenu:
(WMAMemoryMatchLevelsViewController *)controller;
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mmWMAFlashCardsGameViewControllerDidGoToMainMenu:
(WMAFlashCardsGameViewController *)controller;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToMMLevels"])
	{
		WMAMemoryMatchLevelsViewController *memoryMatchLevelsViewController = segue.destinationViewController;
		memoryMatchLevelsViewController.delegate = self;
	}
    if ([segue.identifier isEqualToString:@"segueToLanguageSelection"])
	{
		WMALanguageSelectionViewController *languageSelectionViewController = segue.destinationViewController;
		languageSelectionViewController.delegate = self;
	}
    if ([segue.identifier isEqualToString:@"segueToAboutUs"])
	{
		WMAAboutUsViewController *aboutUsViewController = segue.destinationViewController;
		aboutUsViewController.delegate = self;
	}
    if ([segue.identifier isEqualToString:@"segueToFlashCards"])
	{
		WMAFlashCardsGameViewController *flashCardsGameViewController = segue.destinationViewController;
		flashCardsGameViewController.delegate = self;
	}
    


}

@end
