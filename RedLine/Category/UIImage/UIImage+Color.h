//
//  UIImage+ColorAtPixel.h
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/10/26.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 *  获取当前点的颜色，直接返回颜色
 *
 *  @param point 当前点
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPoint:(CGPoint)point;

- (UIColor *)colorAtPoint:(CGPoint)point imageRect:(CGRect)imageRect;

/**
 *  获取图片中出现最多的颜色
 *
 *  @return color
 */
- (UIColor *)mostColor;


@end
