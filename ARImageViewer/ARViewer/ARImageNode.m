//
//  ARImageNode.m
//  ARImageViewer
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import "ARImageNode.h"

@implementation ARImageNode

+ (ARImageNode *)isNodePartOfARObject:(SCNNode *)node {
    
    if ([node isKindOfClass:[ARImageNode class]]) {
        return (ARImageNode *)node;
    }
    
    if (node.parentNode != nil) {
        return [[self class] isNodePartOfARObject:node.parentNode];
    }
    return nil;
}



- (instancetype)initNodeWithGeometry:(nullable SCNGeometry *)geometry {
    
    self = (ARImageNode *)[[super class] nodeWithGeometry:geometry];
    
    if (self) {
        
    }
    return self;
}


@end
