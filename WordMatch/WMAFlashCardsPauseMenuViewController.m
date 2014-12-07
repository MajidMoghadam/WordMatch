//
//  WMAFlashCardsPauseMenuViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 2014-05-04.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import "WMAFlashCardsPauseMenuViewController.h"

@interface WMAFlashCardsPauseMenuViewController ()

@end

@implementation WMAFlashCardsPauseMenuViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)continueButtonClicked:(id)sender
{
    [self.delegate mmFlashCardsPauseMenuViewControllerDidContinue:self];
}

- (IBAction)mainMenuButtonClicked:(id)sender
{
    [self.delegate mmFlashCardsPauseMenuViewControllerDidGoToMainMenu:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StartBackgroundMusicNotification"
     object:self];
}

@end
