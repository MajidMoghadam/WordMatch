//
//  Card.h
//  WordMatch
//
//  Created by Majid Moghadam on 12-02-26.
//  Copyright (c) 2012 individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIView
{
    NSInteger   cardId;
    UIImageView *imageContainer;
    NSString    *imageFile;
    NSString    *englishText;
    NSString    *frenchText;
    NSString    *spanishText;
    NSString    *englishTextSoundFile;
    NSString    *frenchTextSoundFile;
    NSString    *imageSoundFile;
    BOOL        cardIsFaceUp;
    UIImageView *cardBackImageViewNeverSelected;
    UIImageView *cardBackImageViewSelected;
    BOOL        cardHasAYellowStarOnBack;
    //UIImageView *cardBackImageViewStar;
    int cardWidth;
    int cardHeight;
    CGSize  defaultViewSize;
}

@property (nonatomic,assign)  NSInteger cardId;
@property (nonatomic,retain)  UIImageView *imageContainer;
@property (nonatomic,retain)  NSString *imageFile;
@property (nonatomic,retain)  NSString *englishText;
@property (nonatomic,retain)  NSString *frenchText;
@property (nonatomic,retain)  NSString *spanishText;
@property (nonatomic,retain)  NSString *englishTextSoundFile;
@property (nonatomic,retain)  NSString *frenchTextSoundFile;
@property (nonatomic,retain)  NSString *imageSoundFile;
@property (nonatomic,retain)  UIImageView  *cardBackImageViewNeverSelected;
@property (nonatomic,retain)  UIImageView  *cardBackImageViewSelected;
//@property (nonatomic,retain)  UIImageView  *cardBackImageViewStar;
@property (assign) BOOL cardIsFaceUp;
@property (assign) BOOL cardHasAYellowStarOnBack;
@property (nonatomic,assign)  CGSize  defaultViewSize;

//+ (CGSize)defaultViewSize;


@end

