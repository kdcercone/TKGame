//
//  GameScene.m
//  StandOff
//
//  Created by Thomas Malitz on 6/29/16.
//  Copyright (c) 2016 Thomas Malitz. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()


@end

@implementation GameScene


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKTexture* handgunTexture = [SKTexture textureWithImageNamed:@"handgun.png"];
        SKTexture* shotgunTexture = [SKTexture textureWithImageNamed:@"shotgun.png"];
        SKTexture* sniperTexture = [SKTexture textureWithImageNamed:@"sniper.png"];
        
        NSArray* textureArray = @[handgunTexture, shotgunTexture, sniperTexture];
        
        [SKTexture preloadTextures:textureArray withCompletionHandler:^{
            
            self.backgroundColor = [SKColor blackColor];
            NSLog(@"width: %f", self.size.width);
            NSLog(@"height: %f", self.size.height);
            
            
            //setting xBase and yBase
            self.xBase = self.frame.size.width/2;
            self.yBase = self.frame.size.height/2;
            
            //adding floor banner
            self.floorBanner = [SKSpriteNode spriteNodeWithImageNamed:@"floorBannerGreenBlue@3x.png"];
            self.floorBanner.position = CGPointMake(self.xBase, self.floorBanner.size.height/2);
            self.floorBanner.xScale = self.xBase/200;
            self.floorBanner.yScale = self.yBase/200;
            self.floorBanner.zPosition = -2;
            [self addChild:self.floorBanner];
            
            
            //setting scene name
            self.name = @"GameScene";
            
            //creating weapons and dodges
            Weapon* Handgun = [Weapon weaponWithType:@"handgun.png" InScene:self];
            self.Handgun = Handgun;
            Weapon* Shotgun = [Weapon weaponWithType:@"shotgun.png" InScene:self];
            self.Shotgun = Shotgun;
            Weapon* Sniper  = [Weapon weaponWithType:@"sniper.png" InScene:self];
            self.Sniper = Sniper;
            Dodge* handgunDodge = [Dodge dodgeForWeapon:Handgun];
            self.handgunDodge = handgunDodge;
            Dodge* shotgunDodge = [Dodge dodgeForWeapon:Shotgun];
            self.shotgunDodge = shotgunDodge;
            Dodge* sniperDodge = [Dodge dodgeForWeapon:Sniper];
            self.sniperDodge = sniperDodge;
            
            
            //creating players and scenario
            Player* playerOne = [Player playerWithStartingWeapon:Handgun PlayerName:@"Test1" Position:CGPointMake(self.xBase/2, self.yBase/1.3) InScene:self];
            playerOne.name = @"PlayerOne";
            [playerOne getPlayerData:playerOne.playerData];
            [playerOne addCharacterInScene:self];//adding player body
            
            //playerTwo
            Player* playerTwo = [Player playerWithStartingWeapon:Shotgun PlayerName:@"Test2" Position:CGPointMake((self.xBase/2)*3, self.yBase/1.3) InScene:self];
            playerTwo.name = @"PlayerTwo";
            [playerTwo addCharacterInScene:self];//adding player body
            
            //game handler
            GameStateHandler* gameHandler = [GameStateHandler gameStateHandlerWithPlayerOne:playerOne PlayerTwo:playerTwo];
            self.playerOne = playerOne;
            self.playerTwo = playerTwo;
            self.handler = gameHandler;
            
            //creating labels for testing
            SKLabelNode* countDownLabel = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
            countDownLabel.position = CGPointMake(self.xBase, self.yBase*1.2);
            self.countDownLabel = countDownLabel;
            [self addChild:self.countDownLabel];
            
            
            //adding exit button
            self.exitButton = [self createLabelForButtonWithText:@"Back" xPos:self.xBase yPos:self.yBase+self.yBase/1.5];
            [self addChild:self.exitButton];
            
            //draw weapon instruction label
            self.drawWeaponLabel = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
            self.drawWeaponLabel.text = @"CHOOSE YOUR WEAPON NOW";
            self.drawWeaponLabel.fontSize = self.size.width/28;
            self.drawWeaponLabel.alpha = 0.2;
            self.drawWeaponLabel.position = CGPointMake(self.xBase, self.yBase+self.yBase/2);
            self.drawWeaponLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
            
            
            //adding nodes
            [self addChild:self.playerOne];
            [self addChild:self.playerTwo];
            [self addChild:self.handler];
            [self addLabelsForPlayer:self.playerOne];
            [self addLabelsForPlayer:self.playerTwo];
            
            //setting initial gameScene properties
            self.countDown = 0;
            self.countDownTimer = 0;
            self.dodgeWindowTimer = 0;
            self.winner = 0;//set it to be a draw by default
            self.canDodgeNow = NO;
            self.endOfDraw = NO;
            self.dodgeWindow = 1.0;//one second dodge window to start
            self.countDownWindow = 4.0;//4-second count down window
            self.currentWinnerStatus = @"DRAW";
            
            //console logging
            NSLog(@"PlayerOne's weapon: %@", playerOne.currentWeapon.type);
            NSLog(@"PlayerTwo's weapon: %@", playerTwo.currentWeapon.type);
            NSLog(@"PlayerOne's dodge: %@", playerOne.currentDodge.forWeapon.type);
            NSLog(@"PlayerTwo's dodge: %@", playerTwo.currentDodge.forWeapon.type);
            
            
            [self drawLoop];//run draw loop
        
        }];
    }
    return self;
}

-(NSArray*)countDownAction
{
    
    //place and run action on "choose weapon now" label
    SKAction* fadeOut = [SKAction fadeAlphaTo:0.2 duration:1];
    SKAction* fadeIn = [SKAction fadeAlphaTo:0.8 duration:1];
    SKAction* pulse = [SKAction sequence:@[fadeOut,fadeIn]];
    SKAction* pulseLoop = [SKAction repeatActionForever:pulse];
    [self addChild:self.drawWeaponLabel];
    [self.drawWeaponLabel runAction:pulseLoop];
    
    //labels for count down
    SKLabelNode* one = [SKLabelNode labelNodeWithFontNamed:@"Bullpen3D"];
    one.text = @"1";
    SKLabelNode* two = [SKLabelNode labelNodeWithFontNamed:@"Bullpen3D"];
    two.text = @"2";
    SKLabelNode* three = [SKLabelNode labelNodeWithFontNamed:@"Bullpen3D"];
    three.text = @"3";
    SKLabelNode* draw = [SKLabelNode labelNodeWithFontNamed:@"Bullpen3D"];
    draw.text = @"Draw!";
    one.position = CGPointMake(0, self.floorBanner.size.height/2);
    two.position = CGPointMake(0, self.floorBanner.size.height/2);
    three.position = CGPointMake(0, self.floorBanner.size.height/2);
    draw.position = CGPointMake(0, self.floorBanner.size.height/2);
    one.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    two.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    three.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    draw.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    one.hidden = YES;
    two.hidden = YES;
    three.hidden = YES;
    draw.hidden = YES;
    SKAction* pushRightFast = [SKAction moveByX:(self.frame.size.width/8)*3 y:0 duration:self.countDownWindow/40];//40 because the first count down window is 4 seconds (including the draw!)
    SKAction* pushRightSlow = [SKAction moveByX:(self.frame.size.width/8)*2 y:0 duration:(self.countDownWindow/40)*8];
    SKAction* pushRightFastOff = [SKAction moveByX:(self.frame.size.width/8)*4 y:0 duration:self.countDownWindow/40];
    SKAction* pushFastThenSlow = [SKAction sequence:@[pushRightFast, pushRightSlow, pushRightFastOff]];
    [self addChild:one];
    [self addChild:two];
    [self addChild:three];
    [self addChild:draw];
    one.hidden = NO;
    [one runAction:pushFastThenSlow completion:^{
        two.hidden = NO;
        [two runAction:pushFastThenSlow completion:^{
            three.hidden = NO;
            [three runAction:pushFastThenSlow completion:^{
                draw.hidden = NO;
                [draw runAction:pushFastThenSlow];
            }];
        }];
    }];
    NSArray* numberLabels = @[one,two,three,draw];
    return numberLabels;
    
    
}


- (SKLabelNode*) createLabelForButtonWithText:(NSString*) text xPos:(CGFloat) xpos yPos:(CGFloat) ypos
{
    SKLabelNode* button = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
    button.text = [NSString stringWithFormat:text];
    button.fontSize = self.frame.size.width/20;
    button.position = CGPointMake(xpos, ypos);
    return button;
}

- (SKSpriteNode*)createArrowSprite:(NSString*) direction
{
//    SKSpriteNode* arrowSprite = [SKSpriteNode spriteNodeWithImageNamed:@"greenArrow"];
//    arrowSprite.xScale = .25;
//    arrowSprite.yScale = .25;
//    arrowSprite.hidden = YES;
    SKSpriteNode* arrowSprite;
    
    int yOffset = (self.playerOne.frame.size.height/2);
    int xOffset = (self.playerOne.frame.size.width/2);
    
    if([direction isEqualToString:@"UP"]) {
        arrowSprite = [SKSpriteNode spriteNodeWithImageNamed:@"sniper.png"];
        arrowSprite.position = CGPointMake(self.playerOne.position.x, self.playerOne.position.y+yOffset);
        //arrowSprite.zRotation = M_PI;
    }
    if([direction isEqualToString:@"DOWN"]) {
        arrowSprite = [SKSpriteNode spriteNodeWithImageNamed:@"sniper.png"];
        //arrowSprite.position = CGPointMake(self.playerOne.position.x, self.playerOne.position.y-yOffset);
    }
    if([direction isEqualToString:@"RIGHT"]) {
        arrowSprite = [SKSpriteNode spriteNodeWithImageNamed:@"shotgun.png"];
        arrowSprite.position = CGPointMake(self.playerOne.position.x+xOffset, self.playerOne.position.y);
        //arrowSprite.zRotation = M_PI_2;
    }
    if([direction isEqualToString:@"LEFT"]) {
        arrowSprite = [SKSpriteNode spriteNodeWithImageNamed:@"handgun.png"];
        arrowSprite.position = CGPointMake(self.playerOne.position.x-xOffset, self.playerOne.position.y);
        //arrowSprite.zRotation = -M_PI_2;
    }
    
    arrowSprite.xScale = .25;
    arrowSprite.yScale = .25;
    arrowSprite.hidden = YES;
    
    [self addChild:arrowSprite];
    return arrowSprite;
}

/** run animation for swipe selection **/
-(void)runArrowAnimation:(SKSpriteNode*) sprite Direction:(NSString*) direction
{
//    SKSpriteNode* iconBackground = [SKSpriteNode spriteNodeWithImageNamed:@"gunSelectOutline.png"];
//    iconBackground.xScale = .25;
//    iconBackground.yScale = .25;
//    iconBackground.zPosition = -1;
//    [self addChild:iconBackground];
//    iconBackground.position = sprite.position;
    sprite.hidden = NO;
    float yOffset = ((float)sprite.frame.size.height/1.5);
    float xOffset = ((float)sprite.frame.size.width/1.5);
    SKAction* moveUp;
    SKAction* fadeOut = [SKAction fadeOutWithDuration:0.50];
    SKAction* pop = [SKAction scaleBy:1.8 duration:0.25];
    
    if([direction isEqualToString:@"UP"]) {
        moveUp = [SKAction moveByX:0 y:yOffset duration:0.15];
    }
    if([direction isEqualToString:@"DOWN"]) {
        moveUp = [SKAction moveByX:0 y:-yOffset duration:0.15];
    }
    if([direction isEqualToString:@"RIGHT"]) {
        moveUp = [SKAction moveByX:xOffset y:0 duration:0.15];
    }
    if([direction isEqualToString:@"LEFT"]) {
        moveUp = [SKAction moveByX:-xOffset y:0 duration:0.15];
    }
    
    SKAction* popAndFade = [SKAction group:@[pop, fadeOut]];
    SKAction* moveUpFadeOut = [SKAction sequence:@[moveUp,popAndFade]];
    //[iconBackground runAction:moveUpFadeOut];
    [sprite runAction:moveUpFadeOut];
}


- (void)addLabelsForPlayer:(Player*) player
{
    if(player.attacking) {
        //NSLog(@"adding weaponLabel: %@", player.weaponLabel.text);
        //[self addChild:player.weaponLabel];
    }
    if(player.dodging) {
        //NSLog(@"adding dodgeLabel: %@", player.dodgeLabel.text);
        [self addChild:player.dodgeLabel];
    }
    
}

//
//- (void)addWeaponType:(NSString*) weaponType ForPlayer:(Player*) player
//{
//    Weapon* Handgun = [Weapon weaponWithType:@"handgun"];
//    Weapon* Shotgun = [Weapon weaponWithType:@"shotgun"];
//    Weapon* Sniper  = [Weapon weaponWithType:@"sniper"];
//    
//    
//}


- (void)removeLabelsForPlayer:(Player*) player
{

    [player.weaponLabel removeFromParent];
    [player.dodgeLabel removeFromParent];
}


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //recognizers used to interpret player swipes
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [[self view] addGestureRecognizer:upRecognizer];
    [[self view] addGestureRecognizer:downRecognizer];
    [[self view] addGestureRecognizer:rightRecognizer];
    [[self view] addGestureRecognizer:leftRecognizer];
    
    
}


- (void)setPlayerData:(NSUserDefaults *)playerData ForPlayer:(Player*) player
{
    int playerAttributeValues[] = {player.exp,player.level,player.wins,player.losses,player.draws,player.handgunUses,
        player.handgunDodgeUses,player.shotgunUses,player.shotgunDodgeUses,player.sniperUses,player.sniperDodgeUses,player.sniperDodges,player.shotgunDodges,
        player.handgunDodges,player.sniperKills,player.shotgunKills,player.handgunKills};
    
    NSString* playerAttributeKeys[] = {@"playerExp",@"playerLevel",@"playerWins",@"playerLosses",@"playerDraws",@"playerHandgunUses",@"playerHandgunDodgeUses",@"playerShotgunUses",@"playerShotgunDodgeUses",@"playerSniperUses",@"playerSniperDodgeUses",@"playerSniperDodges",@"playerShotgunDodges",@"playerHandgunDodges",@"playerSniperKills",@"playerShotgunKills",@"playerHandgunKills"};
    
    
    int length = (sizeof(playerAttributeValues) / sizeof(int));
    for(int i=0; i<length; i++) {
        //NSLog(@"Previous %@ value: %d", playerAttributeKeys[i], playerAttributeValues[i]);
        [playerData setObject:[NSNumber numberWithInt:playerAttributeValues[i]] forKey:playerAttributeKeys[i]];
    }
    
    //[playerData setObject:[NSString stringWithString:player.name] forKey:@"playerName"];
    [playerData synchronize];
    
}


- (void)interpretSwipe:(UISwipeGestureRecognizer *)swipe Player:(Player*) player CanDodge:(BOOL) canDodge
{
    if (self.endOfDraw) {
        //do nothing
    }
    else {
        if (canDodge) {
            player.attacking = false;
            player.dodging = true;
        }
        if (!canDodge) {
            player.attacking = true;
            player.dodging = false;
        }
        [self removeLabelsForPlayer:player];
        if (player.attacking) {
            switch (swipe.direction) {
                case UISwipeGestureRecognizerDirectionUp:
                    {
                        NSLog(@"UP SWIPE");
                        //[player.currentWeapon removeFromParent];
                        [player changeWeaponTo:player.sniperForShow ForScene:self];
                        SKSpriteNode* arrowSprite = [self createArrowSprite:@"UP"];
                        [self runArrowAnimation:arrowSprite Direction:@"UP"];
                    }
                    break;
                case UISwipeGestureRecognizerDirectionDown:
                    {
                        NSLog(@"DOWN SWIPE");
                        
                    }
                    break;
                case UISwipeGestureRecognizerDirectionLeft:
                    {
                        NSLog(@"LEFT SWIPE");
                        //[player.currentWeapon removeFromParent];
                        [player changeWeaponTo:player.handgunForShow ForScene:self];
                        SKSpriteNode* arrowSprite = [self createArrowSprite:@"LEFT"];
                        [self runArrowAnimation:arrowSprite Direction:@"LEFT"];
                    }
                    break;
                case UISwipeGestureRecognizerDirectionRight:
                    {
                        NSLog(@"RIGHT SWIPE");
                        //[player.currentWeapon removeFromParent];
                        [player changeWeaponTo:player.shotgunForShow ForScene:self];
                        SKSpriteNode* arrowSprite = [self createArrowSprite:@"RIGHT"];
                        [self runArrowAnimation:arrowSprite Direction:@"RIGHT"];
                    }
                    break;
                default:
                    NSLog(@"DEFAULT SWIPE");
                    player.currentWeapon = player.currentWeapon;
                    break;
            }
        }

        if((player.dodging) && (!player.choseDodge)) {
            player.choseDodge = true;//makes player commit to the first dodge they choose
            [player.currentWeapon removeFromParent];//remove player's weapon since they are dodging*****testing mode
            switch (swipe.direction) {
                case UISwipeGestureRecognizerDirectionUp:
                    {
                        NSLog(@"UP SWIPE");
                        player.currentDodge = player.currentDodge;
                    }
                    break;
                case UISwipeGestureRecognizerDirectionDown:
                    {
                        NSLog(@"DOWN SWIPE");
                        [player changeDodgeTo:self.sniperDodge];
                        SKSpriteNode* arrowSprite = [self createArrowSprite:@"DOWN"];
                        [self runArrowAnimation:arrowSprite Direction:@"DOWN"];
                    }
                    break;
                case UISwipeGestureRecognizerDirectionLeft:
                    {
                        NSLog(@"LEFT SWIPE");
                        [player changeDodgeTo:self.handgunDodge];
                        SKSpriteNode* arrowSprite = [self createArrowSprite:@"LEFT"];
                        [self runArrowAnimation:arrowSprite Direction:@"LEFT"];
                    }
                    break;
                case UISwipeGestureRecognizerDirectionRight:
                    {
                        NSLog(@"RIGHT SWIPE");
                        [player changeDodgeTo:self.shotgunDodge];
                        SKSpriteNode* arrowSprite = [self createArrowSprite:@"RIGHT"];
                        [self runArrowAnimation:arrowSprite Direction:@"RIGHT"];
                    }
                    break;
                default:
                    NSLog(@"DEFAULT SWIPE");
                    player.currentDodge = player.currentDodge;
                    break;
            }
        }
        [self addLabelsForPlayer:player];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchLocation = [sender locationInView:sender.view];
        touchLocation = [self convertPointFromView:touchLocation];
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        //NSLog(@"%@", touchedNode);
        
        if ([touchedNode.name isEqualToString:@"PlayerOne"]) {
            [self interpretSwipe:sender Player:self.playerOne CanDodge:self.canDodgeNow];
        }
    }
}




- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint touchLocation = [t locationInNode:self.scene];
    
    if(CGRectContainsPoint(self.exitButton.frame, touchLocation)) {
        NSLog(@"Start Button was pressed");
        SKScene* mainMenu = [[MainMenu alloc] initWithSize:self.size];
        SKTransition* moveToMainMenu = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
        moveToMainMenu.pausesIncomingScene = NO;
        [self removeAllActions];
        [self.view presentScene:mainMenu transition:moveToMainMenu];
    }
    
}


-(int) standOffPlayerOne:(Player*) playerOne playerTwo:(Player*) playerTwo Handler:(GameStateHandler*) handler
{
    int winner = [handler whoWins:playerOne PlayerTwo:playerTwo];
    switch (winner) {
        case 1:
            self.currentWinnerStatus = @"PlayerOne wins!";
            break;
        case 2:
            self.currentWinnerStatus = @"PlayerTwo wins!";
            break;
        case 0:
            self.currentWinnerStatus = @"Draw!";
            self.countDown = 0;
            break;
        default:
            NSLog(@"ERROR");
            break;
    }
    
    return winner;
}


static inline int randomNumber()
{
    return arc4random_uniform(3)+1;
}

//- (void) playLoop
//{
//    self.countDownTimer += 1;
//    NSArray* countDownNumbers;
//    
//    if((self.countDownTimer >= 0) && (self.countDownTimer < 2)) {
//        
//        //printing results to screen
//        self.countDownLabel.text = self.currentWinnerStatus;
//        
//        //doing count down animation
//        countDownNumbers = [self countDownAction];
//        
//        //random gun testing for ai
//        int rand = randomNumber();
//        switch (rand) {
//            case 1:
//                [self.playerTwo changeWeaponTo:self.playerTwo.shotgunForShow ForScene:self];
//                break;
//            case 2:
//                [self.playerTwo changeWeaponTo:self.playerTwo.handgunForShow ForScene:self];
//                break;
//            case 3:
//                [self.playerTwo changeWeaponTo:self.playerTwo.sniperForShow ForScene:self];
//            default:
//                break;
//        }
//        
//        //remove labels for playerOne*****Testing
//        [self removeLabelsForPlayer:self.playerOne];
//    }
//    
//    
////    if(((self.countDownTimer % 60) == 0) && (self.countDownTimer < self.countDownWindow+2)) {//creating 1 2 3 countdown and then says DRAW
////        self.countDown += 1;
////        self.countDownLabel.text = [NSString stringWithFormat:@"%d", self.countDown];
////        if (self.countDownTimer == self.countDownWindow) {
////            self.countDownLabel.text = @"DRAW";
////        }
////    }
//    
//    if (self.countDownTimer > self.countDownWindow+10) {//weapons will be drawn now
//        [self.drawWeaponLabel removeFromParent];
//        [self.countDownLabel removeFromParent];
//        self.dodgeWindowTimer += 1;
//        if(!self.canDodgeNow) {//removing actions right before canDodgeNow is set to YES
//            for (id number in countDownNumbers) {//removing count down numbers from the scene
//                NSLog(@"HERE");
//                NSLog(@"number: %@", number);
//                [number removeFromParent];
//            }
//            [self.playerOne removeWeaponAndBodyActions];//stops player body parts and weapons from still bobbing
//            [self.playerOne.currentWeapon removeAllActions];
//            [self.playerTwo removeWeaponAndBodyActions];
//            [self.playerTwo.currentWeapon removeAllActions];
//        }
//        self.canDodgeNow = YES;
//        if(![self.playerOne.currentWeapon hasActions]) {//animation bringing gun up
//            float dodgeWindowF = (float) self.dodgeWindow;
//            [self.playerOne.currentWeapon animateWeaponDrawWithTimeWindow:dodgeWindowF InScene:self];
//            //[drawAnimation reversedAction];
//        }
//        if(![self.playerTwo.currentWeapon hasActions]) {//animation bringing gun up
//            float dodgeWindowF = (float) self.dodgeWindow;
//            [self.playerTwo.currentWeapon animateWeaponDrawWithTimeWindow:dodgeWindowF InScene:self];
//            //[drawAnimation reversedAction];
//        }
//        if(self.dodgeWindowTimer > self.dodgeWindow) {//weapons have been fully drawn and cannot be dodged anymore
//            //self.endOfDraw = YES;
//            self.canDodgeNow = NO;
//            int winner = [self standOffPlayerOne:self.playerOne playerTwo:self.playerTwo Handler:self.handler];
//            if(winner == 0) {//there was a draw
//                if(self.dodgeWindow > 10) {
//                    //self.countDownWindow -= 30;//decrease count down time period
//                    self.dodgeWindow -= 10;//decrease dodge window
//                }
//            }
//            if((winner==1) || (winner==2)) {
//                self.dodgeWindow = 60;//there was a winner, so reset the dodge window
//            }
//            [self setPlayerData:self.playerOne.playerData ForPlayer:self.playerOne];
//            //[self.playerOne.currentWeapon removeFromParent];//remove weapon that was drawn
//            [self.playerOne addBackWeaponsForShowInScene:self];//used to return "show" weapons back to the player
//            [self.playerTwo addBackWeaponsForShowInScene:self];
//            [self.playerOne addBobbingActionToBody];//used to return "bobbing" action back to the player's body
//            [self.playerTwo addBobbingActionToBody];
//            //[self.playerTwo.currentWeapon removeFromParent];
//            //[self.playerTwo.currentWeapon]
//            self.playerOne.choseDodge = false;//let's the player choose their one dodge for the next round
//            self.dodgeWindowTimer = 0;
//            self.countDownTimer = 0;
//            self.countDown = 0;
//            [self addChild:self.countDownLabel];
//        }
//    }
//    
//}

- (void) playLoop
{
    NSArray* countDownNumbers;
    
    //random gun testing for ai
    int rand = randomNumber();
    switch (rand) {
        case 1:
            [self.playerTwo changeWeaponTo:self.playerTwo.shotgunForShow ForScene:self];
            break;
        case 2:
            [self.playerTwo changeWeaponTo:self.playerTwo.handgunForShow ForScene:self];
            break;
        case 3:
            [self.playerTwo changeWeaponTo:self.playerTwo.sniperForShow ForScene:self];
        default:
            break;
    }
    
    //doing count down animation
    countDownNumbers = [self countDownAction];//do count down animation
    
    SKAction* waitForCountDown = [SKAction waitForDuration:self.countDownWindow];//wait for count down to complete
    [self runAction:waitForCountDown completion:^{
        [self.drawWeaponLabel removeFromParent];
        [self.countDownLabel removeFromParent];//TODO why is this needed?
        //self.dodgeWindowTimer += 1;
        if(!self.canDodgeNow) {//removing actions right before canDodgeNow is set to YES
            for (id number in countDownNumbers) {//removing count down numbers from the scene
                [number removeFromParent];
            }
            [self.playerOne removeWeaponAndBodyActions];//stops player body parts and weapons from still bobbing
            [self.playerOne.currentWeapon removeAllActions];
            [self.playerTwo removeWeaponAndBodyActions];
            [self.playerTwo.currentWeapon removeAllActions];
        }
        self.canDodgeNow = YES;
        if(![self.playerOne.currentWeapon hasActions]) {//animation bringing gun up
            [self.playerOne.currentWeapon animateWeaponDrawWithTimeWindow:self.dodgeWindow*60.0 InScene:self];
            //[drawAnimation reversedAction];
        }
        if(![self.playerTwo.currentWeapon hasActions]) {//animation bringing gun up
            [self.playerTwo.currentWeapon animateWeaponDrawWithTimeWindow:self.dodgeWindow*60.0 InScene:self];
            //[drawAnimation reversedAction];
        }
        
        SKAction* waitForDraw = [SKAction waitForDuration:self.dodgeWindow];//wait for draw animation to Complete
        
        [self runAction:waitForDraw completion:^{//wait for draw animations to complete
            //self.endOfDraw = YES;
            self.canDodgeNow = NO;
            int winner = [self standOffPlayerOne:self.playerOne playerTwo:self.playerTwo Handler:self.handler];
            self.winner = winner;
            if(winner == 0) {//there was a draw
                if(self.dodgeWindow > .17) {
                    //self.countDownWindow -= 30;//decrease count down time period
                    self.dodgeWindow -= .17;//decrease dodge window
                }
                if(self.countDownWindow > 1.0) {
                    //self.countDownWindow -= 30;//decrease count down time period
                    self.countDownWindow -= 0.5;//decrease dodge window
                }
            }
            if((winner==1) || (winner==2)) {
                self.dodgeWindow = 1;//there was a winner, so reset the dodge window
            }
            [self setPlayerData:self.playerOne.playerData ForPlayer:self.playerOne];
            //[self.playerOne.currentWeapon removeFromParent];//remove weapon that was drawn
            //remove labels for playerOne*****Testing
            [self removeLabelsForPlayer:self.playerOne];
            [self.playerOne addBackWeaponsForShowInScene:self];//used to return "show" weapons back to the player
            [self.playerTwo addBackWeaponsForShowInScene:self];
            [self.playerOne addBobbingActionToBody];//used to return "bobbing" action back to the player's body
            [self.playerTwo addBobbingActionToBody];
            //[self.playerTwo.currentWeapon removeFromParent];
            //[self.playerTwo.currentWeapon]
            self.playerOne.choseDodge = false;//let's the player choose their one dodge for the next round
            self.dodgeWindowTimer = 0;
            self.countDownTimer = 0;
            self.countDown = 0;
            self.countDownLabel.text = self.currentWinnerStatus;//show winner
            [self addChild:self.countDownLabel];
        }];
    }];
    
}

-(void) drawLoop
{
    [self playLoop];
    SKAction* waitForPlayLoop = [SKAction waitForDuration:4+self.dodgeWindow+0.5];
    [self runAction:waitForPlayLoop completion:^{
        if(self.winner == 0) {
            //[self removeAllChildren];
            [self removeAllActions];
            [self drawLoop];
        }
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //[self playLoop];
}

//used for testing the updating of playerData
//int playerAttributeValues[] = {_playerTwo.exp,_playerTwo.level,_playerTwo.wins,_playerTwo.losses,_playerTwo.draws,_playerTwo.handgunUses,
//    _playerTwo.handgunDodgeUses,_playerTwo.shotgunUses,_playerTwo.shotgunDodgeUses,_playerTwo.sniperUses,_playerTwo.sniperDodgeUses,_playerTwo.sniperDodges,_playerTwo.shotgunDodges,
//    _playerTwo.handgunDodges,_playerTwo.sniperKills,_playerTwo.shotgunKills,_playerTwo.handgunKills};
//NSString* playerAttributeKeys[] = {@"playerExp",@"playerLevel",@"playerWins",@"playerLosses",@"playerDraws",@"playerHandgunUses",@"playerHandgunDodgeUses",@"playerShotgunUses",@"playerShotgunDodgeUses",@"playerSniperUses",@"playerSniperDodgeUses",@"playerSniperDodges",@"playerShotgunDodges",@"playerHandgunDodges",@"playerSniperKills",@"playerShotgunKills",@"playerHandgunKills"};
//int length = (sizeof(playerAttributeValues) / sizeof(int));
//for(int i=0; i<length; i++) {
//    NSLog(@"%@: %d", playerAttributeKeys[i], playerAttributeValues[i]);
//}


//        int playerAttributeValues[] = {playerOne.exp,playerOne.level,playerOne.wins,playerOne.losses,playerOne.draws,playerOne.handgunUses,
//            playerOne.handgunDodgeUses,playerOne.shotgunUses,playerOne.shotgunDodgeUses,playerOne.sniperUses,playerOne.sniperDodgeUses,playerOne.sniperDodges,playerOne.shotgunDodges,
//            playerOne.handgunDodges,playerOne.sniperKills,playerOne.shotgunKills,playerOne.handgunKills};
//        NSString* playerAttributeKeys[] = {@"playerExp",@"playerLevel",@"playerWins",@"playerLosses",@"playerDraws",@"playerHandgunUses",@"playerHandgunDodgeUses",@"playerShotgunUses",@"playerShotgunDodgeUses",@"playerSniperUses",@"playerSniperDodgeUses",@"playerSniperDodges",@"playerShotgunDodges",@"playerHandgunDodges",@"playerSniperKills",@"playerShotgunKills",@"playerHandgunKills"};
//        int length = (sizeof(playerAttributeValues) / sizeof(int));
//        for(int i=0; i<length; i++) {
//            NSLog(@"%@: %d", playerAttributeKeys[i], playerAttributeValues[i]);
//        }

@end
