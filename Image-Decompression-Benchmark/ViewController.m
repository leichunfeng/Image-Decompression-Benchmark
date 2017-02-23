//
//  ViewController.m
//  Image-Decompression-Benchmark
//
//  Created by leichunfeng on 2017/2/22.
//  Copyright © 2017年 leichunfeng. All rights reserved.
//

#import "ViewController.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/SDWebImageDecoder.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface UIImage (Initialization)

@end

@implementation UIImage (Initialization)

+ (UIImage *)imageNamed:(NSString *)name ofType:(NSString *)ext {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"%@", path.lastPathComponent);
    NSLog(@"Init: %.2f ms", (after - before) * 1000);
    
    return image;
}

@end

@interface FLAnimatedImage ()

+ (UIImage *)predrawnImageFromImage:(UIImage *)imageToPredraw;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *names = @[ @"128x96", @"256x192", @"512x384", @"1024x768", @"2048x1536" ];
    NSArray *exts  = @[ @"png", @"jpg" ];
    
    for (NSString *name in names) {
        for (NSString *ext in exts) {
            NSLog(@"--------------------------------------------------------------------------------");
            
            UIImage *image = nil;
            
//            image = [UIImage imageNamed:name ofType:ext];
//            image = [self decompressImageByYYKit:image];
//            [self drawImage:image];
            
//            image = [UIImage imageNamed:name ofType:ext];
//            image = [self decompressImageBySDWebImage:image];
//            [self drawImage:image];
            
            image = [UIImage imageNamed:name ofType:ext];
            image = [self decompressImageByFLAnimatedImage:image];
            [self drawImage:image];
        }
    }
    
    NSLog(@"--------------------------------------------------------------------------------");
}

- (UIImage *)decompressImageByYYKit:(UIImage *)image {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    
    CGImageRef cgImage = YYCGImageCreateDecodedCopy(image.CGImage, YES);
    UIImage *decompressedImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation];
    
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"Decompress by YYKit: %.2f ms", (after - before) * 1000);
    
    return decompressedImage;
}

- (UIImage *)decompressImageBySDWebImage:(UIImage *)image {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    
    UIImage *decompressedImage = [UIImage decodedImageWithImage:image];
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"Decompress by SDWebImage: %.2f ms", (after - before) * 1000);
    
    return decompressedImage;
}

- (UIImage *)decompressImageByFLAnimatedImage:(UIImage *)image {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    
    UIImage *decompressedImage = [FLAnimatedImage predrawnImageFromImage:image];
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"Decompress by FLAnimatedImage: %.2f ms", (after - before) * 1000);
    
    return decompressedImage;
}

- (void)drawImage:(UIImage *)image {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, NO);
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    [image drawAtPoint:CGPointZero];
    
    UIGraphicsEndImageContext();
    
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"Draw: %.2f ms", (after - before) * 1000);
}

@end
