//
//  Weapon.m
//  StandOff
//
//  Created by Thomas Malitz on 7/25/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

//

#import "Weapon.h"

@interface Weapon()

@end

@implementation Weapon


+ (instancetype)weaponWithType:(NSString*) type InScene:(SKScene*) scene
{
    
    //Bar* bar = [Bar spriteNodeWithImageNamed:@"blueBar"];
    Weapon* weapon = [Weapon spriteNodeWithImageNamed:type];
    if([type isEqualToString:@"handgun.png"]) {
        weapon.type = @"Handgun";
    }
    if([type isEqualToString:@"shotgun.png"]) {
        weapon.type = @"Shotgun";
    }
    if([type isEqualToString:@"sniper.png"]) {
        weapon.type = @"Sniper";
    }
    weapon.xScale = .5;
    weapon.yScale = .5;
    if([weapon.type isEqualToString:@"Handgun"]) {
        weapon.zPosition = 1;
    }
    if([weapon.type isEqualToString:@"Shotgun"]) {
        weapon.zPosition = -1;
    }
    if([weapon.type isEqualToString:@"Sniper"]) {
        weapon.zPosition = -1;
    }
    weapon.zRotation = -M_PI_2;
    SKAction* changeColor = [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:0.5 duration:0];
    [weapon runAction:changeColor];
    weapon.userInteractionEnabled = false;
    return weapon;
    
}


- (void)animateWeaponDrawWithTimeWindow:(float)timeWindow InScene:(SKScene*) scene
{
    SKAction* rotateGun = [SKAction rotateToAngle:0 duration:(timeWindow/60.0)];
    SKAction* moveForward;
    self.zPosition = 1;//bring in front of player
    if([self.type isEqualToString:@"Handgun"]) {
        if(self.position.x < scene.frame.size.width/2) {
            moveForward = [SKAction moveByX:90 y:25 duration:(timeWindow/60.0)];
        }
        if(self.position.x > scene.frame.size.width/2) {
            moveForward = [SKAction moveByX:-90 y:25 duration:(timeWindow/60.0)];
        }
        SKAction* moveForwardAndRotate = [SKAction group:@[rotateGun, moveForward]];
        [self runAction:moveForwardAndRotate];
    }
    if([self.type isEqualToString:@"Shotgun"]) {
        if(self.position.x < scene.frame.size.width/2) {
            moveForward = [SKAction moveByX:100 y:-25 duration:(timeWindow/60.0)];
        }
        if(self.position.x > scene.frame.size.width/2) {
            moveForward = [SKAction moveByX:-100 y:-25 duration:(timeWindow/60.0)];
        }
        SKAction* moveForwardAndRotate = [SKAction group:@[rotateGun, moveForward]];
        [self runAction:moveForwardAndRotate];
    }
    if([self.type isEqualToString:@"Sniper"]) {
        if(self.position.x < scene.frame.size.width/2) {
            moveForward = [SKAction moveByX:100 y:-25 duration:(timeWindow/60.0)];
        }
        if(self.position.x > scene.frame.size.width/2) {
            moveForward = [SKAction moveByX:-100 y:-25 duration:(timeWindow/60.0)];
        }
        SKAction* moveForwardAndRotate = [SKAction group:@[rotateGun, moveForward]];
        [self runAction:moveForwardAndRotate];
    }
}

- (void)orientWeaponInScene:(SKScene*) scene
{
    if(self.position.x > scene.frame.size.width/2) {
        self.xScale = self.xScale * -1;
        self.zPosition = M_PI_2;
    }
}

@end