//
//  ARImagePreviewView.h
//  ARImageView
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARImagePreviewView : UIView

@property (nonatomic, strong) UIImageView *arImageView;

+ (void)showPreviewARImage:(UIImage *)image inView:(UIView *)pView;

@end
