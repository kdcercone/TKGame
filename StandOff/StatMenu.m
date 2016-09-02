//
//  StatMenu.m
//  StandOff
//
//  Created by Thomas Malitz on 8/8/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatMenu.h"

@interface StatMenu()

@property (nonatomic) Player* playerOne;
@property (nonatomic) Player* playerTwo;
@property (nonatomic) Weapon* Handgun;
@property (nonatomic) Weapon* Shotgun;
@property (nonatomic) Weapon* Sniper;
@property (nonatomic) Dodge* handgunDodge;
@property (nonatomic) Dodge* shotgunDodge;
@property (nonatomic) Dodge* sniperDodge;
@property (nonatomic) SKLabelNode* exitButton;
@property (nonatomic) float xBase;
@property (nonatomic) float yBase;

@end

@implementation StatMenu

-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        //setting xBase and yBase
        self.xBase = self.frame.size.width/2;
        self.yBase = self.frame.size.height/2;
        
        //setting scene name
        self.name = @"StatMenu";
        
        //creating weapons and dodges
        Weapon* Handgun = [Weapon weaponWithType:@"Handgun" InScene:self];
        self.Handgun = Handgun;
        Weapon* Shotgun = [Weapon weaponWithType:@"Shotgun" InScene:self];
        self.Shotgun = Shotgun;
        Weapon* Sniper  = [Weapon weaponWithType:@"Sniper" InScene:self];
        self.Sniper = Sniper;
        Dodge* handgunDodge = [Dodge dodgeForWeapon:Handgun];
        self.handgunDodge = handgunDodge;
        Dodge* shotgunDodge = [Dodge dodgeForWeapon:Shotgun];
        self.shotgunDodge = shotgunDodge;
        Dodge* sniperDodge = [Dodge dodgeForWeapon:Sniper];
        self.sniperDodge = sniperDodge;
        
        //creating players and scenario
        Player* playerOne = [Player playerWithStartingWeapon:Handgun PlayerName:@"Test1" Position:CGPointMake(self.size.width/4, self.size.height/2) InScene:self];
        playerOne.name = @"PlayerOne";
        [playerOne getPlayerData:playerOne.playerData];
        
        int playerAttributeValues[] = {playerOne.exp,playerOne.level,playerOne.wins,playerOne.losses,playerOne.draws,playerOne.handgunUses,
            playerOne.handgunDodgeUses,playerOne.shotgunUses,playerOne.shotgunDodgeUses,playerOne.sniperUses,playerOne.sniperDodgeUses,playerOne.sniperDodges,playerOne.shotgunDodges,
            playerOne.handgunDodges,playerOne.sniperKills,playerOne.shotgunKills,playerOne.handgunKills};
        NSString* playerAttributeKeys[] = {@"playerExp",@"playerLevel",@"playerWins",@"playerLosses",@"playerDraws",@"playerHandgunUses",@"playerHandgunDodgeUses",@"playerShotgunUses",@"playerShotgunDodgeUses",@"playerSniperUses",@"playerSniperDodgeUses",@"playerSniperDodges",@"playerShotgunDodges",@"playerHandgunDodges",@"playerSniperKills",@"playerShotgunKills",@"playerHandgunKills"};
        int length = (sizeof(playerAttributeValues) / sizeof(int));
        for(int i=0; i<length; i++) {
            NSLog(@"%@: %d", playerAttributeKeys[i], playerAttributeValues[i]);
        }
        float winsFloat = (float)playerOne.wins;
        float lossesFloat = (float)playerOne.losses;
        NSLog(@"KD: %f", (winsFloat/lossesFloat));
        
        [self createStatLabelsAndValuesForPlayer:playerOne];
        
        //creating exit button
        self.exitButton = [self createLabelForButtonWithText:@"Back" xPos:50 yPos:50];
        [self addChild:self.exitButton];
        
        
        //placing title
//        self.titleLabel = [SKLabelNode labelNodeWithText:@"StandOFF"];
//        self.titleLabel.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/4)*3);
//        self.statisticsButton = [SKLabelNode labelNodeWithFontNamed:@"System San Francisco Display Regular"];
//        self.statisticsButton.text = [NSString stringWithFormat:@"Player Stats"];
//        self.statisticsButton.fontSize = self.frame.size.width/20;
//        self.statisticsButton.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/4));
//        
//        //bouncing title effect
//        SKAction* moveUp = [SKAction moveByX:0 y:self.frame.size.height/12 duration:3.0];
//        SKAction* moveDown = [SKAction moveByX:0 y:-self.frame.size.height/12 duration:3.0];
//        SKAction* upDown = [SKAction sequence:@[moveDown, moveUp]];
//        SKAction* upDownLoop = [SKAction repeatActionForever:upDown];
//        [self.titleLabel runAction:upDownLoop];
//
//        
//        //pulse effect for start button
//        SKAction* fadeOut = [SKAction fadeOutWithDuration: 2];
//        SKAction* fadeIn = [SKAction fadeInWithDuration: 2];
//        SKAction* pulse = [SKAction sequence:@[fadeOut,fadeIn]];
//        SKAction* pulseLoop = [SKAction repeatActionForever:pulse];
//        [self.startButton runAction:pulseLoop];
//        

        
    }
    return self;
}


- (void) createStatLabelsAndValuesForPlayer:(Player*) player
{
    
    float winsFloat = (float)player.wins;
    float lossesFloat = (float)player.losses;
    float kDFloat = winsFloat/lossesFloat;
    SKLabelNode* winsLabel = [self createIntLabelwithText:@"kills: %d" forProperty:player.wins];
    SKLabelNode* lossesLabel = [self createIntLabelwithText:@"deaths: %d" forProperty:player.losses];
    SKLabelNode* drawsLabel = [self createIntLabelwithText:@"draws: %d" forProperty:[player getTrueDraws]];
    SKLabelNode* dodgesLabel = [self createIntLabelwithText:@"dodges: %d" forProperty:[player getTotalDodges]];
    SKLabelNode* winLossLabel = [self createFloatLabelwithText:@"KD: %f" forProperty:kDFloat];
    SKLabelNode* favoriteWeaponLabel = [self createStringLabelwithText:@"Favorite Weapon: %@" forProperty:[player getFavoriteWeapon]];
    SKLabelNode* favoriteDodgeLabel = [self createStringLabelwithText:@"Favorite Dodge: %@" forProperty:[player getFavoriteDodge]];
    SKLabelNode* bestWeaponLabel = [self createStringLabelwithText:@"Best Weapon: %@" forProperty:[player getBestWeapon]];
    SKLabelNode* bestDodgeLabel = [self createStringLabelwithText:@"Best Dodge: %@" forProperty:[player getBestDodge]];
    SKLabelNode* weaponAccuracyLabel = [self createFloatLabelwithText:@"Weapon Accuracy: %.02f %%" forProperty:[player getWeaponAccuracyPercentage]];
    SKLabelNode* dodgeAccuracyLabel = [self createFloatLabelwithText:@"Dodge Accuracy: %.02f %%" forProperty:[player getDodgeAccuracyPercentage]];
    NSArray* labelArray = @[winsLabel, lossesLabel, dodgesLabel, drawsLabel, winLossLabel, weaponAccuracyLabel, dodgeAccuracyLabel, favoriteWeaponLabel, favoriteDodgeLabel, bestWeaponLabel, bestDodgeLabel];
    CGFloat xpos = self.frame.size.width/2;
    CGFloat yposBase = self.frame.size.height - 10;
    int length = [labelArray count];
    NSLog(@"size of array: %d: ", length);
    for(int i=0; i<length; i++) {
        SKLabelNode* label = labelArray[i];
        label.fontSize = 10;
        label.position = CGPointMake(xpos, yposBase - (i * 30));
    }
    
}

- (SKLabelNode*) createLabelForButtonWithText:(NSString*) text xPos:(CGFloat) xpos yPos:(CGFloat) ypos
{
    SKLabelNode* button = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
    button.text = [NSString stringWithFormat:text];
    button.fontSize = self.frame.size.width/20;
    button.position = CGPointMake(xpos, ypos);
    return button;
}

- (SKLabelNode*)createIntLabelwithText:(NSString*) text forProperty:(int) int_number
{
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
    label.text = [NSString stringWithFormat:text, int_number];
    [self addChild:label];
    return label;
}

- (SKLabelNode*)createFloatLabelwithText:(NSString*) text forProperty:(float) float_number
{
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
    label.text = [NSString stringWithFormat:text, float_number];
    [self addChild:label];
    return label;
}

- (SKLabelNode*)createStringLabelwithText:(NSString*) text forProperty:(NSString*) string
{
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
    label.text = [NSString stringWithFormat:text, string];
    [self addChild:label];
    return label;
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch* touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self];
//
//    SKScene* gameRoom = [[GameScene alloc] initWithSize:self.size];
//    SKTransition* moveToGameRoom = [SKTransition doorsOpenHorizontalWithDuration:1.0];
//    moveToGameRoom.pausesIncomingScene = NO;
//
//    if (((touchLocation.x>(self.startButton.position.x-(self.startButton.fontSize*2))) && (touchLocation.x<(self.startButton.position.x+(self.startButton.fontSize*2))) && (touchLocation.y<(self.startButton.position.y+(self.startButton.fontSize))) && (touchLocation.y>(self.startButton.position.y-(self.startButton.fontSize)))) && (self.timePassed > 45)) {
//        [self removeAllActions];
//        [self.view presentScene:gameRoom transition:moveToGameRoom];
//    }
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint touchLocation = [t locationInNode:self.scene];
    
    if(CGRectContainsPoint(self.exitButton.frame, touchLocation)) {
        // do whatever for first menu
        NSLog(@"Start Button was pressed");
        SKScene* mainMenu = [[MainMenu alloc] initWithSize:self.size];
        SKTransition* moveToMainMenu = [SKTransition doorsCloseVerticalWithDuration:0.5];
        moveToMainMenu.pausesIncomingScene = NO;
        [self removeAllActions];
        [self.view presentScene:mainMenu transition:moveToMainMenu];
    }
    
}
    

- (void)update:(NSTimeInterval)currentTime
{
    
    
    
}

@end