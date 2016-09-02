//
//  GameStateHandler.h
//  StandOff
//
//  Created by Thomas Malitz on 7/25/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import "Player.h"
#import "Weapon.h"

@interface GameStateHandler : SKNode
///@brief the left side player
@property (nonatomic) Player* playerOne;
///@brief the right side player
@property (nonatomic) Player* playerTwo;


/*!
 * @brief creates a handler object for two given players
 * @param playerOne the right side player
 * @param playerTwo the left side player
 * @return the handler for the two players
 */
+ (instancetype)gameStateHandlerWithPlayerOne:(Player*) playerOne PlayerTwo:(Player*) playerTwo;
/*!
 * @brief determine the winner of two weapons
 * @param weaponOne the first weapon
 * @param weaponTwo the second weapon
 * @return a number for the winner (1 for weaponOne, 2 for weaponTwo, 0 for draw)
 */
- (int)determineAttackWinnerForWeaponeOne:(Weapon *)weaponOne WeaponTwo:(Weapon *)weaponTwo;
/*! 
 * @brief determines whether a given dodge is successful for a given weapon
 * @param weapon the weapon compared with the dodge
 * @param dodge the dodge compared with the weapon
 * @return whether the dodge is successful or not
 */
- (BOOL)isDodgeSuccessForWeapon:(Weapon*) weapon Dodge:(Dodge*) dodge;
/*!
 * @brief determines who wins between a draw 
 * @param playerOne
 * @param playerTwo
 * @param a number for the winner (1 for playerOne, 2 for playerTwo, 0 for draw)
 */
- (int)whoWins:(Player*) playerOne PlayerTwo:(Player*) playerTwo;



@end