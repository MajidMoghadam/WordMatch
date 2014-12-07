//
//  WMAMemoryMatchGameViewController.m
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-21.
//  Copyright (c) 2012 individual. All rights reserved.
//


#import "WMAMemoryMatchGameViewController.h"
#import <QuartzCore/CALayer.h>
#import <QuartzCore/QuartzCore.h>

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define IPHONE   UIUserInterfaceIdiomPhone

#define EXPAND_CARDS 1.0
#define DISPLAY_FRENCH_TEXT_DELAY 2.0
#define FADE_CARD_DELAY 4.0
#define TIME_CARDS_REMAIN_FACEUP_UPON_SELECTION 1.3
#define MAX_NUMBER_OF_BONUS_STARS_PER_LEVEL 3
#define STARTING_IMAGE_SIZE .1
#define ENDING_IMAGE_SIZE    2
#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


#define categories [NSArray arrayWithObjects: @"Pets",@"Musical Instruments",@"Vehicles",@"Fruits",@"Countries",@"Colours",@"Vegetables",@"Clothes",@"Professions",@"Numbers",@"Sports",@"Weather",@"Alphabet",@"Home",@"Wild Animals",@"Faces",@"Classroom",@"Food",@"Shapes",@"Winter",nil]



@interface WMAMemoryMatchGameViewController (PrivateMethods)
-(void)shuffle:(NSMutableArray *)anArray;
-(BOOL)isLevelComplete;
-(NSString *)getNextMMGameLevel;
-(void)resetGameView;
-(void)updateTimer;
-(void)Spawn;

- (void) animateStarAboveCard:(UIImageView *)aStarImageView startingAtPoint:(CGPoint)aStartingPoint;
- (void) animateStarFloatToTopAndOut:(UIImageView *)aStarImageView startingAtPoint:(CGPoint)aStartingPoint;
- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees;
- (void) animateStarAlongPath:(UIImageView *)aStarImageView startingAtPoint:(CGPoint)aStartingPoint;
-(NSString *)getUserGameStateValue:(NSString *)forKey;
-(void)saveUserGameStateValue:(NSString *)aValue forAKey:(NSString *)aKey;
-(void)PlaySound:(NSString *)aSoundFile;
-(void)setCardDimensions;
@end

@implementation WMAMemoryMatchGameViewController
//@synthesize starPlaceHolderOne,starPlaceHolderTwo,starPlaceHolderThree;
@synthesize categoryName;
@synthesize timerDisplay;
@synthesize selectedLanguage;
@synthesize flakeImage;


@synthesize arrayOfTwentyCards, numberOfImagesFlipped, previousFlippedCard, selectedPairOfCards, arrayOfAllCardCategories, currentMMGameLevel, totalStarsEarnedInLevel,numberOfImagesRemainingUnmatched,stopWatchTimer,startDate, totalTimeInSecondsElapsed,arrayOfParticleImages,totalNumberOfCardFlips,starTrailImage,selectedStarsOnBackOfCards,matchGameView;

@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setCardDimensions
{
    WIDTH_OF_CARD  = 0;
    HEIGHT_OF_CARD = 0;
    HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = 0;
    HORIZONTAL_SPACE_BETWEEN_CARDS = 0;
    VERTICAL_SPACE_BEFORE_FIRST_ROW = 0;
    VERTICAL_SPACE_BETWEEN_CARDS = 0;
    
    // 5x + 4y = Total Width 
    // where x = HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN & HORIZONTAL_SPACE_BETWEEN_IMAGES
    // and y = WIDTH_OF_LEVEL_IMAGE
    // y ~= 5x
    // 5x + 4(5x) = Total Width
    // 25x = Total Width
    // x = (Total Width)/25
    
    //If your ints are A and B and you want to have ceil(A/B) just calculate (A+B-1)/B
    
    SCREEN_WIDTH = [[UIScreen mainScreen] bounds].size.width;
    SCREEN_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
    int x = (SCREEN_WIDTH + 25 - 1)/25; //HORIZONTAL_SPACE_BETWEEN_IMAGES
    //Keep "x" even (pixel math works out better)
    int num1 = x/2;
    int num2 = num1 * 2;
    if (x != num2) {
        x = x -1;
    }
    
    if (IDIOM==IPHONE) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if(SCREEN_HEIGHT == 480)
            {
                HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 3; //16 on iphone 4S
                HORIZONTAL_SPACE_BETWEEN_CARDS = x - 2; //16
                int remaining_space_for_images = SCREEN_WIDTH - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_CARDS);
                WIDTH_OF_CARD  = (remaining_space_for_images + 4 - 1)/4; //60;
                HEIGHT_OF_CARD = WIDTH_OF_CARD; //60;
                VERTICAL_SPACE_BEFORE_FIRST_ROW = 5*x + 10;
                VERTICAL_SPACE_BETWEEN_CARDS = x;

            }
            if(SCREEN_HEIGHT == 568)
            {
                HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 3;
                HORIZONTAL_SPACE_BETWEEN_CARDS = x - 2; //16
                int remaining_space_for_images = SCREEN_WIDTH - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_CARDS);
                WIDTH_OF_CARD  = (remaining_space_for_images + 4 - 1)/4; //60;
                HEIGHT_OF_CARD = WIDTH_OF_CARD; //60;
                VERTICAL_SPACE_BEFORE_FIRST_ROW = 5*x + 30;
                VERTICAL_SPACE_BETWEEN_CARDS = 2*x;

            }
        }
                //starPlaceHolderOne = (UIImageView *)[self.view viewWithTag:997];
        //STAR_WIDTH = starPlaceHolderOne.bounds.size.width; //WIDTH_OF_CARD/3;
        //STAR_HEIGHT = starPlaceHolderOne.bounds.size.height; //HEIGHT_OF_CARD/3;
    }else if(IDIOM==IPAD){
        HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 18; //36 on ipad 2;
        HORIZONTAL_SPACE_BETWEEN_CARDS = x-2; //36
        int remaining_space_for_images = SCREEN_WIDTH - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_CARDS);
        WIDTH_OF_CARD  = (remaining_space_for_images + 4 - 1)/4;
        HEIGHT_OF_CARD = WIDTH_OF_CARD;
        VERTICAL_SPACE_BEFORE_FIRST_ROW = 3 * x+18;
        VERTICAL_SPACE_BETWEEN_CARDS = x-8;
        //STAR_WIDTH = starPlaceHolderOne.bounds.size.width; //WIDTH_OF_CARD/3;
        //STAR_HEIGHT = starPlaceHolderOne.bounds.size.height; //HEIGHT_OF_CARD/3;
        
    }
    
    //cardWidth =  WIDTH_OF_LEVEL_IMAGE;
    //cardHeight =  HEIGHT_OF_LEVEL_IMAGE;
    //defaultViewSize = CGSizeMake(cardWidth,cardHeight);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    [self loadMMGameLevel:self.getCurrentMMGameLevel];
    
   [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EndBackgroundMusicNotification"
     object:self];
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    //Only allow 2 to be flipped at a time
    //this line prevents a third card from being flipped WHILE two others are still
    //flipped. Once the two cards are face down again or removed(if a match)
    //then a new card can be flipped
    if (numberOfImagesFlipped == 2)
        return;
    
    //the method dispatchFirstTouchAtPoint checks which card was touched and plays the 
    //appropriate sound. it also increments the variable numberOfImagesFlipped once a
    //card is flipped
    for (UITouch *touch in touches) 
        [self dispatchFirstTouchAtPoint:[touch locationInView:self.view] forEvent:nil];
    
    //after flipping the card face up once touched, we then check if they are a match
    //1.3 seconds represents the time until the checkForMatchingPair starts .... the 
    //larger this number, the longer the two cards will remain faceUp
    if (numberOfImagesFlipped == 2)
    {
        [self.view setUserInteractionEnabled:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:TIME_CARDS_REMAIN_FACEUP_UPON_SELECTION target:self selector:@selector(checkForMatchingPair) userInfo:nil repeats:NO];
    }
    
}   

-(void)checkForMatchingPair
{
    //retrieve the two cards selected (stored in an array)
    Card *card1 = (Card *)[selectedPairOfCards objectAtIndex:0];
    Card *card2 = (Card *)[selectedPairOfCards objectAtIndex:1];
    
    [self.view bringSubviewToFront:card1];
    [self.view bringSubviewToFront:card2];

    
    //if the cards are not a match, we flip them back face-down
    //cards with same image have the same cardId
    if(card1.cardId != card2.cardId)
    {
        
        ////
        /*
        UIImageView *aStar1;
        UIImageView *aStar2;
        
        if ((card1.cardHasAYellowStarOnBack) && (card2.cardHasAYellowStarOnBack)) {
            
            CGPoint centerOfStarRelativeToFrame1 = CGPointMake(card1.center.x-WIDTH_OF_CARD/2, card1.center.y-HEIGHT_OF_CARD/2);
            
            aStar1 = (UIImageView *)[self.view viewWithTag:(card1.tag +100)];
            [self animateStarFloatToTopAndOut:aStar1  startingAtPoint:centerOfStarRelativeToFrame1];
            
            CGPoint centerOfStarRelativeToFrame2 = CGPointMake(card2.center.x-WIDTH_OF_CARD/2, card2.center.y-HEIGHT_OF_CARD/2);
            
            aStar2 = (UIImageView *)[self.view viewWithTag:(card2.tag +100)];
            [self animateStarFloatToTopAndOut:aStar2  startingAtPoint:centerOfStarRelativeToFrame2];
            
        }else if (card1.cardHasAYellowStarOnBack) {
            
            CGPoint centerOfStarRelativeToFrame1 = CGPointMake(card1.center.x-WIDTH_OF_CARD/2, card1.center.y-HEIGHT_OF_CARD/2);
            
            aStar1 = (UIImageView *)[self.view viewWithTag:(card1.tag +100)];
            [self animateStarFloatToTopAndOut:aStar1  startingAtPoint:centerOfStarRelativeToFrame1];
            
        }else if (card2.cardHasAYellowStarOnBack) {
            
            CGPoint centerOfStarRelativeToFrame2 = CGPointMake(card2.center.x-WIDTH_OF_CARD/2, card2.center.y-HEIGHT_OF_CARD/2);
            
            aStar2 = (UIImageView *)[self.view viewWithTag:(card2.tag +100)];
            [self animateStarFloatToTopAndOut:aStar2  startingAtPoint:centerOfStarRelativeToFrame2];
            
        }
         */

                
        //we create the animation for the first card to flip back facedown
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card1 cache:YES];
        
        [card1.cardBackImageViewNeverSelected setHidden:TRUE];
        [card1.cardBackImageViewSelected setHidden:FALSE];
        [card1.imageContainer removeFromSuperview];
        card1.cardIsFaceUp = NO;
        ////card1.cardHasAYellowStarOnBack = NO;
        
        [card1.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        [UIView commitAnimations];
        
        //we also create the animation for the second card to flip back facedown
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card2 cache:YES];
        
        [card2.cardBackImageViewNeverSelected setHidden:TRUE];
        [card2.cardBackImageViewSelected setHidden:FALSE];
        [card2.imageContainer removeFromSuperview];
        card2.cardIsFaceUp = NO;
        ////card2.cardHasAYellowStarOnBack = NO;
        [card2.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        
        [UIView commitAnimations];
        [selectedPairOfCards removeAllObjects];
        
        [self.view setUserInteractionEnabled:YES];
        
        //[selectedStarsOnBackOfCards removeAllObjects];
        
        //aStar1.image = nil;
        //aStar2.image = nil;
        
    }
    else // if the cards are a match, they disappear from the view
    {
        
        //decrement the total number of images remaining in the view by 2
        //we start with 20 images, and we need to get to zero
        numberOfImagesRemainingUnmatched = numberOfImagesRemainingUnmatched - 2;
        
        
        //[self.view bringSubviewToFront:card1];
        //[self.view bringSubviewToFront:card2];
        
        //[self PlaySound:@"yeah.mp3"];
        //[self PlaySound:card1.imageSoundFile];
        
        [self PlaySound:card1.imageSoundFile];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:3.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(scheduleEventTimers:finished:context:)];
        
        //[card1 setCenter:(CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2))];
        //[card2 setCenter:(CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2))];
        
        ////
        ////
        /*
        //if the first card has never been selected beofre but is part of a match now
        //then the player gets a bonus star
        if (card1.cardHasAYellowStarOnBack) {
            
            if (totalStarsEarnedInLevel < MAX_NUMBER_OF_BONUS_STARS_PER_LEVEL) {
                totalStarsEarnedInLevel++;
            }
            
            
            //we create an animation effect that makes the stars for each card move
            //to the bottom into the place holder for the three stars
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            //UIImageView *aStarImageView1 =  card1.cardBackImageViewStar;
            //[card1.cardBackImageViewStar removeFromSuperview];
            //[self.view addSubview:aStarImageView1];
                        
            CGPoint centerOfStarRelativeToFrame1 = CGPointMake(card1.center.x-28, card1.center.y-28);
            //[self animateStarAlongPath:aStarImageView1  startingAtPoint:centerOfStarRelativeToFrame1];
            
            
            UIImageView *aStar1 = (UIImageView *)[self.view viewWithTag:(card1.tag +100)];
            
            [selectedStarsOnBackOfCards insertObject:aStar1 atIndex:0];
            
                         
            [self animateStarAlongPath:aStar1 startingAtPoint:centerOfStarRelativeToFrame1];
            
            
            
            
        }
        
        //if the second card has never been selected beofre but is part of a match now
        //then the player gets a bonus star
        if (card2.cardHasAYellowStarOnBack) {
            
            if (totalStarsEarnedInLevel < MAX_NUMBER_OF_BONUS_STARS_PER_LEVEL) {
                totalStarsEarnedInLevel++;
            }
            
            //we create an animation effect that makes the stars for each card move
            //to the bottom into the place holder for the three stars
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            //UIImageView *aStarImageView2 = card2.cardBackImageViewStar;
            //[card2.cardBackImageViewStar removeFromSuperview];
            //[self.view addSubview:aStarImageView2];
                        
            CGPoint centerOfStarRelativeToFrame2 = CGPointMake(card2.center.x-28, card2.center.y-28);
            //[self animateStarAlongPath:aStarImageView2  startingAtPoint:centerOfStarRelativeToFrame2];
            
            UIImageView *aStar2 = (UIImageView *)[self.view viewWithTag:(card2.tag +100)];
            
            [selectedStarsOnBackOfCards insertObject:aStar2 atIndex:0];
            
            [self animateStarAlongPath:aStar2 startingAtPoint:centerOfStarRelativeToFrame2];
            
        }
         
         */
        ////
        ////
        
       
        [UIView commitAnimations];
        
        if ([selectedLanguage isEqualToString:@"English"]) {
            [self performSelector:@selector(textToSpeech:) withObject:card1.englishText afterDelay:3.0];
            /*
            NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:card1.englishTextSoundFile ofType:nil];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName])
            {
                [self performSelector:@selector(PlaySound:) withObject:card1.englishTextSoundFile afterDelay:3.0];
            }
             */
        }else if([selectedLanguage isEqualToString:@"French"]){
            [self performSelector:@selector(textToSpeech:) withObject:card1.frenchText afterDelay:3.0];
            /*
            NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:card1.frenchTextSoundFile ofType:nil];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName])
            {
                [self performSelector:@selector(PlaySound:) withObject:card1.frenchTextSoundFile afterDelay:3.0];
            }
             */
        }else if([selectedLanguage isEqualToString:@"Spanish"]){
            [self performSelector:@selector(textToSpeech:) withObject:card1.spanishText afterDelay:3.0];
            /*
             NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:card1.frenchTextSoundFile ofType:nil];
             
             if ([[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName])
             {
             [self performSelector:@selector(PlaySound:) withObject:card1.frenchTextSoundFile afterDelay:3.0];
             }
             */
        }
        
        
    }
    
    //the two cards either match(and dissapear) or do not match
    //(and are flipped back face down), in either case we need to reset the variable 
    //numberOfImagesFlipped back to zero.
    numberOfImagesFlipped = 0;
    
    //if all the cards are matched then we stop the timer.
    if (numberOfImagesRemainingUnmatched == 0) {
        [stopWatchTimer invalidate];
        stopWatchTimer = nil;
        
        
        NSString *currentLevelName = @"MemoryMatch_Level";
        NSString *levelNumberString = [self getCurrentMMGameLevel];
        
        if ([levelNumberString length] == 1) {
            levelNumberString = [@"0" stringByAppendingString:levelNumberString];
        }
        //convert levelNumber to a string
        
        currentLevelName = [currentLevelName stringByAppendingString:levelNumberString];
        
        NSString *totalStarsEarnedInLevelString = [NSString stringWithFormat:@"%d", totalStarsEarnedInLevel]; 
        
        [self saveUserGameStateValue:totalStarsEarnedInLevelString forAKey:currentLevelName];
        //[self saveUserGameStateValue:[self getNextMMGameLevel] forAKey:@"currentMMGameLevel"];
        
        //unlock next level
        NSString *nextLevelName = @"MemoryMatch_Level";
        NSString *nextLevelNumberString = [self getNextMMGameLevel];
        if ([nextLevelNumberString length] == 1) {
            nextLevelNumberString = [@"0" stringByAppendingString:nextLevelNumberString];
        }
        
        nextLevelName = [nextLevelName stringByAppendingString:nextLevelNumberString];
        //value of "-1" indicates that the level is not played, but unlocked (is playable)
        [self saveUserGameStateValue:@"-1" forAKey:nextLevelName];
        
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
    if ([selectedLanguage isEqualToString:@"English"]){
        [utterance setVolume:LOUDNESS_ENGLISH];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-us"];
    }else if([selectedLanguage isEqualToString:@"French"]){
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-ca"];
    }else if([selectedLanguage isEqualToString:@"Spanish"]){
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"es-ES"];
    }
    [_synthesizer speakUtterance:utterance];
}


- (void) animateStarAboveCard:(UIImageView *)aStarImageView startingAtPoint:(CGPoint)aStartingPoint{
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.8;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1;
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    //CGPoint endPoint = CGPointMake(310, 450);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, aStartingPoint.x, aStartingPoint.y);
   CGPathAddQuadCurveToPoint(curvedPath, NULL, aStartingPoint.x, aStartingPoint.y, aStartingPoint.x-WIDTH_OF_CARD/2, aStartingPoint.y-HEIGHT_OF_CARD/2);
    //CGPathAddQuadCurveToPoint(curvedPath, NULL, aStarImageView.center.x, 450, 310, 450);
    //CGPathAddQuadCurveToPoint(curvedPath, NULL, 310, 10, 10, 10);
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.view bringSubviewToFront:aStarImageView];
    
    //need this line to actually move the centre of star to another location
    //this way when we take screen capture it appears in the correct place,
    //if we leave this line out, star appears in the original location it started, at centre
    //of card. Relocated centre of star to the final destination of animation
    aStarImageView.center = CGPointMake(aStartingPoint.x-WIDTH_OF_CARD/2, aStartingPoint.y-HEIGHT_OF_CARD/2);
    
    [aStarImageView.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    
}

- (void) animateStarFloatToTopAndOut:(UIImageView *)aStarImageView startingAtPoint:(CGPoint)aStartingPoint{
    
    [self PlaySound:@"starGoesUp.wav"];
    
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.8;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1;
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    //CGPoint endPoint = CGPointMake(310, 450);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, aStartingPoint.x, aStartingPoint.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, aStartingPoint.x, 30, aStartingPoint.x, -100);
    //CGPathAddQuadCurveToPoint(curvedPath, NULL, aStarImageView.center.x, 450, 310, 450);
    //CGPathAddQuadCurveToPoint(curvedPath, NULL, 310, 10, 10, 10);
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.view bringSubviewToFront:aStarImageView];
    
    //see similar comment above. need this line to relocated star to final position of animation
    aStarImageView.center = CGPointMake(aStartingPoint.x, -100);
    
    [aStarImageView.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.6;
    anim.repeatCount = 0;
    anim.autoreverses = NO;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 1.0)];
    [aStarImageView.layer addAnimation:anim forKey:nil];
    
    
}


- (void) animateStarAlongPath:(UIImageView *)aStarImageView startingAtPoint:(CGPoint)aStartingPoint{
    
    //[self PlaySound:@"swoosh.wav"];
    
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 2.0;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1;
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    //CGPoint endPoint = CGPointMake(310, 450);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, aStartingPoint.x, aStartingPoint.y);
    //CGPathAddQuadCurveToPoint(curvedPath2, NULL, aStarImageView.center.x, 30, 160, 30);
    if (totalStarsEarnedInLevel==1) {
        UIImageView *aFirstStarDestination = (UIImageView *)[self.view viewWithTag:997];
        CGPathAddQuadCurveToPoint(curvedPath, NULL, aStartingPoint.x, aFirstStarDestination.center.y, aFirstStarDestination.center.x, aFirstStarDestination.center.y);
    }else if (totalStarsEarnedInLevel==2) {
        UIImageView *aSecondStarDestination = (UIImageView *)[self.view viewWithTag:998];
        CGPathAddQuadCurveToPoint(curvedPath, NULL, aStartingPoint.x, aSecondStarDestination.center.y, aSecondStarDestination.center.x, aSecondStarDestination.center.y);
    }else if (totalStarsEarnedInLevel>=3) {
        UIImageView *aThirdStarDestination = (UIImageView *)[self.view viewWithTag:999];
        CGPathAddQuadCurveToPoint(curvedPath, NULL, aStartingPoint.x, aThirdStarDestination.center.y, aThirdStarDestination.center.x, aThirdStarDestination.center.y);
    }
    
    //CGPathAddQuadCurveToPoint(curvedPath, NULL, 310, 10, 10, 10);
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    
    
    
    
    
    //CAEmitterLayer* fireEmitter = [[CAEmitterLayer alloc] init];
    CAEmitterLayer* fireEmitter = [CAEmitterLayer layer];
     CGRect viewBounds = matchGameView.layer.bounds;
     fireEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
     
    //set ref to the layer
    //fireEmitter = (CAEmitterLayer*)matchGameView.layer; //2
    //configure the emitter layer
    //fireEmitter.emitterPosition = CGPointMake(10, 10);
    fireEmitter.emitterSize = CGSizeMake(1, 1);
    
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = 0;
    fire.lifetime = 2.0;
    fire.lifetimeRange = 0.5;
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    fire.contents = (id)[[UIImage imageNamed:@"star.png"] CGImage];
    [fire setName:@"fire"];
    
    fire.velocity = 10;
    fire.velocityRange = 20;
    fire.emissionRange = M_PI_2/2;
    
    fire.scaleSpeed = 0.2;
    fire.spin = 0.2;
    
    fireEmitter.renderMode = kCAEmitterLayerAdditive;
    
    //add the cell to the layer and we're done
    fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
    
    
    
    
      
     
     
    CAKeyframeAnimation *particleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    [particleAnimation setPath:curvedPath];
    [particleAnimation setDuration:2.0];
    [particleAnimation setCalculationMode:kCAAnimationPaced];
    [fireEmitter addAnimation:particleAnimation forKey:@"yourAnimation"]; 
    
     
    CGPathRelease(curvedPath);
    
    [aStarImageView.layer addAnimation:pathAnimation forKey:@"moveTheSquare2"];
    
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((720*M_PI)/180)];
    fullRotation.duration = 2.0;
    fullRotation.repeatCount = 1;
    [self.view bringSubviewToFront:aStarImageView];
    
    //see similar comment above. need this line to relocated star to final position of animation
    if (totalStarsEarnedInLevel==1) {
        UIImageView *aFirstStarDestination = (UIImageView *)[self.view viewWithTag:997];
        aStarImageView.center = CGPointMake(aFirstStarDestination.center.x, aFirstStarDestination.center.y);
    }else if (totalStarsEarnedInLevel==2) {
        UIImageView *aSecondStarDestination = (UIImageView *)[self.view viewWithTag:998];
        aStarImageView.center = CGPointMake(aSecondStarDestination.center.x, aSecondStarDestination.center.y);
    }else if (totalStarsEarnedInLevel>=3) {
        UIImageView *aThirdStarDestination = (UIImageView *)[self.view viewWithTag:999];
        aStarImageView.center = CGPointMake(aThirdStarDestination.center.x, aThirdStarDestination.center.y);
    }


    [aStarImageView.layer addAnimation:fullRotation forKey:@"360"];
    
    //aStarImageView.image = nil;
    
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}


//------------------TRYING TO CREATE TRAIL EFFECT------------------//
// produceAStarForTheStarTrail event is called whenever the timer fires
- (void)produceAStarForTheStarTrail:(NSTimer *)timer
{
    NSNumber *objectTagNumber = [timer userInfo];
    UIImageView *aStarImageView = (UIImageView *)[self.view viewWithTag:objectTagNumber.intValue];
    //UIImageView *aStarImageView = (UIImageView *)[selectedStarsOnBackOfCards objectAtIndex:0];
    //CGPoint actualPositionOfStarOnIphone = [aStarImageView convertPoint:aStarImageView.center toView:aStarImageView.superview];
    float x = aStarImageView.center.x;
    float y = aStarImageView.center.y;
   // aStarImageView.center = CGPointMake(aStarImageView.center.x + starPosition.x, aStarImageView.center.y + starPosition.y);
	
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
    imageView.frame = CGRectMake(x, y, 15, 15);
    [self.view addSubview:imageView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    imageView.frame = CGRectMake(x-6, y-6, 12, 12);
    [imageView setAlpha:0.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeSmoke:finished:context:)];
    [UIView commitAnimations];	
    
    [self.view bringSubviewToFront:aStarImageView];

}
//------------------TRYING TO CREATE TRAIL EFFECT------------------//

//------------------TRYING TO CREATE TRAIL EFFECT------------------//
- (void)removeSmoke:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {	
	UIImageView *imageView = (__bridge UIImageView *)context;
	[imageView removeFromSuperview];
}
//------------------TRYING TO CREATE TRAIL EFFECT------------------//

-(void)scheduleEventTimersUponTouch:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(animateStarAboveCard) userInfo:nil repeats:NO];
}


-(void)scheduleEventTimers:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [NSTimer scheduledTimerWithTimeInterval:EXPAND_CARDS target:self selector:@selector(expandCards) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:DISPLAY_FRENCH_TEXT_DELAY target:self selector:@selector(displayTextOnCard) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:FADE_CARD_DELAY target:self selector:@selector(fadeCard) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:FADE_CARD_DELAY target:self selector:@selector(enableUserInteraction) userInfo:nil repeats:NO];
}

-(void)expandCards
{
    Card *card1 = (Card *)[selectedPairOfCards objectAtIndex:0];
    Card *card2 = (Card *)[selectedPairOfCards objectAtIndex:1];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    //these two lines expand the image in the card by a factor of 3.8 in both dimensions
    if (IDIOM==IPHONE) {
        [card1 setTransform:CGAffineTransformMakeScale(4.4, 4.4)];
        [card2 setTransform:CGAffineTransformMakeScale(4.4, 4.4)];
    }else if(IDIOM==IPAD){
        [card1 setTransform:CGAffineTransformMakeScale(4.6, 4.6)];
        [card2 setTransform:CGAffineTransformMakeScale(4.6, 4.6)];
    }

    
    //[card1.imageContainer setTransform:CGAffineTransformMakeScale(3.8, 3.8)];
    //[card2.imageContainer setTransform:CGAffineTransformMakeScale(3.8, 3.8)];
    
    //these two lines increase the outer dimensions, or frame of the card to the set
    //location and (20,50) and size (w=280, height=382)
    [card1 setFrame:CGRectMake(HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN, VERTICAL_SPACE_BEFORE_FIRST_ROW, SCREEN_WIDTH-2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN, 5*HEIGHT_OF_CARD+4*VERTICAL_SPACE_BETWEEN_CARDS)];
    [card2 setFrame:CGRectMake(HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN, VERTICAL_SPACE_BEFORE_FIRST_ROW, SCREEN_WIDTH-2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN, 5*HEIGHT_OF_CARD+4*VERTICAL_SPACE_BETWEEN_CARDS)];

    
    //[card1 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)];
    //[card2 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)];


    
    [UIView commitAnimations];
    
    /*
    UIImageView *aStar1 = (UIImageView *)[self.view viewWithTag:(card1.tag+100)];
    if (aStar1 != nil) {
        [aStar1 removeFromSuperview];
    }
    UIImageView *aStar2 = (UIImageView *)[self.view viewWithTag:(card2.tag+100)];
    if (aStar2 != nil) {
        [aStar2 removeFromSuperview];
    }
    */

}

-(void)displayTextOnCard
{
    Card *card2 = (Card *)[selectedPairOfCards objectAtIndex:1];
    [self.view bringSubviewToFront:card2];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    
    UILabel *languageLabel;
    if (IDIOM==IPHONE) {
        languageLabel= [[UILabel alloc] initWithFrame:CGRectMake(HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN, VERTICAL_SPACE_BEFORE_FIRST_ROW+ 4.4*HEIGHT_OF_CARD, 4.4*WIDTH_OF_CARD, (5*HEIGHT_OF_CARD+4*VERTICAL_SPACE_BETWEEN_CARDS-4.4*HEIGHT_OF_CARD))];
    }else if(IDIOM==IPAD){
        languageLabel= [[UILabel alloc] initWithFrame:CGRectMake(HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN, VERTICAL_SPACE_BEFORE_FIRST_ROW+ 4.6*HEIGHT_OF_CARD, 4.6*WIDTH_OF_CARD, (5*HEIGHT_OF_CARD+4*VERTICAL_SPACE_BETWEEN_CARDS-4.6*HEIGHT_OF_CARD))];
    }

    
    [languageLabel setBackgroundColor:[UIColor redColor]];
    [languageLabel setTextColor:[UIColor blackColor]];
    [languageLabel setBackgroundColor:[UIColor clearColor]];
    [languageLabel setTextAlignment:NSTextAlignmentCenter];
    [languageLabel setAdjustsFontSizeToFitWidth:TRUE];
     
    if (IDIOM==IPHONE) {
        [languageLabel setFont:[UIFont fontWithName: @"Verdana-Bold" size: (5*HEIGHT_OF_CARD+4*VERTICAL_SPACE_BETWEEN_CARDS-4.4*HEIGHT_OF_CARD)/2.8]];
    }else if(IDIOM==IPAD){
        [languageLabel setFont:[UIFont fontWithName: @"Verdana-Bold" size: (5*HEIGHT_OF_CARD+4*VERTICAL_SPACE_BETWEEN_CARDS-4.6*HEIGHT_OF_CARD)/2.8]];
    }

    [self.view addSubview:languageLabel];
    
    if ([selectedLanguage isEqualToString:@"English"]) {
        [languageLabel setText:card2.englishText];
    }else if([selectedLanguage isEqualToString:@"French"]){
        [languageLabel setText:card2.frenchText];
    }else if([selectedLanguage isEqualToString:@"Spanish"]){
        [languageLabel setText:card2.spanishText];
    }
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.5];
    [UIView setAnimationDelegate:self];
    
    [languageLabel setAlpha:0.0];
    
    [UIView commitAnimations];
    
}

-(void)fadeCard
{
    Card *card1 = (Card *)[selectedPairOfCards objectAtIndex:0];
    Card *card2 = (Card *)[selectedPairOfCards objectAtIndex:1];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    [card1 setAlpha:0.0];
    [card2 setAlpha:0.0];
    
    [UIView commitAnimations];
    
    [selectedPairOfCards removeAllObjects];
    //[selectedStarsOnBackOfCards removeAllObjects];
    
    
    //if all the cards are matched then we stop the timer.
    if (numberOfImagesRemainingUnmatched == 0) {
        
        // start a timet that will fire 20 times per second
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:5.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(scheduleEventTimers2:finished:context:)];
        [UIView commitAnimations];
        
        
    }

}

-(void)scheduleEventTimers2:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
//    [NSTimer scheduledTimerWithTimeInterval:EXPAND_CARDS target:self selector:@selector(expandCards) userInfo:nil repeats:NO];
//    [NSTimer scheduledTimerWithTimeInterval:DISPLAY_FRENCH_TEXT_DELAY target:self selector:@selector(displayTextOnCard) userInfo:nil repeats:NO];
//    [NSTimer scheduledTimerWithTimeInterval:FADE_CARD_DELAY target:self selector:@selector(fadeCard) userInfo:nil repeats:NO];
//    [NSTimer scheduledTimerWithTimeInterval:FADE_CARD_DELAY target:self selector:@selector(enableUserInteraction) userInfo:nil repeats:NO];
    
    //create a random number between 1 and 2 and use this to select one of the
    //following animation effect
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(displayCongratsAnimation) userInfo:nil repeats:NO];
    
    double randomAnimationEffect = [self getRandomNumberBetween:1 maxNumber:2];
    //randomAnimationEffect = 1;

    if(randomAnimationEffect==1){
        [self PlaySound:@"chimes_fallingLeaves.mp3"];
        for (int i = 1; i <= 50; i++) {
            [NSTimer scheduledTimerWithTimeInterval:(0.1 * i) target:self selector:@selector(onTimer_fallingSnowFlakesAnimation) userInfo:nil repeats:NO];
        }
    }else if(randomAnimationEffect==2){
        [self PlaySound:@"chimes_centralExpanding.mp3"];
        for (int i = 1; i <= 50; i++) {
            [NSTimer scheduledTimerWithTimeInterval:(0.1 * i) target:self  selector:@selector(onTimer_centralExpandingAnimation) userInfo:nil repeats:NO];
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:(7.0) target:self selector:@selector(levelCompleteSegue) userInfo:nil repeats:NO];

}

-(void)levelCompleteSegue{
    [self performSegueWithIdentifier: @"segueToLevelCompleteMenu" sender: self];
}

-(void)enableUserInteraction{
    [self.view setUserInteractionEnabled:YES];
}

-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
    
    //go through all twenty cards in the array
    for(Card *card in arrayOfTwentyCards) 
    {
        //only look at card you touched (not all twenty),
        //check if you touched a point in the card
        if (CGRectContainsPoint([card frame], touchPoint)) 
        {
            //check to see if card is face down (not turned over...see back of card)
            if (card.cardIsFaceUp == NO) 
            {
                //always keep track of total number of cards of card flips (for score)
                totalNumberOfCardFlips++;
                //update label for total cards flipped ... think i removed this label!
                [self updateTimer];
                
                //we need to play the appropriate background sound for the image (imageSoundFile property)
                //[self PlaySound:@"cardFlip4.wav"];
                //[self PlaySound:@"ding2.mp3"];
                //[self PlaySound:@"card_flip_2.wav"];
                
                [self PlaySound:@"page-flip.mp3"];
                //[self PlaySound:card.imageSoundFile];
                //[self PlaySound:card.frenchTextSoundFile];
                
                //add the card to the array of selected cards (only 2 members)
                [selectedPairOfCards addObject:card];
                
                ////
                /*
                //check for a yellow star on back of card
                if (card.cardHasAYellowStarOnBack) {
                    //move the star to the top left corner of card
                    UIImageView *aStar = (UIImageView *)[self.view viewWithTag:(card.tag +100)];
                    [self animateStarAboveCard:aStar startingAtPoint:aStar.center];
                }
                 */
                ////
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.6];
                
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:card cache:YES];
                [card addSubview:card.imageContainer];
                numberOfImagesFlipped++;
                
                [card.cardBackImageViewNeverSelected setHidden:TRUE];
                [card.cardBackImageViewSelected setHidden:TRUE];
                
                [card.layer setBorderColor:[[UIColor blackColor] CGColor]];
                
                
                [UIView setAnimationDelegate:self];
                [UIView commitAnimations];
                
                
                card.cardIsFaceUp = YES;
                
                
            } 
            
        }
        
    }
    
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

- (void)shuffle:(NSMutableArray *)anArray
{
    
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [anArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [anArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}



//next level is the level that is after the current level the user is playing on.
-(NSString *)getCurrentMMGameLevel
{
    
    NSString *userGameState_CurrentMMGameLevel = [self getUserGameStateValue:@"currentMMGameLevel"];
    
    return userGameState_CurrentMMGameLevel;
}

//next level is the level that is after the current level the user is playing on.
-(NSString *)getNextMMGameLevel
{
    
    NSString *userGameState_CurrentMMGameLevel = self.getCurrentMMGameLevel;
    int nextMMGameLevel = [userGameState_CurrentMMGameLevel intValue] + 1;
    
    //only 20 levels per set, so we set the level to one if we reach the end
    if (nextMMGameLevel==21) {
        nextMMGameLevel = 1; 
    }
    
    NSString *userGameState_NextMMGameLevel = [NSString stringWithFormat:@"%d", nextMMGameLevel];
    
    return userGameState_NextMMGameLevel;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self loadMMGameLevel:self.getCurrentMMGameLevel];
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

- (void)updateTimer
{
    //timerDisplay.text = [NSString stringWithFormat:@"%i", totalTimeInSecondsElapsed++];
    timerDisplay.text = [NSString stringWithFormat:@"%i", totalNumberOfCardFlips];
}
/*
- (void)startTimer
{
    // Create the stop watch timer that fires every 10 ms
    
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/1.0
                                                      target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:nil
                                                     repeats:YES];
     
}
*/
/*
- (void)stopTimer
{
    [stopWatchTimer invalidate];
    stopWatchTimer = nil;
}
*/

//- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
//	
//	UIImageView *flakeView = CFBridgingRelease(context);
//	[flakeView removeFromSuperview];
//    
//}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

// Timer event is called whenever the timer fires
- (void)onTimer_fallingSnowFlakesAnimation
{
    int startX = 0;
    int endX = 0;
    
    // build a view from our flake image, set tag so me can remove objects later
    UIImageView* flakeView = [[UIImageView alloc] initWithImage:flakeImage];
    [flakeView setTag:tagNumberCongratsObjects++];
    
    // use the random() function to randomize up our flake attributes
    startX = round(random() % SCREEN_WIDTH) - 30;
    endX = round(random() % SCREEN_WIDTH) - 30;
    //double scale = 1 / round(random() % 100) + 1.0;
    double scale = [self getRandomNumberBetween:1 maxNumber:4]/2;
    double speed = 1 / round(random() % 100) + 1.0;
    double resolution_scale = SCREEN_WIDTH/320;
    
    // set the flake start position
    if(currentMMGameLevel==20){
        flakeView.frame = CGRectMake(startX, -100.0, 25.0 * scale*resolution_scale, 25.0 * scale*resolution_scale);
    }else{
        flakeView.frame = CGRectMake(startX, -100.0, 50.0 * scale*resolution_scale, 50.0 * scale*resolution_scale);
    }
    
    flakeView.alpha = 0.70;
    
    // put the flake in our main view
    [self.view addSubview:flakeView];
    
    [UIView beginAnimations:nil context:(__bridge void *)(flakeView)];
    // set up how fast the flake will fall
    [UIView setAnimationDuration:5 * speed];
    
    // set the postion where flake will move to
    if(currentMMGameLevel==20){
        flakeView.frame = CGRectMake(endX, (SCREEN_HEIGHT+100), 25.0 * scale*resolution_scale, 25.0 * scale*resolution_scale);
    }else{
        flakeView.frame = CGRectMake(endX, (SCREEN_HEIGHT+100), 50.0 * scale*resolution_scale, 50.0 * scale*resolution_scale);
    }
    
    // set a stop callback so we can cleanup the flake when it reaches the
    // end of its animation
    //	[UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
	
}

// Timer event is called whenever the timer fires
- (void)onTimer_centralExpandingAnimation
{
    
    int startX = 0;
    int startY = 0;
    int endX = 0;
    int endY = 0;
    
    //this animation has the image start from the middle of the screen an
    //expand and move outwardly to one of 4 different qudrants randomly
    //top,bottom, left or right
    
    // build a view from our flake image
    //UIImageView* flakeView = [[UIImageView alloc] initWithImage:cardImage];
    UIImageView* flakeView = [[UIImageView alloc] initWithImage:flakeImage];
    [flakeView setTag:tagNumberCongratsObjects++];
    
    //we want the startpoint to be randomly chosen near the center
    startX = (int)[self getRandomNumberBetween:((SCREEN_WIDTH/2)-90) maxNumber:((SCREEN_WIDTH/2)+30)];
    startY = (int)[self getRandomNumberBetween:((SCREEN_WIDTH/2)-90) maxNumber:((SCREEN_WIDTH/2)+30)];
    
    flakeView.alpha = 0.70;
    
    //we want the endpoint to be randomly chosen
    double randomQuadrantX = [self getRandomNumberBetween:1 maxNumber:4];
    
    double resolution_scale = SCREEN_WIDTH/320;
    
    if(randomQuadrantX==1){
        endX = (int)([self getRandomNumberBetween:0 maxNumber:SCREEN_WIDTH]);
        endY = -100;
    }else if(randomQuadrantX==2){
        endX = (int)([self getRandomNumberBetween:0 maxNumber:SCREEN_WIDTH]);
        endY = SCREEN_HEIGHT+100;
    }else if(randomQuadrantX==3){
        endX = -150;
        endY = (int)([self getRandomNumberBetween:0 maxNumber:SCREEN_HEIGHT]);
    }else if(randomQuadrantX==4){
        endX = SCREEN_WIDTH+100;
        endY = (int)([self getRandomNumberBetween:0 maxNumber:SCREEN_HEIGHT]);
    }
    
    
    //double scale = 1 / round(random() % 100) + 1.0;
    //double scale = [self getRandomNumberBetween:1 maxNumber:4]/2;
    //double speed = 1 / round(random() % 100) + 2.0;
    
    // set the flake start position
    if(currentMMGameLevel==20){
        flakeView.frame = CGRectMake(startX, startY, 25.0*resolution_scale , 25.0*resolution_scale );
    }else{
        flakeView.frame = CGRectMake(startX, startY, 50.0*resolution_scale , 50.0*resolution_scale );
    }
    
    
    
    // put the flake in our main view
    [self.view addSubview:flakeView];
    
    [UIView beginAnimations:nil context:(__bridge void *)(flakeView)];
    // set up how fast the flake will fall
    [UIView setAnimationDuration:5];
    
    // set the postion where flake will move to
    if(currentMMGameLevel==20){
        flakeView.frame = CGRectMake(endX, endY, 70.0*resolution_scale, 70.0*resolution_scale);
    }else{
        flakeView.frame = CGRectMake(endX, endY, 75.0*resolution_scale, 75.0*resolution_scale);
    }
    
    flakeView.alpha = 0.20;
    
    // set a stop callback so we can cleanup the flake when it reaches the
    // end of its animation
    //	[UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

-(void)displayCongratsAnimation{
    
    //SCREEN_WIDTH = [[UIScreen mainScreen] bounds].size.width;
    //SCREEN_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
    
    float widthCongratsMessageFloat = (0.9)*SCREEN_WIDTH;
    int widthCongratsMessage = round(widthCongratsMessageFloat);
    float heightCongratsMessageFloat = 7.0 * widthCongratsMessageFloat / 30.0;
    int heightCongratsMessage = round(heightCongratsMessageFloat);
    
    // build a view from our flake image
    UIImageView* congratsImageView = [[UIImageView alloc] init];//lWithImage:[UIImage imageNamed:@"congratulations.png"]];
    
    NSArray *chunks = [@"congratulations.png" componentsSeparatedByString: @"."];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
    congratsImageView.image =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    //someCard.imageContainer.image = cardImage;
    
    // put the flake in our main view
    [self.view addSubview:congratsImageView];
    
    if(currentMMGameLevel%5 == 1){
        [self textToSpeech:@"Congratulations, you're good at matching."];
    }else if(currentMMGameLevel%5 == 2){
        [self textToSpeech:@"Congratulations, you did it."];
    }else if(currentMMGameLevel%5 == 3){
        [self textToSpeech:@"Congratulations, you're good at this."];
    }else if(currentMMGameLevel%5 == 4){
        [self textToSpeech:@"Congratulations, you rock."];
    }else if(currentMMGameLevel%5 == 0){
        [self textToSpeech:@"Congratulations, keep up the good work."];
    }
    
    congratsImageView.alpha = 1.0;
   congratsImageView.frame = CGRectMake(round((SCREEN_WIDTH-widthCongratsMessage)/2), round((SCREEN_HEIGHT-heightCongratsMessage)/2), widthCongratsMessage, heightCongratsMessage);
    
    
    
    //congratsImageView.frame = CGRectMake(10, 260, 300, 70);
    
    [UIView beginAnimations:nil context:nil];
    // set up how fast the flake will fall
    [UIView setAnimationDuration:6.0];
    
    congratsImageView.alpha = 0.0;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

}

-(void)resetGameView
{
    //look for all card objects and star objects that remain on screen and remove them
    //we use the tag numbers to identify them
    //all card objects have tag numbers between 1-20 and all stars between 100-120.
    for(int tagNumber=1; tagNumber <= 20; tagNumber++)
    {
        Card *aCard = (Card *)[self.view viewWithTag:tagNumber];
        ////UIImageView *aStar = (UIImageView *)[self.view viewWithTag:(tagNumber+100)];
        if (aCard != nil) {
            [aCard removeFromSuperview];
        }
        ////if (aStar != nil) {
        ////    [aStar removeFromSuperview];
        ////}
    }
    
    for(int tagNumber=1000; tagNumber <= 1050; tagNumber++)
    {
        UIImageView *anImageView = (UIImageView *)[self.view viewWithTag:tagNumber];
        if (anImageView != nil) {
            [anImageView removeFromSuperview];
        }
    }
    
    tagNumberCongratsObjects = 1000; //reset the to 1000
    //(increments by 1 each time an object is created)
    
    
    
    //aFirstStarDestination = (UIImageView *)[self.view viewWithTag:997];
   // aFirstStarDestination.s
    //starPlaceHolderOne.image.size
    
    //starOnBackOfCardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, STAR_WIDTH, STAR_HEIGHT)];
    
    totalNumberOfCardFlips = 0;
    
    totalStarsEarnedInLevel = 0;
    
    numberOfImagesRemainingUnmatched = 20;
    
    numberOfImagesFlipped = 0;
    
    // Create the timer object
    startDate = [NSDate date];
    
    totalTimeInSecondsElapsed = 0;
    
    timerDisplay.text = @"0";
    
    [selectedPairOfCards removeAllObjects];
    

    UIImageView *aBackgroundImageView = (UIImageView *)[self.view viewWithTag:1000];
    if (aBackgroundImageView != nil) {
        [aBackgroundImageView removeFromSuperview];
    }
    
    [self setCardDimensions];
    
    //[self stopTimer];
    
    //[self startTimer];

}


-(void)loadMMGameLevel:(NSString *)aLevel{
    
    [self resetGameView];
    
    currentMMGameLevel = [aLevel intValue];
    
    
#ifdef FREE
    if (currentMMGameLevel <=4) {
        [self setUpCardsInGrid];
    }else{
        [self displayDownloadPaidAppMessage];
    }
#else
    [self setUpCardsInGrid];
#endif
    
    
}

-(void)displayDownloadPaidAppMessage{
    categoryName.text  = [categories objectAtIndex:(currentMMGameLevel-1)];

    
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH-40, 410)];
    
    [yourLabel setTextColor:[UIColor blackColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 17.0f]];
    yourLabel.numberOfLines = 0;
    [self.view addSubview:yourLabel];
    
    yourLabel.text = @"Download the PAID version to access this category:";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(goToAppStore)
     forControlEvents:UIControlEventTouchUpInside];
    
    if (IDIOM==IPHONE) {
        yourLabel.text = [yourLabel.text stringByAppendingString:@"\n\nWord Match - The Language Game (PAID Version):"];
        [button setImage:[UIImage imageNamed:@"app-store-icon_iPhone.png"]  forState:UIControlStateNormal];
        button.frame = CGRectMake(SCREEN_WIDTH/2-80, 180, 144.0, 51.0);
    }else if(IDIOM==IPAD){
        yourLabel.text = [yourLabel.text stringByAppendingString:@"\n\nWord Match - The Language Game (PAID Version):"];
        [button setImage:[UIImage imageNamed:@"app-store-icon_iPad.png"]  forState:UIControlStateNormal];
        button.frame = CGRectMake(SCREEN_WIDTH/2-80, 190, 216.0, 76.0);
    }
    
    
    [self.view addSubview:button];
    
    yourLabel.text = [yourLabel.text stringByAppendingString:@"\n\n\n\n\n\nThis FREE version of Word Match only gives you access to the first four categories: Pets, Musical Instruments, Vehicles and Fruits. \n\nThe PAID version gives you access to all 20 categories in all available languages.\n\n"];
    
    yourLabel.text = [yourLabel.text stringByAppendingString:@"We thank you for your support."];


    
    
    

}

-(void)goToAppStore{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/ca/app/word-match-the-language-game/id821926685?mt=8"]];
}

-(void)setUpCardsInGrid{
    selectedLanguage = [self getUserGameStateValue:@"languageSelected"];
    
    _synthesizer = [[AVSpeechSynthesizer alloc] init];
    
    //this default sized (x and y dimensions) used below in laying out cards on the iPhone screen
    //Card *aTempCard = [[Card alloc] init];
    //CGSize defaultViewSize = aTempCard.defaultViewSize;
    
    //retrieve the set of cards from the plist data
    NSMutableArray *arrayOfCardInfoFromPlist = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictionaryOfCardSets = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Card-Info" ofType:@"plist"]];
    arrayOfAllCardCategories = [[NSMutableArray alloc] init];
    arrayOfAllCardCategories = dictionaryOfCardSets.allKeys;
    NSString *keyName = [categories objectAtIndex:(currentMMGameLevel-1)];
    
    
    //Load the background image
    NSString *backgroundFileName =  [keyName stringByAppendingString:@"_background.jpg"];
    UIImage *bgImage;
    
    NSArray *chunks = [backgroundFileName componentsSeparatedByString: @"."];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
    bgImage =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    backgroundImageView.image = bgImage;
    //backgroundImageView.backgroundColor = blackColor;
    [backgroundImageView setOpaque:NO];
    [backgroundImageView setTag:1000];
    backgroundImageView.opaque = NO;
    
    [self.view addSubview:backgroundImageView];
    [self.view  sendSubviewToBack:backgroundImageView];
    
    //the following array has a size of arrayOfCardInfoFromPlist.count
    //this represents the number of objects/words in the category
    //only ten will randomly be selected for the match game
    arrayOfCardInfoFromPlist = [dictionaryOfCardSets objectForKey:keyName];
    
    //shuffle the array to randomize the order
    //we will only select the first ten elements of the array after shuffling
    [self shuffle:arrayOfCardInfoFromPlist];
    
    //use the keyName to display the Category Name title on page view
    categoryName.text = keyName;
    
    arrayOfTwentyCards = [[NSMutableArray alloc] init] ;
    selectedPairOfCards = [[NSMutableArray alloc] init];
    //selectedStarsOnBackOfCards = [[NSMutableArray alloc] init];
    NSMutableDictionary* cardInfo;
    //UIImage *cardImage;
    
    //Load the background card image, alternate blue, red, orange, green and purple
    UIImage *bgCardImage;
    if (currentMMGameLevel % 5==1) {
        //bgCardImage = [UIImage imageNamed: @"starburst_512_blue.png"];
        NSArray *chunks = [@"starburst_512_blue.png" componentsSeparatedByString: @"."];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
        bgCardImage =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    }else if(currentMMGameLevel % 5==2) {
        //bgCardImage = [UIImage   x: @"starburst_512_red.png"];
        NSArray *chunks = [@"starburst_512_red.png" componentsSeparatedByString: @"."];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
        bgCardImage =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    }else if(currentMMGameLevel % 5==3) {
        //bgCardImage = [UIImage imageNamed: @"starburst_512_orange.png"];
        NSArray *chunks = [@"starburst_512_orange.png" componentsSeparatedByString: @"."];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
        bgCardImage =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    }else if(currentMMGameLevel % 5==4) {
        //bgCardImage = [UIImage imageNamed: @"starburst_512_green.png"];
        NSArray *chunks = [@"starburst_512_green.png" componentsSeparatedByString: @"."];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
        bgCardImage =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    }else if(currentMMGameLevel % 5==0) {
        //bgCardImage = [UIImage imageNamed: @"starburst_512_purple.png"];
        NSArray *chunks = [@"starburst_512_purple.png" componentsSeparatedByString: @"."];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
        bgCardImage =  [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    
    //load the data from the arrayOfCardInfoFromPlist array into ten Card objects, and store this in an array, arrayOfTenCards
    //only the first 10 elements of the arrayOfCardInfoFromPlist array will be taken
    for (int cardIndex = 0; cardIndex < 20; cardIndex++) {
        //get the card info for the card with the current cardIndex number
        //the %10 repeats the first 10 elements to get pairs
        //for each the the first 10
        int arrayOfCardInfoFromPlistIndex = cardIndex%10;
        cardInfo = [[NSMutableDictionary alloc] initWithDictionary:[arrayOfCardInfoFromPlist objectAtIndex:arrayOfCardInfoFromPlistIndex]];
        //create a Card object and fill this Card object with values from the cardInfo dictionary object above
        CGRect viewRect = CGRectMake(0, 0,WIDTH_OF_CARD, HEIGHT_OF_CARD);
        Card *aCard = [[Card alloc] initWithFrame:viewRect];
        [aCard setTag:(cardIndex+1)];
        //cardImage = [UIImage imageNamed: [cardInfo objectForKey:@"ImageFile"]];
        aCard.cardId = arrayOfCardInfoFromPlistIndex;
        aCard.cardIsFaceUp = FALSE;
        aCard.englishText = [cardInfo objectForKey:@"EnglishText"];
        aCard.frenchText = [cardInfo objectForKey:@"FrenchText"];
        aCard.spanishText = [cardInfo objectForKey:@"SpanishText"];
        aCard.imageFile = [[[keyName stringByAppendingString:@"_"]
                            stringByAppendingString:[cardInfo objectForKey:@"EnglishText"]
                            ]
                           stringByAppendingString:@".png"];
        aCard.imageSoundFile = [cardInfo objectForKey:@"ImageSoundFile"];
        aCard.englishTextSoundFile = [[cardInfo objectForKey:@"EnglishText"] stringByAppendingString:@"_E.mp3"];
        aCard.frenchTextSoundFile = [[cardInfo objectForKey:@"EnglishText"] stringByAppendingString:@"_F.mp3"];
        aCard.cardBackImageViewSelected.image = bgCardImage;
        aCard.cardBackImageViewNeverSelected.image = bgCardImage;
        [arrayOfTwentyCards addObject:aCard];
    }
    
    //randomize the 10 selected cards
    //UNCOMMENT NEXT LINE TO GET RANDOM ARRANGEMENT
    //KEEP NEXT LINE COMMENTED TO GET KNOWN ARANGEMENT
    //PAIRS ARE 10 APART - FOR DEBUGGING
    [self shuffle:arrayOfTwentyCards];
    
    [arrayOfCardInfoFromPlist removeAllObjects];
    
    ////create a random effect upon completing a category
    //get a random image
    int selectRandomPicture = (int)[self getRandomNumberBetween:1 maxNumber:10];
    
    Card *someCard = [[Card alloc] init];
    //get thr appropriate card based on the index number calculated above
    someCard = [arrayOfTwentyCards objectAtIndex:selectRandomPicture];
    
    
    
    //flakeImage = [UIImage imageNamed:someCard.imageFile];
    
    NSArray *chunks2 = [someCard.imageFile componentsSeparatedByString: @"."];
    NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:[chunks2 objectAtIndex:0] ofType:[chunks2 objectAtIndex:1]];
    flakeImage =  [[UIImage alloc] initWithContentsOfFile:imagePath2];
    
    
    
    int cols, rows;
    float x,y;
    UIImage *cardImage;
    
    for (rows=0,y=VERTICAL_SPACE_BEFORE_FIRST_ROW;rows <5;rows++) //was y=50;
    {
        for ( cols=0, x=HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN; cols < 4; cols++) //was x=8;
        {
            //index simply allows us to select a different image each loop. The index value is modulus 20, therefore
            //index will always be between 0 and 19
            int index = (4*rows+cols)%20;
            
            Card *someCard = [[Card alloc] init];
            //get thr appropriate card based on the index number calculated above
            someCard = [arrayOfTwentyCards objectAtIndex:index];
            
            //define position of the card object on the screen width & height
            //x and y represents the starting point of the rectangle
            someCard.frame = CGRectMake(x, y, WIDTH_OF_CARD, HEIGHT_OF_CARD);
            
            //add the card to the view
            [self.view addSubview:someCard];
            //[self.view sendSubviewToBack:someCard];
            
            //make the image container dimensions smaller than the card dimension since
            //we need room for text under card (label for image)
            CGRect viewRect = CGRectMake(0.0, 0.0, WIDTH_OF_CARD, HEIGHT_OF_CARD);
            someCard.imageContainer = [[UIImageView alloc] initWithFrame:viewRect];
            //[someCard.imageContainer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            
            //create actual image and set it to imageContainer
            //cardImage = [UIImage imageNamed:someCard.imageFile];
            
            NSArray *chunks = [someCard.imageFile componentsSeparatedByString: @"."];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0] ofType:[chunks objectAtIndex:1]];
            cardImage =  [[UIImage alloc] initWithContentsOfFile:imagePath];
            
            someCard.imageContainer.image = cardImage;
            
            //someCard.imageContainer.backgroundColor =[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.50];
            
            //add a star on the back of each card
            ////
            /*
             UIImageView *starOnBackOfCardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, STAR_WIDTH, STAR_HEIGHT)];
             starOnBackOfCardImageView.image = [UIImage imageNamed: @"star2.png"];
             starOnBackOfCardImageView.center = CGPointMake((x+WIDTH_OF_CARD/2), (y+HEIGHT_OF_CARD/2));
             [self.view addSubview:starOnBackOfCardImageView];
             [self.view bringSubviewToFront:starOnBackOfCardImageView];
             
             someCard.cardHasAYellowStarOnBack = YES;
             [starOnBackOfCardImageView setTag:(someCard.tag+100)];
             */
            
            
            x += (WIDTH_OF_CARD + HORIZONTAL_SPACE_BETWEEN_CARDS);
            
        }
        y += (HEIGHT_OF_CARD + VERTICAL_SPACE_BETWEEN_CARDS);
    }

}

- (IBAction)reLoadMMGameLevel:(id)sender
{
    [self PlaySound:@"CardShuffle.aif"];
    
    [self loadMMGameLevel:self.getCurrentMMGameLevel];

    //after the cards are reloaded, make a shaking animation for each card
    for (int numberOfCards=0;numberOfCards <20;numberOfCards++)
    {
        UIImageView  *testImage = arrayOfTwentyCards[numberOfCards];
        [self spinLayer:testImage.layer duration:2.5 direction:SPIN_CLOCK_WISE];
        
    }
    
    for (int numberOfCards=0;numberOfCards <10;numberOfCards++)
    {
        [self switchCard:(Card *)arrayOfTwentyCards[numberOfCards] withACard:(Card *)arrayOfTwentyCards[numberOfCards+10] duration:1.5];
        
    }
}

 
-(void)switchCard:(Card *)card1 withACard:(Card *)card2 duration:(CFTimeInterval)inDuration
{
    Card * aCard1 = card1;
    Card * aCard2 = card2;
    int x = card1.center.x;
    int y = card1.center.y;
    Card *temp =  [[Card alloc] init];
    temp.center = CGPointMake(x, y);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:inDuration];
    [UIView setAnimationDelegate:self];
    
    aCard1.center = aCard2.center;
    aCard2.center = temp.center;
    
    [UIView commitAnimations];
    
}

     

- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction
{
    CABasicAnimation* rotationAnimation;
    
    // Rotate about the z axis
    rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // Rotate 360 degress, in direction specified
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 4.0 * direction];
    
    // Perform the rotation over this many seconds
    rotationAnimation.duration = inDuration;
    
    // Set the pacing of the animation
    rotationAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Add animation to the layer and make it so
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


-(void)moveObjectAboveCard
{
    /*
    UIImageView * aCardImageView = (UIImageView *)(aCard.imageContainer);

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:inDuration];
    [UIView setAnimationDelegate:self];
    
    aCardImageView.center = CGPointMake(aCardImageView.center.x, aCardImageView.center.y+20);
    
    [UIView commitAnimations];
    */
    
    Card * aCard = arrayOfTwentyCards[0];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:aCard cache:YES];
    [aCard addSubview:aCard.imageContainer];
    
    [aCard.cardBackImageViewNeverSelected setHidden:TRUE];
    [aCard.cardBackImageViewSelected setHidden:TRUE];
    
    [aCard.layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

-(void)moveObjectBackIntoCard
{
    Card * aCard = arrayOfTwentyCards[0];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:aCard cache:YES];
    [aCard.imageContainer removeFromSuperview];
    
    [aCard.cardBackImageViewNeverSelected setHidden:FALSE];
    [aCard.cardBackImageViewSelected setHidden:FALSE];
    
    [aCard.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)viewDidUnload
{
    [self setCategoryName:nil];
    [self setTimerDisplay:nil];
    //[self setStarPlaceHolderOne:nil];
    //[self setStarPlaceHolderTwo:nil];
    //[self setStarPlaceHolderThree:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - WMAMMGamePauseMenuViewControllerDelegate

- (void)mmGamePauseMenuViewControllerDidContinue:
(WMAMMGamePauseMenuViewController *)controller;
{
    //start the timer so time is added to the time label that hasn't been erased but
    //still stores the old values before the game was paused
    //[self startTimer];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mmLevelCompleteViewControllerDidReloadLevel:
(WMAMMGamePauseMenuViewController *)controller;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loadMMGameLevel:self.getCurrentMMGameLevel];
}

- (void)mmGamePauseMenuViewControllerDidGoNextLevel:
(WMAMMGamePauseMenuViewController *)controller;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self goToNextLevel];}

- (void)mmLevelCompleteViewControllerDidGoNextLevel:
(WMAMMLevelCompleteViewController *)controller;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self goToNextLevel];
}

-(void)goToNextLevel
{
    //unlock next level
    NSString *nextLevelName = @"MemoryMatch_Level";
    NSString *nextLevelNumberString = [self getNextMMGameLevel];
    
    //update the currentMMGameLevel in plist before we append to nextLevelNumberString
    [self saveUserGameStateValue:nextLevelNumberString forAKey:@"currentMMGameLevel"];
    
    //we need to determine if the next level was locked (state = -2)
    //if so we unlock it by setting its state value to -1.
    if ([nextLevelNumberString length] == 1) {
        nextLevelNumberString = [@"0" stringByAppendingString:nextLevelNumberString];
    }
    
    nextLevelName = [nextLevelName stringByAppendingString:nextLevelNumberString];
    
    NSString *nextLevelCurrentStateValue = [self getUserGameStateValue:nextLevelName];
    
    if ([nextLevelCurrentStateValue isEqualToString:@"-2"]) {
        //value of "-1" indicates that the level is not played, but unlocked (is playable)
        [self saveUserGameStateValue:@"-1" forAKey:nextLevelName];
    }
    
    //load the next level (which is now the current level since we updated currentMMGameLevel
    [self loadMMGameLevel:self.getCurrentMMGameLevel];
}

- (void)mmGamePauseMenuViewControllerDidGoToLevelSelection:
(WMAMMGamePauseMenuViewController *)controller;
{
    [self.delegate mmMemoryMatchGameViewControllerDidGoToLevelSelection:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mmLevelCompleteViewControllerDidGoToLevelSelection:
(WMAMMLevelCompleteViewController *)controller;
{
    [self.delegate mmMemoryMatchGameViewControllerDidGoToLevelSelection:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mmGamePauseMenuViewControllerDidGoToMainMenu:(WMAMMGamePauseMenuViewController *)controller;
{
    [self.delegate mmMemoryMatchGameViewControllerDidGoToMainMenu:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mmLevelCompleteViewControllerDidGoToMainMenu:(WMAMMLevelCompleteViewController *)controller;
{
    [self.delegate mmMemoryMatchGameViewControllerDidGoToMainMenu:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //stop the timer in case user decides to continue with the level
    //if the user comes back to continue play, we can start at the same time
    //we had when the user paused the game
    //[self stopTimer];
    
    if ([segue.identifier isEqualToString:@"segueToPauseMMGame"])
	{
		WMAMMGamePauseMenuViewController *mmGamePauseMenuViewController = segue.destinationViewController;
		mmGamePauseMenuViewController.delegate = self;
        
        
        UIGraphicsBeginImageContext([[UIScreen mainScreen] applicationFrame].size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *pauseGameImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        //Load the background image
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        backgroundImageView.image = pauseGameImage;
        
        
        [mmGamePauseMenuViewController.view addSubview:backgroundImageView];
        [mmGamePauseMenuViewController.view  sendSubviewToBack:backgroundImageView];

	}

    if ([segue.identifier isEqualToString:@"segueToLevelCompleteMenu"])
	{
		WMAMMLevelCompleteViewController *memoryLevelCompleteViewController = segue.destinationViewController;
		memoryLevelCompleteViewController.delegate = self;
        
        UIGraphicsBeginImageContext([[UIScreen mainScreen] applicationFrame].size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *pauseGameImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        //Load the background image
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        backgroundImageView.image = pauseGameImage;
        
        
        [memoryLevelCompleteViewController.view addSubview:backgroundImageView];
        [memoryLevelCompleteViewController.view  sendSubviewToBack:backgroundImageView];
	}
}



@end
