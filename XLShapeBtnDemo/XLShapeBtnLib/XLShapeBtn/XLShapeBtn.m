//
//  XLShapeBtn.m
//  XLShapeBtn
//
//  Created by 蚁族 on 2018/5/24.
//  Copyright © 2018年 mooyi. All rights reserved.
//

#import "XLShapeBtn.h"
#import "UIImage+XLColorAtPixel.h"
#import "UIImageView+XLPointToCategory.h"

@interface XLShapeBtn ()

@property (nonatomic, assign) CGPoint previousTouchPoint;
@property (nonatomic, assign) BOOL previousTouchHitTestResponse;
@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UIImage *buttonBackground;

- (void)updateImageCacheForCurrentState;
- (void)resetHitTestCache;

@end

@implementation XLShapeBtn

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image {
    point.x = point.x - self.imageView.frame.origin.x;
    point.y = point.y - self.imageView.frame.origin.y;
    CGPoint pt = CGPointApplyAffineTransform(point, self.imageView.xl_viewToImageTransform);
    point = pt;
    
    UIColor *pixelColor = [image xl_colorAtPixel:point];
    CGFloat alpha = 0.0;
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    } else {
        CGColorRef cgPixelColor = [pixelColor CGColor];
        alpha = CGColorGetAlpha(cgPixelColor);
    }
    return alpha >= kAlphaVisibleThreshold;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }
    
    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
        return self.previousTouchHitTestResponse;
    } else {
        self.previousTouchPoint = point;
    }
    
    BOOL response = NO;
    if (self.buttonImage == nil && self.buttonBackground == nil) {
        response = YES;
    } else if (self.buttonImage != nil && self.buttonBackground == nil) {
        response = [self isAlphaVisibleAtPoint:point forImage:self.buttonImage];
    } else if (self.buttonImage == nil && self.buttonBackground != nil) {
        response = [self isAlphaVisibleAtPoint:point forImage:self.buttonBackground];
    } else {
        if ([self isAlphaVisibleAtPoint:point forImage:self.buttonImage]) {
            response = YES;
        } else {
            response = [self isAlphaVisibleAtPoint:point forImage:self.buttonBackground];
        }
    }
    
    self.previousTouchHitTestResponse = response;
    return response;
}

#pragma mark - Accessors
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [super setBackgroundImage:image forState:state];
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateImageCacheForCurrentState];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateImageCacheForCurrentState];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateImageCacheForCurrentState];
}

#pragma mark - Helper methods

- (void)updateImageCacheForCurrentState {
    _buttonBackground = [self currentBackgroundImage];
    _buttonImage = [self currentImage];
}

- (void)resetHitTestCache {
    self.previousTouchPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    self.previousTouchHitTestResponse = NO;
}



@end
