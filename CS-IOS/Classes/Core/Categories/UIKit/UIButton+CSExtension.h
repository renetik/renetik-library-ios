//
// Created by inno on 1/28/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

@import UIKit;

@interface UIButton (CSExtension)

- (void)stretchableBackgroundImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;

+ (UIButton *)createWithFrame:(CGRect)rect image:(UIImage *)image contentMode:(UIViewContentMode)mode;

- (void)setTitleColor:(UIColor *)color;

- (instancetype)setText:(NSString *)title;

- (NSString *)text;

- (void)setImage:(UIImage *)image;

- (void)setBackgroundImage:(UIImage *)image;
@end
