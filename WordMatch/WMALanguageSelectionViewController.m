//
//  WMALanguageSelectionViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 12-04-14.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import "WMALanguageSelectionViewController.h"

@interface WMALanguageSelectionViewController ()

@end

@implementation WMALanguageSelectionViewController
@synthesize delegate, englishCheckMark, frenchCheckMark, spanishCheckMark;

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
    
    [self setLanguageButtonStates];
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

- (IBAction)back:(id)sender
{
    [self.delegate languageSelectionViewControllerDidGoBack:self];
}

-(IBAction) pressLanguageButtonEnglish:(id)sender{
    [self saveUserGameStateValue:@"English" forAKey:@"languageSelected"];
    
    [self setLanguageButtonStates];
    
}

-(IBAction) pressLanguageButtonFrench:(id)sender{
    [self saveUserGameStateValue:@"French" forAKey:@"languageSelected"];
    
    [self setLanguageButtonStates];
    
}

-(IBAction) pressLanguageButtonSpanish:(id)sender{
    [self saveUserGameStateValue:@"Spanish" forAKey:@"languageSelected"];
    
    [self setLanguageButtonStates];
    
}

-(void)saveUserGameStateValue:(NSString *)aValue forAKey:(NSString *)aKey{
    BOOL success;
	NSError *error;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"UserGameState.plist"];
	
	success = [fileManager fileExistsAtPath:filePath];
	if (!success) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"UserGameState" ofType:@"plist"];
		success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
	}
	
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	
	[plistDict setValue:aValue forKey:aKey];
	[plistDict writeToFile:filePath atomically: YES];
}

-(NSString *)getUserGameStateValue:(NSString *)forKey{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserGameState.plist"]; //3
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"UserGameState" ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    //load from savedStock example int value
    NSString *value = [savedStock objectForKey:forKey];
    return value;
}

-(void) setLanguageButtonStates{
    NSString *selectedLanguage = [self getUserGameStateValue:@"languageSelected"];
    
    UIButton *englishButton = (UIButton *)[self.view viewWithTag:1];
    UIButton *frenchButton = (UIButton *)[self.view viewWithTag:2];
    UIButton *spanishButton = (UIButton *)[self.view viewWithTag:3];
    
    if ([selectedLanguage isEqualToString:@"English"]) {
        UIImage *englishButtonDown =  [UIImage imageNamed: @"EnglishButton_down.png"];
        [englishButton setImage:englishButtonDown forState:UIControlStateNormal];
        UIImage *frenchButtonUp =  [UIImage imageNamed: @"FrenchButton_up.png"];
        [frenchButton setImage:frenchButtonUp forState:UIControlStateNormal];
        UIImage *spanishButtonUp =  [UIImage imageNamed: @"SpanishButton_up.png"];
        [spanishButton setImage:spanishButtonUp forState:UIControlStateNormal];
        
        englishCheckMark.hidden = false;
        frenchCheckMark.hidden = true;
        spanishCheckMark.hidden = true;
        
    }else if([selectedLanguage isEqualToString:@"French"]){
        UIImage *englishButtonDown =  [UIImage imageNamed: @"EnglishButton_up.png"];
        [englishButton setImage:englishButtonDown forState:UIControlStateNormal];
        UIImage *frenchButtonUp =  [UIImage imageNamed: @"FrenchButton_down.png"];
        [frenchButton setImage:frenchButtonUp forState:UIControlStateNormal];
        UIImage *spanishButtonUp =  [UIImage imageNamed: @"SpanishButton_up.png"];
        [spanishButton setImage:spanishButtonUp forState:UIControlStateNormal];
        
        englishCheckMark.hidden = true;
        frenchCheckMark.hidden = false;
        spanishCheckMark.hidden = true;
        
    }else if([selectedLanguage isEqualToString:@"Spanish"]){
        UIImage *englishButtonDown =  [UIImage imageNamed: @"EnglishButton_up.png"];
        [englishButton setImage:englishButtonDown forState:UIControlStateNormal];
        UIImage *frenchButtonUp =  [UIImage imageNamed: @"FrenchButton_up.png"];
        [frenchButton setImage:frenchButtonUp forState:UIControlStateNormal];
        UIImage *spanishButtonUp =  [UIImage imageNamed: @"SpanishButton_down.png"];
        [spanishButton setImage:spanishButtonUp forState:UIControlStateNormal];
        
        englishCheckMark.hidden = true;
        frenchCheckMark.hidden = true;
        spanishCheckMark.hidden = false;
    }


}

@end
