//
//  GameStateHandler.m
//  StandOff
//
//  Created by Thomas Malitz on 7/25/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import "GameStateHandler.h"


@interface GameStateHandler()


@end

@implementation GameStateHandler

+ (instancetype)gameStateHandlerWithPlayerOne:(Player*) playerOne PlayerTwo:(Player*) playerTwo
{
    GameStateHandler* handler = [GameStateHandler node];
    handler.playerOne = playerOne;
    handler.playerTwo = playerTwo;
    return handler;
}

- (int)determineAttackWinnerForWeaponeOne:(Weapon *)weaponOne WeaponTwo:(Weapon *)weaponTwo
{
    //a return of 1 means player one wins the draw
    //a return of 2 means player two wins the draw
    //a return of 0 means it is a draw
    NSString* weaponOneType = weaponOne.type;
    NSString* weaponTwoType = weaponTwo.type;
    if ([weaponOneType  isEqual: @"Handgun"]) {
        if ([weaponTwoType  isEqual: @"Shotgun"]) {
            return 2;
        }
        if ([weaponTwoType  isEqual: @"Sniper"]) {
            return 1;
        }
        else {
            return 0;
        }
    }
    if ([weaponOneType  isEqual: @"Shotgun"]) {
        if ([weaponTwoType  isEqual: @"Handgun"]) {
            return 1;
        }
        if ([weaponTwoType  isEqual: @"Sniper"]) {
            return 2;
        }
        else {
            return 0;
        }
    }
    if ([weaponOneType  isEqual: @"Sniper"]) {
        if ([weaponTwoType  isEqual: @"Handgun"]) {
            return 2;
        }
        if ([weaponTwoType  isEqual: @"Shotgun"]) {
            return 1;
        }
        else {
            return 0;
        }
    }
    else {
        return 0;
    }
    
}

- (BOOL)isDodgeSuccessForWeapon:(Weapon*) weapon Dodge:(Dodge*) dodge
{
    NSString* dodgeType = dodge.forWeapon.type;
    NSString* weaponType = weapon.type;
    return [weaponType isEqual:dodgeType];
}



- (void)incrementPlayerWLDStat:(NSString*) wldStat PlayerWeaponType:(NSString*) weaponType PlayerStatType:(NSString*) statType ForPlayerOne:(Player*) player
{
    [player incrementWLDStat:wldStat];
    [player incrementWeaponTypeStat:weaponType Type:statType];
}


//return of 1 = playerOne wins
//return of 2 = playerTwo wins
//return of 0 = DRAW
- (int)whoWins:(Player*) playerOne PlayerTwo:(Player*) playerTwo
{
    if(playerOne.dodging && playerTwo.attacking) {
        BOOL playerOneHasDodged = [self isDodgeSuccessForWeapon:playerTwo.currentWeapon Dodge:playerOne.currentDodge];
        if (playerOneHasDodged) {
            NSLog(@"Player One Has Dodged");
            [self incrementPlayerWLDStat:@"DRAW" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"DODGES" ForPlayerOne:playerOne];
            return 0;
        }
        else {//playerOne just got killed
            [self incrementPlayerWLDStat:@"LOSS" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"DODGES_USES" ForPlayerOne:playerOne];
            return 2;
        }
    }
    if(playerOne.attacking && playerTwo.dodging) {
        BOOL playerTwoHasDodged = [self isDodgeSuccessForWeapon:playerOne.currentWeapon Dodge:playerTwo.currentDodge];
        if (playerTwoHasDodged) {
            NSLog(@"Player Two Has Dodged");
            [self incrementPlayerWLDStat:@"DRAW" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"USES" ForPlayerOne:playerOne];
            return 0;
        }
        else {//playerTwo just got killed
            [self incrementPlayerWLDStat:@"WIN" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"KILLS" ForPlayerOne:playerOne];
            return 1;
        }
    }
    if(playerOne.attacking && playerTwo.attacking) { //we got a ball game
        NSLog(@"Someone was killed/or they both drew the same weapon");
        int winner = [self determineAttackWinnerForWeaponeOne:playerOne.currentWeapon WeaponTwo:playerTwo.currentWeapon];
        NSLog(@"WINNER: %d", winner);
        switch (winner) {
            case 0:
                [self incrementPlayerWLDStat:@"DRAW" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"USES" ForPlayerOne:playerOne];
                break;
            case 1:
                [self incrementPlayerWLDStat:@"WIN" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"KILLS" ForPlayerOne:playerOne];
                break;
            case 2:
                [self incrementPlayerWLDStat:@"LOSS" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"USES" ForPlayerOne:playerOne];
            default:
                break;
        }
        return winner;
    }
    else {//both players punked out
        [self incrementPlayerWLDStat:@"DRAW" PlayerWeaponType:playerOne.currentWeapon.type PlayerStatType:@"DODGES_USES" ForPlayerOne:playerOne];
        return 0;
    }
    
}



@end