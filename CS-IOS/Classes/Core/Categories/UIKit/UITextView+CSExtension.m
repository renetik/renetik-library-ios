#import "UITextView+CSExtension.h"
#import "NSString+CSExtension.h"
#import "CSLang.h"

@implementation UITextView (CSExtension)

- (instancetype)setHTMLFromString :(NSString*)string {
    string = [string add:stringf(
                  @"<style>body{font-family: '%@'; font-size:%fpx;}</style>", self.font.fontName, self.font.pointSize)];
    self.attributedText = [NSAttributedString.alloc initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding) }
                                              documentAttributes     :nil error:nil];
    return self;
}

- (instancetype)asLabel {
	self.textContainerInset = UIEdgeInsetsZero;
	self.contentInset = UIEdgeInsetsZero;
	self.editable = false;
	self.scrollEnabled = false;
	self.backgroundColor = UIColor.clearColor;
	self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	self.textContainer.lineFragmentPadding = 0;
	self.layoutManager.usesFontLeading = false;
	return self;
}


@end
