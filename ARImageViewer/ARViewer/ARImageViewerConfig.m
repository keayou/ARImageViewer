//
//  ARImageViewerConfig.m
//  ARImageViewer
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import "ARImageViewerConfig.h"

@implementation ARImageViewerConfig

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _imageWidth = 0.6;
        _imageHeight = 0.36;
        _imageDepth = 1.2;
        _marginAngle = 1.0;
    }
    return self;
    
    
}

@end
