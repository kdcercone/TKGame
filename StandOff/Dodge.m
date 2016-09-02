//
//  Dodge.m
//  StandOff
//
//  Created by Thomas Malitz on 7/26/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import "Dodge.h"

@interface Dodge()


@end



@implementation Dodge

+ (instancetype) dodgeForWeapon:(Weapon*) weapon
{
    Dodge* dodge = [Dodge node];
    dodge.forWeapon = weapon;
    return dodge;
}

@end
