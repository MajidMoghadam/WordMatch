//
//  WMAMemoryMatchLevelsViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-18.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import "WMAMemoryMatchLevelsViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define IPHONE   UIUserInterfaceIdiomPhone

#define categories [NSArray arrayWithObjects: @"Pets",@"Musical Instruments",@"Vehicles",@"Fruits",@"Countries",@"Colours",@"Vegetables",@"Clothes",@"Professions",@"Numbers",@"Sports",@"Weather",@"Alphabet",@"Home",@"Wild Animals",@"Faces",@"Classroom",@"Food",@"Shapes",@"Winter",nil]

@interface WMAMemoryMatchLevelsViewController (PrivateMethods)
-(NSString *)getUserGameStateValue:(NSString *)forKey;
-(void)saveUserGameStateValue:(NSString *)aValue forAKey:(NSString *)aKey;
@end

@implementation WMAMemoryMatchLevelsViewController
@synthesize memoryMatchLevelsView,delegate, memoryMatchLevelsBackgroundImageView, memoryMatchLevelsBackArrowImageView;

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

-(void)loadLevelButtons{
    
    int WIDTH_OF_LEVEL_IMAGE  = 0;
    int HEIGHT_OF_LEVEL_IMAGE = 0;
    int HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = 0;
    int HORIZONTAL_SPACE_BETWEEN_IMAGES = 0;
    int VERTICAL_SPACE_BEFORE_FIRST_ROW = 0;
    int VERTICAL_SPACE_BETWEEN_IMAGES = 0;
    
    // 5x + 4y = Total Width 
    // where x = HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN & HORIZONTAL_SPACE_BETWEEN_IMAGES
    // and y = WIDTH_OF_LEVEL_IMAGE
    // y ~= 5x
    // 5x + 4(5x) = Total Width
    // 25x = Total Width
    // x = (Total Width)/25
    
    //If your ints are A and B and you want to have ceil(A/B) just calculate (A+B-1)/B
    
    int total_screen_width = [[UIScreen mainScreen] bounds].size.width;
    int x = (total_screen_width + 25 - 1)/25; //HORIZONTAL_SPACE_BETWEEN_IMAGES
    //Keep "x" even (pixel math works out better)
    int num1 = x/2;
    int num2 = num1 * 2;
    if (x != num2) {
        x = x -1;
    }
    
    if (IDIOM==IPHONE) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 2; //16 on iphone 4S
                HORIZONTAL_SPACE_BETWEEN_IMAGES = x - 4; //16
                int remaining_space_for_images = total_screen_width - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_IMAGES);
                WIDTH_OF_LEVEL_IMAGE  = (remaining_space_for_images + 4 - 1)/4; //60;
                
                //If your ints are A and B and you want to have ceil(A/B) just calculate (A+B-1)/B
                HEIGHT_OF_LEVEL_IMAGE = WIDTH_OF_LEVEL_IMAGE+10; //60;
                
                VERTICAL_SPACE_BEFORE_FIRST_ROW =  3*x+2;
                VERTICAL_SPACE_BETWEEN_IMAGES = x-9;
                
                 memoryMatchLevelsBackgroundImageView.frame = CGRectMake(0, 0, 320, 480);

            }
            if(result.height == 568)
            {
                HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 2; //16 on iphone 4S
                HORIZONTAL_SPACE_BETWEEN_IMAGES = x - 4; //16
                int remaining_space_for_images = total_screen_width - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_IMAGES);
                WIDTH_OF_LEVEL_IMAGE  = (remaining_space_for_images + 4 - 1)/4; //60;
                
                //If your ints are A and B and you want to have ceil(A/B) just calculate (A+B-1)/B
                HEIGHT_OF_LEVEL_IMAGE = WIDTH_OF_LEVEL_IMAGE+10; //60;
                
                VERTICAL_SPACE_BEFORE_FIRST_ROW =  3*x+20;
                VERTICAL_SPACE_BETWEEN_IMAGES = x+2;

                memoryMatchLevelsBackgroundImageView.frame = CGRectMake(0, 0, 320, 568);
                
                CGRect frame = memoryMatchLevelsBackArrowImageView.frame;
                //frame.origin.x = newX;
                frame.origin.y = 515;
                //frame.size.width = newWidth;
                //frame.size.height = newHeight;
                memoryMatchLevelsBackArrowImageView.frame = frame;
            }
        }
    }else if(IDIOM==IPAD){
        HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 16; //36 on ipad 2;
        HORIZONTAL_SPACE_BETWEEN_IMAGES = x; //36
        int remaining_space_for_images = total_screen_width - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_IMAGES);
        WIDTH_OF_LEVEL_IMAGE  = (remaining_space_for_images + 4 - 1)/4;
        HEIGHT_OF_LEVEL_IMAGE = WIDTH_OF_LEVEL_IMAGE;
        VERTICAL_SPACE_BEFORE_FIRST_ROW = 3*x+15; // was this 2 * x;
        VERTICAL_SPACE_BETWEEN_IMAGES = x;

    }
    
    //remove all level buttons if any and then reload them
    for(int tagNumber=1; tagNumber <= 20; tagNumber++)
    {
        UIButton *aButton = (UIButton *)[self.view viewWithTag:tagNumber];
        if (aButton != nil) {
            [aButton removeFromSuperview];
        }
    }
    
    
    
    //retrieve the set of categories from the plist data
   // NSMutableDictionary *dictionaryOfCategories = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserGameState" ofType:@"plist"]];
    NSString *memoryMatchLevelStateValue = nil;
    
    
    
    
    for (int levelNumber = 1; levelNumber <= 20; levelNumber++) {
        //get the level state value for the current level
        
        int TempLevelNumberDebugging = levelNumber;
        //use this so all levels have an image.
        //once i create all images, for all levels, then i remove the temp variable 
        //and replace it with levelNumber
        
        //if (levelNumber>=8) {
        //    TempLevelNumberDebugging = 8;
        //}
        
        NSString *currentLevelName = @"MemoryMatch_Level";
        NSString *levelNumberString = [NSString stringWithFormat:@"%d", TempLevelNumberDebugging];
        if (TempLevelNumberDebugging < 10) {
            levelNumberString = [@"0" stringByAppendingString:levelNumberString];
        }
        //convert levelNumber to a string
        
        currentLevelName = [currentLevelName stringByAppendingString:levelNumberString];
        
        //the following call gets the gameState for the level from the UserGameState.plist
        //file. For the first time load, it gets it from the supplied UserGameState.plist 
        //file but once a value is saved to the file, another is created in the
        //documents directory (see the method saveUserGameStateValue)
        NSString *userGameState_CurrentMMGameLevel = [self getUserGameStateValue:currentLevelName];
        memoryMatchLevelStateValue = userGameState_CurrentMMGameLevel; //[dictionaryOfCategories objectForKey:currentLevelName];
        
        //calculate the starting X and Y coordinates of the level image
        //5 rows and 4 in each row
        //each image is 60 px wide and 60 px high
        int currentRow = (int)(floor((levelNumber - 1)/4)) +1;
        int currentColumn = (levelNumber-1)%4+1;
        int startX_topLeft = HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN + HORIZONTAL_SPACE_BETWEEN_IMAGES*(currentColumn-1) + WIDTH_OF_LEVEL_IMAGE*(currentColumn-1);
        int startY_topLeft = VERTICAL_SPACE_BEFORE_FIRST_ROW + VERTICAL_SPACE_BETWEEN_IMAGES*(currentRow-1) + HEIGHT_OF_LEVEL_IMAGE*(currentRow-1);
        
        UIButton *MMLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        MMLevelButton.frame = CGRectMake(startX_topLeft, startY_topLeft, WIDTH_OF_LEVEL_IMAGE, HEIGHT_OF_LEVEL_IMAGE);
        [MMLevelButton addTarget:self action:@selector(buttonPressed:) 
                forControlEvents:UIControlEventTouchUpInside];
        [MMLevelButton setTag:levelNumber];
        
        
        UIImage *MMlevelButtonImageUp = [[UIImage alloc] init];
        UIImage *MMlevelButtonImageDown = [[UIImage alloc] init];
        
        NSString *imageFileNameUp = @"";
        NSString *imageFileNameDown = @"";
        NSString *keyName = [categories objectAtIndex:(levelNumber-1)];
        
        /*
         NSString *imageFileName = [@"Level" stringByAppendingFormat:levelNumberString];
         
        if([memoryMatchLevelStateValue isEqualToString:@"-2"]){
            imageFileName = [imageFileName stringByAppendingFormat:@"_Locked.png"];
        }else if([memoryMatchLevelStateValue isEqualToString:@"-1"] || [memoryMatchLevelStateValue isEqualToString:@"0"]){
            imageFileName = [imageFileName stringByAppendingFormat:@"_0_Stars.png"];
        }else if([memoryMatchLevelStateValue isEqualToString:@"1"]){
            imageFileName = [imageFileName stringByAppendingFormat:@"_1_Stars.png"];
        }else if([memoryMatchLevelStateValue isEqualToString:@"2"]){
            imageFileName = [imageFileName stringByAppendingFormat:@"_2_Stars.png"];
        }else{// if([memoryMatchLevelStateValue isEqualToString:@"3"]){
            imageFileName = [imageFileName stringByAppendingFormat:@"_3_Stars.png"];
        }
         */
        
        imageFileNameUp = [keyName stringByAppendingFormat:@"_level_icon_up.png"];
        imageFileNameDown = [keyName stringByAppendingFormat:@"_level_icon_down.png"];
        //imageFileNameUp = @"Home_level_icon_up.png"; used for testing
        //imageFileNameDown = @"Home_level_icon_down.png";
        
        MMlevelButtonImageUp = [UIImage imageNamed:imageFileNameUp];
        MMlevelButtonImageDown = [UIImage imageNamed:imageFileNameDown];
        
        [MMLevelButton setImage:MMlevelButtonImageDown forState:UIControlStateNormal];
        [MMLevelButton setImage:MMlevelButtonImageUp forState:UIControlStateHighlighted];
        
        
        [memoryMatchLevelsView addSubview:MMLevelButton];
        [self.view bringSubviewToFront:MMLevelButton];
        
    }

}

-(void)buttonPressed:(id)sender{
    
    UIButton* myButton = (UIButton*)sender;
    
    //NSLog(@"Button tag is: %d",myButton.tag);
    NSString *MMSelectedGameLevel = [NSString stringWithFormat:@"%d", myButton.tag];
    NSString *MMSelectedGameLevelToSave = [NSString stringWithFormat:@"%d", myButton.tag];
    
    if (myButton.tag < 10) {
        MMSelectedGameLevel = [@"0" stringByAppendingString:MMSelectedGameLevel];
    }
    
    MMSelectedGameLevel = [@"MemoryMatch_Level" stringByAppendingString:MMSelectedGameLevel];
    
    [self saveUserGameStateValue:MMSelectedGameLevelToSave forAKey:@"currentMMGameLevel"];
    [self performSegueWithIdentifier: @"segueToMMGame" sender: self];
    

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

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
        
//}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLevelButtons];
}


- (void)viewDidUnload
{
    [self setMemoryMatchLevelsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender
{
    [self.delegate memoryMatchLevelsViewControllerDidGoBack:self];
}

#pragma mark - WMAMemoryMatchGameViewControllerDelegate

- (void)mmMemoryMatchGameViewControllerDidGoToLevelSelection:
(WMAMemoryMatchGameViewController *)controller;
{
	[self dismissViewControllerAnimated:YES completion:nil];
    [self loadLevelButtons];
}

- (void)mmMemoryMatchGameViewControllerDidGoToMainMenu:(WMAMemoryMatchGameViewController *)controller;
{
    [self.delegate mmMemoryMatchLevelsViewControllerDidGoToMainMenu:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToMMGame"])
	{
		WMAMemoryMatchGameViewController *memoryMatchGameViewController = segue.destinationViewController;
		memoryMatchGameViewController.delegate = self;
	}
}


@end
