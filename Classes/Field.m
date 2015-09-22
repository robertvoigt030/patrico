//
//  Field.m
//  patrico
//
//  Created by master on 07.01.15.
//  Copyright 2015 master. All rights reserved.
//

#import "Field.h"


@implementation Field

@synthesize boardIndex;

//sets the corresponding sprite to the field
-(void)setFieldTypeTo:(FieldType)theType
{
    NSMutableString *theFilename = [[NSMutableString alloc]init];
    
    switch (theType){
        case Normal:
            [theFilename appendString:@"normal"];
            break;
        case Jail:
            [theFilename appendString:@"special_jail"];
            break;
        case Hole:
            [theFilename appendString:@"special_hole"];
            break;
        case Yellow:
            [theFilename appendString:@"special_yellow"];
            break;
        case Green:
            [theFilename appendString:@"special_green"];
            break;
        case Start:
            [theFilename appendString:@"start"];
            break;
        case Finish:
            [theFilename appendString:@"finish"];
            break;
        default:
            NSLog(@"%ld is an unknown FieldType",(long)theType);
    }
    
    [theFilename appendString: @".png"];
    
    self.fieldType = theType;
    
    self.spriteFrame = [CCSpriteFrame frameWithImageNamed:theFilename];
}

@end
