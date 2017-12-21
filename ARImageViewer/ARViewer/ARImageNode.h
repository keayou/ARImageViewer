//
//  ARImageNode.h
//  ARImageViewer
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface ARImageNode : SCNNode

@property (nonatomic, strong) UIImage *image;


+ (ARImageNode *)isNodePartOfARObject:(SCNNode *)node;

- (instancetype)initNodeWithGeometry:(SCNGeometry *)geometry;


@end
