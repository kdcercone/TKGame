//
//  GameScene.h
//  StandOff
//

//  Copyright (c) 2016 Thomas Malitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIkit.h>
#import "Player.h"
#import "Weapon.h"
#import "Dodge.h"
#import "MainMenu.h"
#import "GameStateHandler.h"

@interface GameScene : SKScene

@property (nonatomic) Player* playerOne;
@property (nonatomic) Player* playerTwo;
@property (nonatomic) Weapon* Handgun;
@property (nonatomic) Weapon* Shotgun;
@property (nonatomic) Weapon* Sniper;
@property (nonatomic) Dodge* handgunDodge;
@property (nonatomic) Dodge* shotgunDodge;
@property (nonatomic) Dodge* sniperDodge;
@property (nonatomic) GameStateHandler* handler;
@property (nonatomic) SKLabelNode* countDownLabel;
@property (nonatomic) SKLabelNode* drawWeaponLabel;
@property (nonatomic) SKLabelNode* winnerStatusLabel;
@property (nonatomic) SKLabelNode* exitButton;
@property (nonatomic) SKSpriteNode* floorBanner;
@property (nonatomic) NSString* currentWinnerStatus;
@property (nonatomic) BOOL endOfDraw;
@property (nonatomic) BOOL canDodgeNow;
@property (nonatomic) BOOL countDownExists;
@property (nonatomic) BOOL winner;
@property (nonatomic) int countDown;
@property (nonatomic) int countDownTimer;
@property (nonatomic) int dodgeWindowTimer;
@property (nonatomic) float dodgeWindow;
@property (nonatomic) float countDownWindow;
@property (nonatomic) float xBase;
@property (nonatomic) float yBase;


-(id)initWithSize:(CGSize)size;
- (void)addLabelsForPlayer:(Player*) player;
- (void)removeLabelsForPlayer:(Player*) player;
- (void)setPlayerData:(NSUserDefaults *)playerData ForPlayer:(Player*) player;
- (SKLabelNode*) createLabelForButtonWithText:(NSString*) text xPos:(CGFloat) xpos yPos:(CGFloat) ypos;

@end
