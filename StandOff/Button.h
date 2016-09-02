//
//  Button.h
//  StandOff
//
//  Created by Thomas Malitz on 8/16/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIkit.h>

@interface Button : SKSpriteNode

@property (nonatomic) BOOL hover;

+(instancetype)buttonWithImage:(NSString*) image xPos:(CGFloat) xpos yPos:(CGFloat) ypos;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event InScene:(SKScene*) scene;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event InScene:(SKScene*) scene;
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event InScene:(SKScene*) scene;
@end