//
//  WMAAboutUsViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 2013-04-11.
//  Copyright (c) 2013 individual. All rights reserved.
//

#import "WMAAboutUsViewController.h"
#import "Utility.h"

@interface WMAAboutUsViewController ()

@end

@implementation WMAAboutUsViewController
@synthesize delegate,linkJoel,linkVikki,linkStephanie,scrollView,backButtonView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.linkVikki.editable = NO;
        self.linkVikki.dataDetectorTypes = UIDataDetectorTypeLink;
        self.linkStephanie.editable = NO;
        self.linkStephanie.dataDetectorTypes = UIDataDetectorTypeLink;
        self.linkJoel.editable = NO;
        self.linkJoel.dataDetectorTypes = UIDataDetectorTypeLink;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (IS_IPHONE_4_OR_LESS){
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat heightOfScreen = screenSize.height;
        backButtonView.center = CGPointMake(backButtonView.center.x , heightOfScreen-backButtonView.frame.size.height/2-5);
    }
    
    // Enable scrolling for portrait
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 600);
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.delegate aboutUsViewControllerDidGoBack:self];
}

- (IBAction)goToVikkiWebsite{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.vickiwenderlich.com"]];
}
- (IBAction)goToJoelWebsite{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.jrlanglois.com"]];
}
- (IBAction)goToStephanieWebsite{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://stephanielawrence.ca"]];
}

@end
