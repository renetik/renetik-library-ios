//
// Created by Rene Dohan on 17/07/18.
//

#import "UIView+CSDimension.h"
#import "UIView+CSPosition.h"
#import "UIView+CSAutoResizing.h"
#import "UIView+CSExtension.h"
#import "UIView+CSLayoutGetters.h"
#import "CSLang.h"

@implementation UIView (CSDimension)


- (instancetype)size:(CGSize)size {
    self.size = size;
    return self;
}

- (instancetype)setSize:(CGSize)size {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    return self;
}

- (instancetype)width:(CGFloat)width height:(CGFloat)height {
    [self size:CGSizeMake(width, height)];
    return self;
}

- (void)setWidth:(CGFloat)value {
    CGRect frame = self.frame;
    frame.size.width = value;
    self.frame = frame;
}

- (instancetype)width:(CGFloat)value {
    self.width = value;
    return self;
}

- (void)setHeight:(CGFloat)value {
    CGRect frame = self.frame;
    frame.size.height = value;
    self.frame = frame;
}

- (instancetype)height:(CGFloat)value {
    self.height = value;
    return self;
}

- (instancetype)addWidth:(CGFloat)value {
    self.width += value;
    return self;
}

- (instancetype)addHeight:(CGFloat)value {
    self.height += value;
    return self;
}

- (instancetype)sizeFit {
    [self sizeToFit];
    return self;
}

- (instancetype)sizeFitHeight {
    CGSize newSize = [self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
    return [self size:CGSizeMake(fmaxf(newSize.width, self.width), newSize.height)];
}

- (instancetype)fitSubviews {
    return [self size:self.calculateSizeFromSubviews];
}

- (instancetype)contentMarging:(CGFloat)padding {
    [self.content left:padding top:padding];
    [[self addWidth:padding * 2] addHeight:padding * 2];
    return self;
}

- (instancetype)contentMargingVertical:(CGFloat)padding {
    [self.content top:padding];
    [self addHeight:padding * 2];
    return self;
}

- (instancetype)contentMargingHorizontal:(CGFloat)padding {
    [self.content left:padding];
    [self addWidth:padding * 2];
    return self;
}

- (instancetype)padding:(CGFloat)padding {
    if (self.isFixedLeft) [self addRight:padding]; else [self addLeft:-padding];
    if (self.isFixedTop) [self addBottom:padding]; else [self addTop:-padding];
    if (self.isFixedRight) [self addLeft:-padding]; else [self addRight:padding];
    if (self.isFixedBottom) [self addTop:-padding]; else [self addBottom:padding];
    return self;
}

- (instancetype)addLeft:(int)value {
    self.left += value;
    self.width += value;
    return self;
}

- (instancetype)addTop:(int)value {
    self.top += value;
    self.height += value;
    return self;
}

- (instancetype)addRight:(int)value {
    self.width += value;
    return self;
}

- (instancetype)addBottom:(int)value {
    self.height += value;
    return self;
}
@end