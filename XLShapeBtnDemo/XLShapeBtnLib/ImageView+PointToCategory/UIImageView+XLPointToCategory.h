//
//  UIImageView+XLPointToCategory.h
//  XLShapeBtn
//
//  Created by 蚁族 on 2018/5/24.
//  Copyright © 2018年 mooyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (XLPointToCategory)

@property (nonatomic, readonly) CGAffineTransform xl_viewToImageTransform;
@property (nonatomic, readonly) CGAffineTransform xl_imageToViewTransform;

@end
