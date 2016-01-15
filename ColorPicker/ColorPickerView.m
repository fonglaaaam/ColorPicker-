//
//  ColorPickerView.m
//  ColorPicker
//
//  Created by midea on 16/1/14.
//  Copyright (c) 2016年 midea. All rights reserved.
//

#import "ColorPickerView.h"

@interface ColorPickerView ()

@property (nonatomic, assign) ZWColorPickerStyle style;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) id<ZWColorPickerDelegate> __nonnull delegate;
@property (nonatomic, copy) PickFinishedBlock __nonnull block;
@property (nonatomic, strong) UIImageView *indicator;

@end

@implementation ColorPickerView

- (void)setPickerStyle:(ZWColorPickerStyle)style andDelegate:(id<ZWColorPickerDelegate> __nonnull)delegate {
    [self setPickerStyle:style];
    self.delegate = delegate;
}

- (void)setPickerStyle:(ZWColorPickerStyle)style andBlock:(PickFinishedBlock __nonnull)block {
    [self setPickerStyle:style];
    self.block = block;
}

- (void)setPickerInnerRadius:(CGFloat)innerRadius {
    CGFloat min = MIN(self.frame.size.width, self.frame.size.height);
    assert(innerRadius < min / 2);
    if (innerRadius < min / 2) {
        self.innerRadius = innerRadius;
    } else {
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouchEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouchEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouchEvent:event];
}

#pragma mark - Private methods

- (void)handleTouchEvent:(UIEvent *)event {
    for (UITouch *touch in event.allTouches) {
        CGPoint point = [self usefulPoint:[touch locationInView:self]];
        UIColor *color = [self colorAtLocation:point];
        if ([self.delegate respondsToSelector:@selector(colorPickerDidSelectColor:)]) {
            [self.delegate performSelector:@selector(colorPickerDidSelectColor:) withObject:color];
        } else if (self.block != nil) {
            self.block(color);
        }
    }
}

- (void)setPickerStyle:(ZWColorPickerStyle)style {
    self.style = style;
    [self layoutIfNeeded];
    if (self.image == nil) {
        NSString *imageName = nil;
        switch (style) {
            case ZWColorPickerStylePie:
                imageName = @"colorpicker_pie";
                break;
            case ZWColorPickerStyleRect:
                imageName = @"colorpicker_rect";
                break;
            case ZWColorPickerStyleRing:
                imageName = @"colorpicker_ring";
            default:
                break;
        }
        UIImage *image = [UIImage imageNamed:imageName];
        //将image缩放至和view一样大
        self.image = [self scaleImage:image toSize:self.frame.size];
        [self setContentMode:UIViewContentModeScaleAspectFit];
    }
    self.indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color_picker"]];
    self.indicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:self.indicator];
    self.userInteractionEnabled = true;
}

- (CGPoint)usefulPoint:(CGPoint)point {
    CGPoint result;
    switch (self.style) {
        case ZWColorPickerStylePie:
            result = [self pointInPie:point];
            break;
        case ZWColorPickerStyleRect:
            result = [self pointInRect:point];
            break;
        case ZWColorPickerStyleRing:
            result = [self pointInRing:point];
            break;
        default:
            break;
    }
    self.indicator.center = result;
    return result;
}

- (CGPoint)pointInPie:(CGPoint)point {
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height) / 2 - 1;
    //如果超出圆形拾色范围，则在边界移动
    if (pow((center.x - point.x), 2) + pow((center.y - point.y), 2) > pow(radius, 2)) {
        CGFloat distance = sqrt(pow((center.x - point.x), 2) + pow((center.y - point.y), 2));
        CGFloat x = (point.x - center.x) * radius / distance;
        CGFloat y = (point.y - center.y) * radius / distance;
        point = CGPointMake(center.x + x, center.y + y);
    }
    return point;
}

- (CGPoint)pointInRect:(CGPoint)point {
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGSize size = CGSizeMake(self.frame.size.width - 2, self.frame.size.height - 2);
    //如果超出方形拾色范围，则在边界移动
    if (center.x + size.width / 2 < point.x) {
        point.x = center.x + size.width / 2;
    }
    if (center.x - size.width / 2 > point.x) {
        point.x = center.x - size.width / 2;
    }
    if (center.y + size.height / 2 < point.y) {
        point.y = center.y + size.height / 2;
    }
    if (center.y - size.height / 2 > point.y) {
        point.y = center.y - size.height / 2;
    }
    return point;
}

- (CGPoint)pointInRing:(CGPoint)point {
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat innerRadius = self.innerRadius + 1;
    CGFloat outerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2 - 1;
    if (pow(center.x - point.x, 2) + pow(center.y - point.y, 2) < pow(innerRadius, 2)) {
        CGFloat distance = sqrt(pow(center.x - point.x, 2) + pow(center.y - point.y, 2));
        CGFloat x = (point.x - center.x) * innerRadius / distance;
        CGFloat y = (point.y - center.y) * innerRadius / distance;
        point = CGPointMake(center.x + x, center.y + y);
    } else if (pow(center.x - point.x, 2) + pow(center.y - point.y, 2) > pow(outerRadius, 2)) {
        CGFloat distance = sqrt(pow(center.x - point.x, 2) + pow(center.y - point.y, 2));
        CGFloat x = (point.x - center.x) * outerRadius / distance;
        CGFloat y = (point.y - center.y) * outerRadius / distance;
        point = CGPointMake(center.x + x, center.y + y);
    }
    return point;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *  获取指定坐标位置的颜色值
 *
 *  @param point 坐标点
 *
 *  @return 颜色值
 */
- (UIColor *)colorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    CGImageRef inImage = self.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            int alpha =  data[offset];
            int red = data[offset + 1];
            int green = data[offset + 2];
            int blue = data[offset + 3];
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        } @catch (NSException * e) {
            NSLog(@"%@", e.description);
        } @finally {
        }
        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

/**
 *  从图像中获取对应的argb值
 *
 *  @param inImage 指定图像
 *
 *  @return 绘图上下文
 */
- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (int)(pixelsWide * 4);
    bitmapByteCount = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

@end
