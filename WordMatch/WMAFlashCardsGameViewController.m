//
//  WMAFlashCardGameViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 2013-02-25.
//  Copyright (c) 2013 individual. All rights reserved.
//

#import "WMAFlashCardsGameViewController.h"
#import "Utility.h"

#define categories [NSArray arrayWithObjects: @"Pets",@"Musical Instruments",@"Vehicles",@"Fruits",@"Countries",@"Colours",@"Vegetables",@"Clothes",@"Professions",@"Numbers",@"Sports",@"Weather",@"Alphabet",@"Home",@"Wild Animals",@"Faces",@"Classroom",@"Food",@"Shapes",@"Winter",nil]

#define DEFAULT_SLIDER_SPEED_VALUE 3

@interface WMAFlashCardsGameViewController ()
    
@end

@implementation WMAFlashCardsGameViewController

@synthesize arrayOfAllCardCategories, imageName, cardImage, dictionaryOfCardSets, categoryID, pictureID, myTimer,sliderSpeedValue, keyName, arrayOfCardInfoFromPlist, speedSliderView;

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
    
    categoryID = 0;
    pictureID = 0;
    
    if ( IS_IPHONE_4_OR_LESS )
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat widthOfScreen  = screenSize.width;
        CGFloat heightOfScreen = screenSize.height;
        speedSliderView.center = CGPointMake(widthOfScreen/2, heightOfScreen-speedSliderView.frame.size.height/2);
        
        imageName.center = CGPointMake(imageName.center.x, imageName.center.y - 75);
        cardImage.center = CGPointMake(cardImage.center.x, cardImage.center.y - 50);

    }
    
    keyName = [categories objectAtIndex:categoryID];
    
    arrayOfCardInfoFromPlist = [[NSMutableArray alloc] init];
    
    //retrieve the set of cards from the plist data
    dictionaryOfCardSets = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Card-Info" ofType:@"plist"]];

    
    _synthesizer = [[AVSpeechSynthesizer alloc] init];
    
    _selectedLanguage = [self getUserGameStateValue:@"languageSelected"];
    
    imageName.text = @"";
    
    sliderSpeedValue = DEFAULT_SLIDER_SPEED_VALUE;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EndBackgroundMusicNotification"
     object:self];
    
    [self showImageForDictionaryID:categoryID forPictureID:pictureID];
    
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:sliderSpeedValue target:self  selector:@selector(onTimer_ShowFlashCard:) userInfo:nil repeats:YES];
    
}


// Timer event is called whenever the timer fires
- (void)onTimer_ShowFlashCard:(NSTimer *)timer
{
    int maxCategoryID = 19; //PAID APP
    
#ifdef FREE
    maxCategoryID = 3; //first 4 categories ALLOWED FOR free app
#else
    maxCategoryID = 19; //all 20 categories for paid app
#endif
    
    arrayOfCardInfoFromPlist = [dictionaryOfCardSets objectForKey:keyName];
    int maxPictureIndex = (int)[arrayOfCardInfoFromPlist count] - 1;
    
    if ((pictureID==maxPictureIndex)&&(categoryID==maxCategoryID)) {
        categoryID=0;
        pictureID = 0;
        keyName = [categories objectAtIndex:categoryID];
    }else if (pictureID == maxPictureIndex) {
        pictureID = 0;
        categoryID++;
        keyName = [categories objectAtIndex:categoryID];
    }else{
        pictureID++;
    }
    
    [self showImageForDictionaryID:categoryID forPictureID:pictureID];

}

-(void)showImageForDictionaryID:(int)catID forPictureID:(int)picID{
    //NSString *keyName = [categories objectAtIndex:catID];
    
    int WIDTH_OF_CARD = 320;
    int HEIGHT_OF_CARD = 480;
    
    //NSMutableArray *arrayOfCardInfoFromPlist = [[NSMutableArray alloc] init];
    
    
    //the following array has a size of arrayOfCardInfoFromPlist.count
    //this represents the number of objects/words in the category
    //only ten will randomly be selected for the match game
    arrayOfCardInfoFromPlist = [dictionaryOfCardSets objectForKey:keyName];
    
    //shuffle the array to randomize the order
    //we will only select the first ten elements of the array after shuffling
    ////[self shuffle:arrayOfCardInfoFromPlist];
    
    //use the keyName to display the Category Name title on page view
    ////categoryName.text = keyName;
    
    ////arrayOfTwentyCards = [[NSMutableArray alloc] init] ;
    ////selectedPairOfCards = [[NSMutableArray alloc] init];
    //selectedStarsOnBackOfCards = [[NSMutableArray alloc] init];
    NSMutableDictionary* cardInfo;
    //UIImage *cardImage;
    
    
    //load the data from the arrayOfCardInfoFromPlist array into ten Card objects, and store this in an array, arrayOfTenCards
    //only the first 10 elements of the arrayOfCardInfoFromPlist array will be taken
    //for (int cardIndex = 0; cardIndex < 20; cardIndex++) {
    //get the card info for the card with the current cardIndex number
    //the %10 repeats the first 10 elements to get pairs
    //for each the the first 10
    int arrayOfCardInfoFromPlistIndex = picID;
    cardInfo = [[NSMutableDictionary alloc] initWithDictionary:[arrayOfCardInfoFromPlist objectAtIndex:arrayOfCardInfoFromPlistIndex]];
    //create a Card object and fill this Card object with values from the cardInfo dictionary object above
    CGRect viewRect = CGRectMake(0, 0,WIDTH_OF_CARD, HEIGHT_OF_CARD);
    Card *aCard = [[Card alloc] initWithFrame:viewRect];
    ////[aCard setTag:(cardIndex+1)];
    aCard.cardId = arrayOfCardInfoFromPlistIndex;
    aCard.cardIsFaceUp = TRUE;
    aCard.englishText = [cardInfo objectForKey:@"EnglishText"];
    aCard.frenchText = [cardInfo objectForKey:@"FrenchText"];
    aCard.spanishText = [cardInfo objectForKey:@"SpanishText"];
    aCard.imageFile = [[[keyName stringByAppendingString:@"_"]
                        stringByAppendingString:[cardInfo objectForKey:@"EnglishText"]]
                       stringByAppendingString:@".png"];
    aCard.imageSoundFile = [cardInfo objectForKey:@"ImageSoundFile"];
    aCard.englishTextSoundFile = [[cardInfo objectForKey:@"EnglishText"] stringByAppendingString:@"_E.mp3"];
    aCard.frenchTextSoundFile = [[cardInfo objectForKey:@"EnglishText"] stringByAppendingString:@"_F.mp3"];
    
    
    //Display the text on the flashcard label
    NSString *flashCardLabel;
    if ([_selectedLanguage isEqualToString:@"English"]){
        flashCardLabel =aCard.englishText;
    }else if([_selectedLanguage isEqualToString:@"French"]){
        flashCardLabel =aCard.frenchText;
    }else if([_selectedLanguage isEqualToString:@"Spanish"]){
        flashCardLabel =aCard.spanishText;
    }
    
    NSArray *chunks = [aCard.imageFile componentsSeparatedByString: @"."];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
    //cardImage.image =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    //sound out the text on the flash card label
    //[self textToSpeech:imageName.text];
    if (sliderSpeedValue >= 3) {
        [self performSelector:@selector(setFlashCardImage:) withObject:imagePath afterDelay:0.0];
        [self performSelector:@selector(textToSpeech:) withObject:flashCardLabel afterDelay:sliderSpeedValue-2];
        [self performSelector:@selector(setFlashCardLabel:) withObject:flashCardLabel afterDelay:sliderSpeedValue-2];
    }else{
        [self textToSpeech:flashCardLabel];
        [self setFlashCardLabel:flashCardLabel];
        cardImage.image =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    
}

-(void)setFlashCardImage:(NSString*)anImagePath{
    cardImage.image =  [[UIImage alloc] initWithContentsOfFile:anImagePath];
}

-(void)setFlashCardLabel:(NSString*)aWord{
    imageName.text = aWord;
    [imageName setAdjustsFontSizeToFitWidth:TRUE];
    [self fadein];
}

-(void) fadein
{
    imageName.alpha = .6;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //don't forget to add delegate.....
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:1];
    imageName.alpha = 1;
    
    //also call this before commit animations......
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished    context:(void *)context {
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        imageName.alpha = 0;
        [UIView commitAnimations];
    }
}

-(void)textToSpeech:(NSString*)aWord{
    
#define MY_SPEECH_RATE  0.1666
#define MY_SPEECH_MPX  1.55
#define LOUDNESS 1.0
#define LOUDNESS_ENGLISH 0.8
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:aWord];
    [utterance setRate:MY_SPEECH_RATE];
    [utterance setPitchMultiplier:MY_SPEECH_MPX];
    [utterance setVolume:LOUDNESS];
    if ([_selectedLanguage isEqualToString:@"English"]){
        [utterance setVolume:LOUDNESS_ENGLISH];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-us"];
    }else if([_selectedLanguage isEqualToString:@"French"]){
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-ca"];
    }else if([_selectedLanguage isEqualToString:@"Spanish"]){
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"es-ES"];
    }
    [_synthesizer speakUtterance:utterance];
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
    _theNewAudio.volume=0.3; //between 0 and 1
    [_theNewAudio prepareToPlay];
    _theNewAudio.numberOfLoops=0; //or more if needed
    
    [_theNewAudio play];
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

- (IBAction)setTimerInterval:(UISlider *)sender {
    sliderSpeedValue = 6 - sender.value;
    [myTimer invalidate];
    myTimer = nil;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:sliderSpeedValue target:self  selector:@selector(onTimer_ShowFlashCard:) userInfo:nil repeats:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mmFlashCardsPauseMenuViewControllerDidGoToMainMenu:(WMAFlashCardsPauseMenuViewController *)controller;
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [myTimer invalidate];
    myTimer = nil;
    [self.delegate mmWMAFlashCardsGameViewControllerDidGoToMainMenu:self];
}

- (void)mmFlashCardsPauseMenuViewControllerDidContinue:(WMAFlashCardsPauseMenuViewController *)controller;
{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:sliderSpeedValue target:self  selector:@selector(onTimer_ShowFlashCard:) userInfo:nil repeats:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //stop the timer in case user decides to continue with the level
    //if the user comes back to continue play, we can start at the same time
    //we had when the user paused the game
    //[self stopTimer];
    
    if ([segue.identifier isEqualToString:@"segueToPauseFlashCards"])
	{
        [myTimer invalidate];
        myTimer = nil;
		WMAFlashCardsPauseMenuViewController *mmFlashCardsPauseMenuViewController = segue.destinationViewController;
		mmFlashCardsPauseMenuViewController.delegate = self;
        
        
        UIGraphicsBeginImageContext([[UIScreen mainScreen] applicationFrame].size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *pauseGameImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        //Load the background image
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        backgroundImageView.image = pauseGameImage;
        
        
        [mmFlashCardsPauseMenuViewController.view addSubview:backgroundImageView];
        [mmFlashCardsPauseMenuViewController.view  sendSubviewToBack:backgroundImageView];
        
	}
    
}


@end
