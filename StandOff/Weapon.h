//
//  Weapon.h
//  StandOff
//
//  Created by Thomas Malitz on 7/25/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIkit.h>

@interface Weapon : SKSpriteNode

///@brief the weapon's type (Handgun, Shotgun, or Sniper)
@property (nonatomic) NSString* type;
///@brief the weapon's annimation (not used yet)
@property (nonatomic) SKAction* animation;

/*!
 * @brief creates a weapon with a certain type
 * @param type the type of weapon (this is the image resource for the weapon)
 * @return a weapon object of that type
 */
+ (instancetype)weaponWithType:(NSString*) type InScene:(SKScene*) scene;
/*!
 * @brief animates a weapon's draw
 * @param timeWindow the time period for which the draw animation should last
 * @return nothing
 */
- (void)animateWeaponDrawWithTimeWindow:(float)timeWindow InScene:(SKScene*) scene;

- (void)orientWeaponInScene:(SKScene*) scene;

@end