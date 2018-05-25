//
//  UIImageView+XLPointToCategory.m
//  XLShapeBtn
//
//  Created by 蚁族 on 2018/5/24.
//  Copyright © 2018年 mooyi. All rights reserved.
//

#import "UIImageView+XLPointToCategory.h"

@implementation UIImageView (XLPointToCategory)

-(CGAffineTransform)xl_viewToImageTransform {
    UIViewContentMode contentMode = self.contentMode;
    if (!self.image || self.frame.size.width == 0 || self.frame.size.height == 0 ||
        (contentMode != UIViewContentModeScaleToFill && contentMode != UIViewContentModeScaleAspectFill && contentMode != UIViewContentModeScaleAspectFit)) {
        return CGAffineTransformIdentity;
    }
    CGFloat rWidth = self.image.size.width/self.frame.size.width;
    CGFloat rHeight = self.image.size.height/self.frame.size.height;
    BOOL imageWiderThanView = rWidth > rHeight;
    if (contentMode == UIViewContentModeScaleAspectFit || contentMode == UIViewContentModeScaleAspectFill) {
        CGFloat ratio = ((imageWiderThanView && contentMode == UIViewContentModeScaleAspectFit) || (!imageWiderThanView && contentMode == UIViewContentModeScaleAspectFill)) ? rWidth:rHeight;
        CGFloat xOffset = (self.image.size.width-(self.frame.size.width*ratio))*0.5;
        CGFloat yOffset = (self.image.size.height-(self.frame.size.height*ratio))*0.5;
        return CGAffineTransformConcat(CGAffineTransformMakeScale(ratio, ratio), CGAffineTransformMakeTranslation(xOffset, yOffset));
    } else {
        return CGAffineTransformMakeScale(rWidth, rHeight);
    }
}

-(CGAffineTransform)xl_imageToViewTransform {
    return CGAffineTransformInvert(self.xl_viewToImageTransform);
}

@end
