//
//  MainMenu.h
//  ColorRoom
//
//  Created by Thomas Malitz on 1/29/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "StatMenu.h"
#import "Button.h"
#import "GameViewController.h"

@interface MainMenu : SKScene

-(id)initWithSize:(CGSize)size;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end
