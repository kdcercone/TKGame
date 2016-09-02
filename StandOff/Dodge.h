//
//  Dodge.h
//  StandOff
//
//  Created by Thomas Malitz on 7/26/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIkit.h>
#import "Weapon.h"

@interface Dodge : SKNode

///@brief the weapon the dodge can dodge
@property (nonatomic) Weapon* forWeapon;
///@brief the animation for the dodge
@property (nonatomic) SKAction* animation;

/*! 
 * @brief creates a dodge object for the given weapon
 * @param weapon the weapon for which the returned dodge is able to dodge
 * @return the created dodge for the given weapon
 */
+ (instancetype)dodgeForWeapon:(Weapon*) weapon;


@end
