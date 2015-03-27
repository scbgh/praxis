@import Foundation;
@import UIKit;

@interface PXIndentElement : NSObject

@property (readonly) CGFloat indent;

- (instancetype)initWithIndent:(CGFloat)indent;
+ (instancetype)elementWithIndent:(CGFloat)indent;


@end