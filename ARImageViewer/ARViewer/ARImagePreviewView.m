//
//  ARImagePreviewView.m
//  ARImageView
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import "ARImagePreviewView.h"

@implementation ARImagePreviewView

+ (void)showPreviewARImage:(UIImage *)image inView:(UIView *)pView {
    
    ARImagePreviewView *imagePreView = [[ARImagePreviewView alloc] initWithFrame:pView.bounds];
    [imagePreView.arImageView setImage:image];
    [pView addSubview:imagePreView];
}

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [effectView setFrame:self.bounds];
        [self addSubview:effectView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, self.bounds.size.width - 20 * 2, self.bounds.size.height - 40 * 2)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        _arImageView = imageView;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreenAction:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}


#pragma mark - Events
- (void)tapScreenAction:(UITapGestureRecognizer *)recognizer {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
