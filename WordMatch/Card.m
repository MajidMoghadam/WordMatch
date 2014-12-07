//
//  Card.m
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-26.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import "Card.h"
#import <QuartzCore/CALayer.h>



#define CORNER_RADIUS 4.0;
#define CORNER_RADIUS_IPAD 12.0;
#define SHADOW_OPACITY 0.0;
#define SHADOW_COLOR grayColor
#define BACK_BORDER_COLOR whiteColor
#define FRONT_BORDER_COLOR whiteColor

#define BORDER_WIDTH 1.5;
#define BORDER_WIDTH_IPAD 2.0;

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define IPHONE   UIUserInterfaceIdiomPhone

@interface Card (PrivateMethods)
-(void)setCardWidthHeight;
- (CGSize) getDefaultViewSize;
@end

@implementation Card

@synthesize cardId, imageContainer, imageFile, englishText, frenchText, spanishText, englishTextSoundFile, frenchTextSoundFile, imageSoundFile,cardIsFaceUp, cardBackImageViewNeverSelected,cardBackImageViewSelected,cardHasAYellowStarOnBack
,defaultViewSize;

- (CGSize) getDefaultViewSize {
    return defaultViewSize;
}

- (id)initWithFrame:(CGRect)frame
{//[UIColor SHADOW_COLOR].CGColor;
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setCardWidthHeight];
        
        cardIsFaceUp = NO;
        cardHasAYellowStarOnBack = YES;
        
        self.layer.cornerRadius = CORNER_RADIUS;
        
        if (IDIOM==IPHONE) {
            self.layer.cornerRadius = CORNER_RADIUS;
            self.layer.borderWidth = BORDER_WIDTH;
        }else if(IDIOM==IPAD){
            self.layer.cornerRadius = CORNER_RADIUS_IPAD;
            self.layer.borderWidth = BORDER_WIDTH_IPAD;
        }

        
        self.layer.shadowColor = [UIColor SHADOW_COLOR].CGColor;
        self.layer.shadowOpacity = SHADOW_OPACITY;
        self.layer.borderColor = [UIColor BACK_BORDER_COLOR].CGColor;
        
        self.opaque = YES;
        self.clearsContextBeforeDrawing = YES;
        self.autoresizesSubviews = YES;
        self.layer.opacity = 1.0;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        
        

         UIImage *cardBackImageNeverSelected = [UIImage imageNamed: @"starburst_512_blue.png"];
        cardBackImageViewNeverSelected = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardHeight)];
        cardBackImageViewNeverSelected.image = cardBackImageNeverSelected;
        
        //UIImage *cardBackImageSelected = [UIImage imageNamed: @"cardBackWhiteStar2.png"];
        UIImage *cardBackImageSelected = [UIImage imageNamed: @"starburst_512_blue.png"];
        cardBackImageViewSelected = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardWidth)];
        cardBackImageViewSelected.image = cardBackImageSelected;
        
        //star on card used to be part of card, but i placed it in the main Game View controller
        //it was easier to handdle in the main game view.
        //cardBackImageViewStar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        //cardBackImageViewStar.image = [UIImage imageNamed: @"star_smiley.png"];
        //cardBackImageViewStar.image = [UIImage imageNamed: @"star.png"];
        
        //cardBackImageViewStar.center = cardBackImageViewNeverSelected.center;
        
        //[cardBackImageViewNeverSelected addSubview:cardBackImageViewStar];
        [self addSubview:cardBackImageViewNeverSelected];
        [self addSubview:cardBackImageViewSelected];
        //[self addSubview:cardBackImageViewStar];
        //[self bringSubviewToFront:cardBackImageViewStar];

        [self.cardBackImageViewSelected setHidden:TRUE];
        
        //[self bringSubviewToFront:cardBackImageView];
    }
    return self;
}

-(void)setCardWidthHeight
{
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
        HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 3; //16 on iphone 4S
        HORIZONTAL_SPACE_BETWEEN_IMAGES = x - 2; //16
        int remaining_space_for_images = total_screen_width - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_IMAGES);
        WIDTH_OF_LEVEL_IMAGE  = (remaining_space_for_images + 4 - 1)/4; //60;
        HEIGHT_OF_LEVEL_IMAGE = WIDTH_OF_LEVEL_IMAGE; //60;
        VERTICAL_SPACE_BEFORE_FIRST_ROW = 3*x;
        VERTICAL_SPACE_BETWEEN_IMAGES = x;
    }else if(IDIOM==IPAD){
        HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN = x + 16; //36 on ipad 2;
        HORIZONTAL_SPACE_BETWEEN_IMAGES = x; //36
        int remaining_space_for_images = total_screen_width - (2*HORIZONTAL_SPACE_BEFORE_FIRST_COLUMN +3*HORIZONTAL_SPACE_BETWEEN_IMAGES);
        WIDTH_OF_LEVEL_IMAGE  = (remaining_space_for_images + 4 - 1)/4;
        HEIGHT_OF_LEVEL_IMAGE = WIDTH_OF_LEVEL_IMAGE;
        VERTICAL_SPACE_BEFORE_FIRST_ROW = 2 * x;
        VERTICAL_SPACE_BETWEEN_IMAGES = x;
        
    }
    
    cardWidth =  WIDTH_OF_LEVEL_IMAGE;
    cardHeight =  HEIGHT_OF_LEVEL_IMAGE;
    defaultViewSize = CGSizeMake(cardWidth,cardHeight);
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
