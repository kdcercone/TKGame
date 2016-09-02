//
//  Button.m
//  StandOff
//
//  Created by Thomas Malitz on 8/16/16.
//  Copyright © 2016 Thomas Malitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Button.h"


@interface Button()

@end

@implementation Button


+ (instancetype)buttonWithImage:(NSString*) image xPos:(CGFloat) xpos yPos:(CGFloat) ypos
{
    Button* button = [Button spriteNodeWithImageNamed:image];
    button.yScale = 1.2;
    button.xScale = 1.2;
    button.position = CGPointMake(xpos, ypos);
    button.hover = NO;
    return button;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event InScene:(SKScene*) scene
{
    UITouch *t = [touches anyObject];
    CGPoint touchLocation = [t locationInNode:scene];
    NSLog(@"touch on button BEGAN");
    
    if([self containsPoint:touchLocation]) {
        self.hover = YES;
        self.alpha = 0.5;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event InScene:(SKScene*) scene
{
    UITouch *t = [touches anyObject];
    CGPoint touchLocation = [t locationInNode:scene];
    NSLog(@"touch on button MOVED");
//    if(![self containsPoint:touchLocation]) {
//        self.hover = NO;
//        self.alpha = 1.0;
//    }
    
    if(!(CGRectContainsPoint(self.frame, touchLocation))) {
        self.hover = NO;
        self.alpha = 1.0;
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event InScene:(SKScene*) scene
{
    
    UITouch *t = [touches anyObject];
    CGPoint touchLocation = [t locationInNode:scene];
    NSLog(@"touch on button ENDED");
    
    if((self.alpha==0.5) && (![self containsPoint:touchLocation])) {
        self.alpha = 1.0;
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch on button CANCELLED");
    if(self.alpha==0.5) {
        self.alpha = 1.0;
    }
}


@end