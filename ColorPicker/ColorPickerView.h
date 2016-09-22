//
//  ColorPickerView.h
//  ColorPicker
//
//  Created by fonglaaam on 16/1/14.
//  Copyright (c) 2016年 fonglaaam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZWColorPickerStyle) {
    ZWColorPickerStylePie,                     //圆形
    ZWColorPickerStyleRect,                    //方形
    ZWColorPickerStyleRing                     //环状
};

typedef void (^ PickFinishedBlock)(UIColor * __nullable);

@protocol ZWColorPickerDelegate <NSObject>

@optional
- (void)colorPickerDidSelectColor:(UIColor * __nullable)color;

@end

@interface ColorPickerView: UIImageView

/*
 * 当拾色图片为圆环时，设置圆环内半径
 */
- (void)setPickerInnerRadius:(CGFloat)innerRadius;

/*
 * 设置拾色器外观，delegate和block二选一去实现，如果style为ZWColorPickerStyleRing，应当再设置setPickerInnerRadius:
 */
- (void)setPickerStyle:(ZWColorPickerStyle)style andDelegate:(id<ZWColorPickerDelegate> __nonnull)delegate;

/*
 * 设置拾色器外观，delegate和block二选一去实现，如果style为ZWColorPickerStyleRing，应当再设置setPickerInnerRadius:
 */
- (void)setPickerStyle:(ZWColorPickerStyle)style andBlock:(PickFinishedBlock __nonnull)block;

@end
