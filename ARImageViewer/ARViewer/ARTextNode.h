//
//  ARTextNode.h
//  ARImageViewer
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface ARTextNode : SCNNode

- (instancetype) initWithText:(NSString *)text;

@property (nonatomic, assign) CGFloat textHeight;

@end
