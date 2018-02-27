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
        _imageHeight = 0.5;
        _imageDepth = 2.0;
        _marginAngle = 1.0;
    }
    return self;
    
    
}

@end
