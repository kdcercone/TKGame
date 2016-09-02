//
//  Player.h
//  StandOff
//
//  Created by Thomas Malitz on 7/25/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIkit.h>
#import "Weapon.h"
#import "Dodge.h"

@interface Player : SKSpriteNode

@property (nonatomic) SKSpriteNode* body;
@property (nonatomic) SKSpriteNode* hands;
@property (nonatomic) SKSpriteNode* feet;
@property (nonatomic) SKSpriteNode* nose;
@property (nonatomic) SKSpriteNode* eyes;
@property (nonatomic) SKSpriteNode* mouth;
@property (nonatomic) Weapon* handgunForShow;
@property (nonatomic) Weapon* shotgunForShow;
@property (nonatomic) Weapon* sniperForShow;
///@brief the player's current weapon
@property (nonatomic) Weapon* currentWeapon;
///@brief the player's current dodge
@property (nonatomic) Dodge* currentDodge;
///@brief the player's name
@property (nonatomic) NSString* playerName;
///@brief a labelNode for the player's weapon
@property (nonatomic) SKLabelNode* weaponLabel;
///@brief a labelNode for the player's dodge
@property (nonatomic) SKLabelNode* dodgeLabel;
///@brief is the player dodging
@property (nonatomic) BOOL dodging;
///@brief is the player attacking
@property (nonatomic) BOOL attacking;
///@brief has the player chosen a dodge for this round
@property (nonatomic) BOOL choseDodge;
///@brief the player's experience points
@property (nonatomic) int exp;
///@brief the player's level
@property (nonatomic) int level;
///@brief the player's win count (kills)
@property (nonatomic) int wins;
///@brief the player's loss count (deaths)
@property (nonatomic) int losses;
///@brief the player's draw count (dodges and draws)
@property (nonatomic) int draws;
///@brief the player's handgun use count
@property (nonatomic) int handgunUses;
///@brief the player's shotgun use count
@property (nonatomic) int shotgunUses;
///@brief the player's sniper use count
@property (nonatomic) int sniperUses;
///@brief the player's handgun kill count
@property (nonatomic) int handgunKills;
///@brief the player's shotgun kill count
@property (nonatomic) int shotgunKills;
///@brief the player's sniper kill count
@property (nonatomic) int sniperKills;
///@brief the player's handgun dodge uses
@property (nonatomic) int handgunDodgeUses;
///@brief the player's shotgun dodge uses
@property (nonatomic) int shotgunDodgeUses;
///@brief the player's sniper dodge uses
@property (nonatomic) int sniperDodgeUses;
///@brief the player's successful handgun dodges
@property (nonatomic) int handgunDodges;
///@brief the player's successful shotgun dodges
@property (nonatomic) int shotgunDodges;
///@brief the player's successful sniper dodges
@property (nonatomic) int sniperDodges;
///@brief the player's data (wins, losses, exp, level, etc.)
@property (nonatomic) NSUserDefaults* playerData;
//@property (nonatomic) NSMutableArray* brickObjects;



/*!
 * @brief creates player sprite node with a starting weapon and name at a position
 * @param startingWeapon the weapon the player will spawn with
 * @param name the name for this instanciated character
 * @param position the starting position for the created player
 * @return a player at the given position with the given name and starting weapon
 */
+ (instancetype)playerWithStartingWeapon:(Weapon*) startingWeapon PlayerName:(NSString *)name Position:(CGPoint) position InScene:(SKScene*) scene;

- (void)addBackWeaponsForShowInScene:(SKScene*) scene;

- (void) addCharacterInScene:(SKScene*) scene;
/*!
 * @brief changes the player's weapon to the given weapon in the given scene
 * @param toWeapon the weapon the player's currentWeapon will be changed to
 * @param scene the current scene the player is in
 * @return nothing
 */
- (void)changeWeaponTo:(Weapon *)toWeapon ForScene:(SKScene*) scene;

- (void)placeWeapon:(Weapon *)weapon ForScene:(SKScene*) scene;
/*!
 * @brief changes the player's dodge to the given dodge in the given scene
 * @param dodge the dodge the player's currentDodge will be changed to
 * @return nothing
 */
- (void)changeDodgeTo:(Dodge*) dodge;
/*!
 * @brief increments a win/loss/draw property using setters(i.e. setWins)
 * @param type the type of stat (WIN, LOSS, or DRAW)
 * @return nothing
 */
- (void)incrementWLDStat:(NSString*) type;
/*!
 * @brief increments a weapontype property using setters(i.e. setHandgunUses, etc.)
 * @param weaponType the type of weapon (Handgun, Shotgun, or Sniper)
 * @param type the type of stat (USES, DODGE_USES, DODGES, or KILLS)
 * @return nothing
 */
- (void)incrementWeaponTypeStat:(NSString*) weaponType Type:(NSString*) type;
/*!
 * @brief gets the playerData
 * @param playerData the player's NSUserDefault data
 * @return nothing
 */
- (void)getPlayerData:(NSUserDefaults *)playerData;
///@brief returns the KD of the player
- (double)getKD;
///@brief used by the player class to get best or worst weapon or dodge
- (NSString*)getBestOrWorstWeaponOrDodge:(NSString*) worstOrBest PropOne:(int) propOne PropTwo:(int) propTwo PropThree:(int) propThree;
///@brief returns the player's best weapon (most kills)
- (NSString*)getBestWeapon;
///@brief returns the player's worst weapon (least kills)
- (NSString*)getWorstWeapon;
///@brief returns the player's best dodge (most dodges)
- (NSString*)getBestDodge;
///@brief returns the player's worst dodge (least dodges)
- (NSString*)getWorstDodge;
///@brief returns the weapon the player has used the most
- (NSString*)getFavoriteWeapon;
///@brief returns the dodge the player has used the most
- (NSString*)getFavoriteDodge;
///@brief returns the total dodges the player has performed
- (int)getTotalDodges;
///@brief returns the number of true draws the player has had (same weapon draw)
- (int)getTrueDraws;
///@brief returns the accuracy percentage of the player's dodging(success/total)
- (float)getDodgeAccuracyPercentage;
///@brief returns the accuracy percentage of the player's weapon usage (kills/shots)
- (float)getWeaponAccuracyPercentage;
-(void)removeWeaponAndBodyActions;
-(void)addBobbingActionToBody;




@end