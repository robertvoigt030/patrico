//
//  Token.m
//  patrico
//
//  Created by master on 07.01.15.
//  Copyright 2015 master. All rights reserved.
//

#import "Token.h"


@implementation Token

@synthesize tokenColor,currentFieldNr;

//sets the color depending sprite during initialization
-(id)initWithColor:(TokenColor)theColor
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;

    NSMutableString *theFilename = [[NSMutableString alloc]init];
    [theFilename appendString:@"token_"];
    
    switch(theColor){
        case Blue:
            [theFilename appendString:@"blue"];
            break;
        case Red:
            [theFilename appendString:@"red"];
            break;
        default:
            NSLog(@"unknown token color");
    }
    
    [theFilename appendString:@".png"];
    
    self.spriteFrame = [CCSpriteFrame frameWithImageNamed:theFilename];
    
    tokenColor = theColor;
    NSLog(@"Tell me your tokenColor: %d",tokenColor);
    //done
    return self;
}

@end
