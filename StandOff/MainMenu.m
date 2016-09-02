//
//  MainMenu.m
//  ColorRoom
//
//  Created by Thomas Malitz on 1/29/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import "MainMenu.h"
//#import <Chartboost/Chartboost.h>

@interface MainMenu()
@property (nonatomic) Button* playButton;
@property (nonatomic) Button* customizeButton;
@property (nonatomic) Button* statisticsButton;
@property (nonatomic) Button* howToPlayButton;
@property (nonatomic) SKLabelNode* titleLabel;
@property (nonatomic) BOOL adExists;
@property (nonatomic) int timePassed;

@end

@implementation MainMenu


-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor grayColor];
        NSLog(@"width: %f", self.size.width);
        NSLog(@"height: %f", self.size.height);
        
        //preload textures for weapons
        NSMutableArray* textureArray = [[NSMutableArray alloc] init];
        
        [textureArray addObject: [SKTexture textureWithImageNamed:@"handgun.png"]];
        [textureArray addObject: [SKTexture textureWithImageNamed:@"shotgun.png"]];
        [textureArray addObject: [SKTexture textureWithImageNamed:@"sniper.png"]];
        [textureArray addObject: [SKTexture textureWithImageNamed:@"greenArrow.png"]];
        
        
        [SKTexture preloadTextures:textureArray withCompletionHandler:^{
            //check fonts
//            NSArray *fontFamilies = [UIFont familyNames];
//            
//            for (int i = 0; i < [fontFamilies count]; i++)
//            {
//                NSString *fontFamily = [fontFamilies objectAtIndex:i];
//                NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//                NSLog (@"%@: %@", fontFamily, fontNames);
//            }
            
            CGFloat xBase = self.frame.size.width/2;
            CGFloat yBase = self.frame.size.height/2;
            CGFloat width = self.frame.size.width;
            CGFloat height = self.frame.size.height;
            
            //setting scene name
            self.name = @"MainMenu";
            
            
            //placing title
            self.titleLabel = [SKLabelNode labelNodeWithText:@"StandOFF"];
            self.titleLabel.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/4)*3);
            self.titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            
            
            //placing player stat button
            self.statisticsButton = [Button buttonWithImage:@"statButton@3x.png" xPos:xBase*.50 yPos:yBase/2];
            self.statisticsButton.xScale = width/(width+(width/25));
            self.statisticsButton.yScale = width/(width+(width/25));
            [self addChild:self.statisticsButton];

            
            //placing player customization button
            self.customizeButton = [Button buttonWithImage:@"customizeButton@3x.png" xPos:xBase yPos:yBase/2];
            self.customizeButton.xScale = width/(width+(width/25));
            self.customizeButton.yScale = width/(width+(width/25));
            [self addChild:self.customizeButton];
            
            //place how to play button
            self.howToPlayButton = [Button buttonWithImage:@"howToButton@3x.png" xPos:xBase*1.5 yPos:yBase/2];
            self.howToPlayButton.xScale = width/(width+(width/25));
            self.howToPlayButton.yScale = width/(width+(width/25));
            [self addChild:self.howToPlayButton];
            
            //placing start button
            self.playButton = [Button buttonWithImage:@"playButton@3x.png" xPos:xBase yPos:yBase];
            [self addChild:self.playButton];
            
            //bouncing title effect
            SKAction* moveUp = [SKAction moveByX:0 y:self.frame.size.height/12 duration:3.0];
            SKAction* moveDown = [SKAction moveByX:0 y:-self.frame.size.height/12 duration:3.0];
            SKAction* upDown = [SKAction sequence:@[moveDown, moveUp]];
            SKAction* upDownLoop = [SKAction repeatActionForever:upDown];
            [self.titleLabel runAction:upDownLoop];
            
            
            //pulse effect for start button
            SKAction* fadeOut = [SKAction fadeOutWithDuration: 2];
            SKAction* fadeIn = [SKAction fadeInWithDuration: 2];
            SKAction* pulse = [SKAction sequence:@[fadeOut,fadeIn]];
            SKAction* pulseLoop = [SKAction repeatActionForever:pulse];
            //[self.playButton runAction:pulseLoop];
            
            
            
            self.adExists = NO;
            self.timePassed = 0;
            [self addChild:self.titleLabel];
            //[UIViewController showFullScreenAd]
        }];
        
    }
    return self;
}


- (SKSpriteNode*) createLabelForButtonWithImage:(NSString*) image xPos:(CGFloat) xpos yPos:(CGFloat) ypos
{
    SKSpriteNode* button = [SKSpriteNode spriteNodeWithImageNamed:image];
    button.yScale = 1.2;
    button.xScale = 1.2;
    button.position = CGPointMake(xpos, ypos);
    return button;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.playButton touchesBegan:touches withEvent:event InScene:self];
    [self.customizeButton touchesBegan:touches withEvent:event InScene:self];
    [self.howToPlayButton touchesBegan:touches withEvent:event InScene:self];
    [self.statisticsButton touchesBegan:touches withEvent:event InScene:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.playButton touchesMoved:touches withEvent:event InScene:self];
    [self.customizeButton touchesMoved:touches withEvent:event InScene:self];
    [self.howToPlayButton touchesMoved:touches withEvent:event InScene:self];
    [self.statisticsButton touchesMoved:touches withEvent:event InScene:self];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.playButton touchesEnded:touches withEvent:event InScene:self];
    [self.customizeButton touchesEnded:touches withEvent:event InScene:self];
    [self.howToPlayButton touchesEnded:touches withEvent:event InScene:self];
    [self.statisticsButton touchesEnded:touches withEvent:event InScene:self];
    
    
    UITouch *t = [touches anyObject];
    CGPoint touchLocation = [t locationInNode:self.scene];
    
    if(CGRectContainsPoint(self.playButton.frame, touchLocation)) {
        // do whatever for first menu
        if(self.playButton.alpha==0.5) {
            NSLog(@"Start Button was pressed");
            SKScene* gameRoom = [[GameScene alloc] initWithSize:self.size];
            SKTransition* moveToGameRoom = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.30];
            moveToGameRoom.pausesIncomingScene = NO;
            [self removeAllActions];
            [self.view presentScene:gameRoom transition:moveToGameRoom];
        }
    }
    
        if(CGRectContainsPoint(self.statisticsButton.frame, touchLocation)) {
            // do whatever for first menu
            NSLog(@"Stats Button was pressed");
            SKScene* statMenu = [[StatMenu alloc] initWithSize:self.size];
            SKTransition* moveToStatScreen = [SKTransition doorsOpenHorizontalWithDuration:0.30];
            moveToStatScreen.pausesIncomingScene = NO;
            [self removeAllActions];
            [self.view presentScene:statMenu transition:moveToStatScreen];
        }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.playButton touchesCancelled:touches withEvent:event];
    [self.customizeButton touchesCancelled:touches withEvent:event];
    [self.howToPlayButton touchesCancelled:touches withEvent:event];
    [self.statisticsButton touchesCancelled:touches withEvent:event];
}


- (void)update:(NSTimeInterval)currentTime
{
  
    self.timePassed += 1;
    
    //only show ad once per access to main menu, and after 2 seconds
    if((self.adExists == NO) && (self.timePassed > 20)) {
      //[Chartboost showInterstitial:CBLocationHomeScreen];
        self.adExists = YES;
        self.timePassed = 0;
    }
    
    
    
}



@end
