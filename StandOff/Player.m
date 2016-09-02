//
//  Player.m
//  StandOff
//
//  Created by Thomas Malitz on 7/25/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import "Player.h"

@interface Player()


@end

@implementation Player

+ (instancetype)playerWithStartingWeapon:(Weapon*) startingWeapon PlayerName:(NSString *)name Position:(CGPoint) position InScene:(SKScene*) scene;
{
    
    //Bar* bar = [Bar spriteNodeWithImageNamed:@"blueBar"];
    Player* player = [Player spriteNodeWithColor: [UIColor grayColor] size: CGSizeMake(200, 200)];
    player.alpha = .01;
    player.position = position;
    player.playerName = name;
    player.zPosition = 0;
    player.dodging = false;//player never starts out dodging (dodge can only be made duration weapon draw animation)
    player.attacking = true;//player always starts out attacking
    player.choseDodge = false;
    player.playerData = [NSUserDefaults standardUserDefaults];
    
    //weapons for show
    Weapon* HandgunForShow = [Weapon weaponWithType:@"handgun.png" InScene:scene];
    Weapon* ShotgunForShow = [Weapon weaponWithType:@"shotgun.png" InScene:scene];
    Weapon* SniperForShow  = [Weapon weaponWithType:@"sniper.png" InScene:scene];
    player.handgunForShow = HandgunForShow;
    player.shotgunForShow = ShotgunForShow;
    player.sniperForShow = SniperForShow;
    
    if([scene.name isEqualToString:@"GameScene"]) {//only add these weapons for gamescene
        [player placeWeapon:player.handgunForShow ForScene:scene];
        [player placeWeapon:player.shotgunForShow ForScene:scene];
        [player placeWeapon:player.sniperForShow ForScene:scene];
        Dodge* startingDodge = [Dodge dodgeForWeapon:player.handgunForShow];
        [player changeDodgeTo:startingDodge];
        [player changeWeaponTo:player.handgunForShow ForScene:scene];
    }
    
    //[player.playerData setObject:[NSString stringWithString:player.playerName] forKey:@"playerName"];
    //[player.playerData synchronize];
//    [player getPlayerData:player.playerData];
//    Dodge* startingDodge = [Dodge dodgeForWeapon:player.handgunForShow];
//    [player changeDodgeTo:startingDodge];
//    [player changeWeaponTo:player.handgunForShow ForScene:scene];
    return player;
}


-(SKAction*)bobbingAction
{
    SKAction* moveUp = [SKAction moveByX:0 y:10 duration:2.0];
    SKAction* moveDown = [SKAction moveByX:0 y:-10 duration:2.0];
    SKAction* upDown = [SKAction sequence:@[moveDown, moveUp]];
    SKAction* upDownLoop = [SKAction repeatActionForever:upDown];
    return upDownLoop;
}

-(void)addBobbingActionToBody
{
    [self.body runAction:[self bobbingAction]];
    //todo for the rest of the body parts when available
}

-(void)removeWeaponAndBodyActions
{
    [self.handgunForShow removeAllActions];
    [self.shotgunForShow removeAllActions];
    [self.sniperForShow removeAllActions];
    [self.body removeAllActions];
}

- (void)addBackWeaponsForShowInScene:(SKScene*) scene
{
    [self.handgunForShow removeFromParent];
    [self.shotgunForShow removeFromParent];
    [self.sniperForShow removeFromParent];
    Weapon* HandgunForShow = [Weapon weaponWithType:@"handgun.png" InScene:scene];
    Weapon* ShotgunForShow = [Weapon weaponWithType:@"shotgun.png" InScene:scene];
    ShotgunForShow.zPosition = -1;
    Weapon* SniperForShow  = [Weapon weaponWithType:@"sniper.png" InScene:scene];
    SniperForShow.zPosition = -1;
    self.handgunForShow = HandgunForShow;
    self.shotgunForShow = ShotgunForShow;
    self.sniperForShow = SniperForShow;
    [self placeWeapon:self.handgunForShow ForScene:scene];
    [self placeWeapon:self.shotgunForShow ForScene:scene];
    [self placeWeapon:self.sniperForShow ForScene:scene];
}

- (void) addCharacterInScene:(SKScene*) scene
{
    SKSpriteNode* body = [SKSpriteNode spriteNodeWithImageNamed:@"BodyBase@3x.png"];
    body.position = self.position;
    body.zPosition = 0;
    if(self.position.x > (scene.frame.size.width/2)) {//flipped for right side player
        body.xScale = body.xScale * -1;
    }
    self.body = body;
    
    //SKAction* changeColor = [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.5 duration:0];
    //[body runAction:changeColor];
    [scene addChild:body];
    [body runAction:[self bobbingAction]];
}


- (void)getPlayerData:(NSUserDefaults *)playerData
{
    int playerAttributeValues[] = {self.exp,self.level,self.wins,self.losses,self.draws,self.handgunUses,
        self.handgunDodgeUses,self.shotgunUses,self.shotgunDodgeUses,self.sniperUses,self.sniperDodgeUses,self.sniperDodges,self.shotgunDodges,
        self.handgunDodges,self.sniperKills,self.shotgunKills,self.handgunKills};
    
    NSString* playerAttributeKeys[] = {@"playerExp",@"playerLevel",@"playerWins",@"playerLosses",@"playerDraws",@"playerHandgunUses",@"playerHandgunDodgeUses",@"playerShotgunUses",@"playerShotgunDodgeUses",@"playerSniperUses",@"playerSniperDodgeUses",@"playerSniperDodges",@"playerShotgunDodges",@"playerHandgunDodges",@"playerSniperKills",@"playerShotgunKills",@"playerHandgunKills"};

    int length = (sizeof(playerAttributeValues) / sizeof(int));
    for(int i=0; i<length; i++) {
        switch (i) {
            case 0:
                [self setExp:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 1:
                [self setLevel:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 2:
                [self setWins:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 3:
                [self setLosses:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 4:
                [self setDraws:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 5:
                [self setHandgunUses:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 6:
                [self setHandgunDodgeUses:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 7:
                [self setShotgunUses:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 8:
                [self setShotgunDodgeUses:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 9:
                [self setSniperUses:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 10:
                [self setSniperDodgeUses:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 11:
                [self setSniperDodges:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 12:
                [self setShotgunDodges:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 13:
                [self setHandgunDodges:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 14:
                [self setSniperKills:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 15:
                [self setShotgunKills:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            case 16:
                [self setHandgunKills:[[playerData objectForKey:playerAttributeKeys[i]] intValue]];
                break;
            default:
                break;
        }
//        playerAttributeValues[i] = [[playerData objectForKey:playerAttributeKeys[i]] intValue];
//          NSLog(@"%@: %d", playerAttributeKeys[i], playerAttributeValues[i]);
    }
    
    //self.playerName = [playerData objectForKey:@"playerName"];
    
}

- (void)incrementWLDStat:(NSString*) type
{
    if([type isEqualToString:@"WIN"]){
        [self setWins:self.wins+1];
    }
    if([type isEqualToString:@"LOSS"]){
        NSLog(@"LOSS PLUS ONE");
        [self setLosses:self.losses+1];
    }
    if([type isEqualToString:@"DRAW"]){
        [self setDraws:self.draws+1];
    }
}


- (void)incrementWeaponTypeStat:(NSString*) weaponType Type:(NSString*) type
{
    if([type isEqualToString:@"USES"]) {
        if([weaponType isEqualToString:@"Handgun"]) {
            [self setHandgunUses:self.handgunUses+1];
        }
        if([weaponType isEqualToString:@"Shotgun"]) {
            [self setShotgunUses:self.shotgunUses+1];
        }
        if([weaponType isEqualToString:@"Sniper"]) {
            [self setSniperUses:self.sniperUses+1];
        }
    }
    if([type isEqualToString:@"DODGE_USES"]) {
        if([weaponType isEqualToString:@"Handgun"]) {
            [self setHandgunDodgeUses:self.handgunDodgeUses+1];
        }
        if([weaponType isEqualToString:@"Shotgun"]) {
            [self setShotgunDodgeUses:self.shotgunDodgeUses+1];
        }
        if([weaponType isEqualToString:@"Sniper"]) {
            [self setSniperDodgeUses:self.sniperDodgeUses+1];
        }
    }
    if([type isEqualToString:@"DODGES"]) {
        if([weaponType isEqualToString:@"Handgun"]) {
            [self setHandgunDodges:self.handgunDodges+1];
            [self setHandgunDodgeUses:self.handgunDodgeUses+1];
        }
        if([weaponType isEqualToString:@"Shotgun"]) {
            [self setShotgunDodges:self.shotgunDodges+1];
            [self setShotgunDodgeUses:self.shotgunDodgeUses+1];
        }
        if([weaponType isEqualToString:@"Sniper"]) {
            [self setSniperDodges:self.sniperDodges+1];
            [self setSniperDodgeUses:self.sniperDodgeUses+1];
        }
    }
    if([type isEqualToString:@"KILLS"]) {
        if([weaponType isEqualToString:@"Handgun"]) {
            [self setHandgunKills:self.handgunKills+1];
            [self setHandgunUses:self.handgunUses+1];
        }
        if([weaponType isEqualToString:@"Shotgun"]) {
            [self setShotgunKills:self.shotgunKills+1];
            [self setShotgunUses:self.shotgunUses+1];
        }
        if([weaponType isEqualToString:@"Sniper"]) {
            [self setSniperKills:self.sniperKills+1];
            [self setSniperUses:self.sniperUses+1];
        }
    }
}


- (void)changeWeaponTo:(Weapon *)toWeapon ForScene:(SKScene*) scene
{
    
    if (self.dodging) {
        //do nothing; cannot attack after you try to dodge
    }
    else {
        self.currentWeapon = toWeapon;
        self.currentWeapon.name = self.name;
    }
}

- (void)placeWeapon:(Weapon *)weapon ForScene:(SKScene*) scene
{
    if([weapon.type isEqualToString:@"Handgun"]) {
        if(self.position.x < (scene.frame.size.width/2)) {//for player1
            weapon.position = CGPointMake(self.position.x-self.frame.size.width/5, self.position.y-self.frame.size.height/4);
        }
        if(self.position.x > (scene.frame.size.width/2)) {
            weapon.position = CGPointMake(self.position.x+self.frame.size.width/5, self.position.y-self.frame.size.height/4);
            weapon.xScale = weapon.xScale * -1;//player2's weapon needs to face the opposite way
            weapon.zRotation = M_PI_2;
        }
        [scene addChild:weapon];
    }
    if([weapon.type isEqualToString:@"Shotgun"]) {
        if(self.position.x < (scene.frame.size.width/2)) {//for player1
            weapon.position = CGPointMake(self.position.x-self.frame.size.width/4, self.position.y+self.frame.size.height/7);
            weapon.zRotation = M_PI_2;
        }
        if(self.position.x > (scene.frame.size.width/2)) {
            weapon.position = CGPointMake(self.position.x+self.frame.size.width/4, self.position.y+self.frame.size.height/7);
            weapon.xScale = weapon.xScale * -1;//player2's weapon needs to face the opposite way
        }
        [scene addChild:weapon];
    }
    if([weapon.type isEqualToString:@"Sniper"]) {
        if(self.position.x < (scene.frame.size.width/2)) {//for player1
            weapon.position = CGPointMake(self.position.x-self.frame.size.width/4, self.position.y+self.frame.size.height/7);
            weapon.zRotation = M_PI_2;
        }
        if(self.position.x > (scene.frame.size.width/2)) {
            weapon.position = CGPointMake(self.position.x+self.frame.size.width/4, self.position.y+self.frame.size.height/7);
            weapon.xScale = weapon.xScale * -1;//player2's weapon needs to face the opposite way
        }
        [scene addChild:weapon];
    }
    [weapon runAction:[self bobbingAction]];
}


- (void)changeDodgeTo:(Dodge*) dodge
{
//    if (!self.dodging) {
//        //do nothing; cannot dodge when not allowed to dodge; dodging bool is set by swiperHandler in gameScene
//    }
//    else {
        self.currentDodge = dodge;
        SKLabelNode* playerDodgeLabel = [SKLabelNode labelNodeWithFontNamed:@".HelveticaNeueDeskInterface-Regular"];
        playerDodgeLabel.text = self.currentDodge.forWeapon.type;
        playerDodgeLabel.position = self.position;
        playerDodgeLabel.userInteractionEnabled = false;
        self.dodgeLabel = playerDodgeLabel;
    //}
}

- (double)getKD
{
    return self.wins/self.losses;
}

- (int)getTotalDodges
{
    return self.handgunDodges + self.shotgunDodges + self.sniperDodges;
}

- (int)getTrueDraws
{
    return (self.draws - [self getTotalDodges]);
}

- (float)getDodgeAccuracyPercentage
{
    int totalDodges = self.handgunDodgeUses + self.shotgunDodgeUses + self.sniperDodgeUses;
    if(totalDodges < 1) {
        return 0.00;
    }
    else {
        int totalSuccessfulDodges = self.handgunDodges + self.shotgunDodges + self.sniperDodges;
        float totalDodgesF = (float)totalDodges;
        float totalSuccessfulDodgesF = (float)totalSuccessfulDodges;
        return ((totalSuccessfulDodgesF/totalDodgesF) * 100.0);
    }
}

- (float)getWeaponAccuracyPercentage
{
    int totalDraws = self.handgunUses + self.shotgunUses + self.sniperUses;
    if(totalDraws < 1) {
        return 0.00;
    }
    else {
        int totalSuccessfulDraws = self.handgunKills + self.shotgunKills + self.sniperKills;
        float totalDrawsF = (float)totalDraws;
        float totalSuccessfulDrawsF = (float)totalSuccessfulDraws;
        return ((totalSuccessfulDrawsF/totalDrawsF) * 100.0);
    }
}



- (NSString*)getBestOrWorstWeaponOrDodge:(NSString*) worstOrBest PropOne:(int) propOne PropTwo:(int) propTwo PropThree:(int) propThree
{
    if ([worstOrBest isEqualToString:@"BEST"]) {
        int best = (MAX(propOne, (MAX(propTwo, propThree))));
        if(best==propOne) {
            return @"Handgun";
        }
        if(best==propTwo) {
            return @"Sniper";
        }
        if(best==propThree) {
            return @"Shotgun";
        }
        else {
            return @"Handgun";
        }
    }
    else {
        int worst = (MIN(propOne, (MIN(propTwo, propThree))));
        if(worst==propOne) {
            return @"Handgun";
        }
        if(worst==propTwo) {
            return @"Sniper";
        }
        if(worst==propThree) {
            return @"Shotgun";
        }
        else {
            return @"Handgun";
        }
    }
}

- (NSString*)getBestWeapon
{
    NSString* bestWeapon = [self getBestOrWorstWeaponOrDodge:@"BEST" PropOne:self.handgunKills PropTwo:self.sniperKills PropThree:self.shotgunKills];
    return bestWeapon;
}

- (NSString*)getWorstWeapon
{
    NSString* worstWeapon = [self getBestOrWorstWeaponOrDodge:@"WORST" PropOne:self.handgunKills PropTwo:self.sniperKills PropThree:self.shotgunKills];
    return worstWeapon;
}

- (NSString*)getBestDodge
{
    NSString* bestDodge = [self getBestOrWorstWeaponOrDodge:@"BEST" PropOne:self.handgunDodges PropTwo:self.sniperDodges PropThree:self.shotgunDodges];
    return bestDodge;
}

- (NSString*)getWorstDodge
{
    NSString* worstDodge = [self getBestOrWorstWeaponOrDodge:@"WORST" PropOne:self.handgunDodges PropTwo:self.sniperDodges PropThree:self.shotgunDodges];
    return worstDodge;
}

- (NSString*)getFavoriteWeapon
{
    NSString* favoriteWeapon = [self getBestOrWorstWeaponOrDodge:@"BEST" PropOne:self.handgunUses PropTwo:self.sniperUses PropThree:self.shotgunUses];
    return favoriteWeapon;
}

- (NSString*)getFavoriteDodge
{
    NSString* favoriteDodge = [self getBestOrWorstWeaponOrDodge:@"BEST" PropOne:self.handgunDodgeUses PropTwo:self.sniperDodgeUses PropThree:self.shotgunDodgeUses];
    return favoriteDodge;
}






@end
