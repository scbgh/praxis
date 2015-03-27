@import Foundation;
@import UIKit;@class PXCodeEditor;
@class PXExpressionView;

@interface PXCodeLayoutFactory : NSObject

- (void)addLineWithElements:(NSArray *)elements;
- (void)createLayoutInView:(UIView *)view;

- (instancetype)initWithEditor:(PXCodeEditor *)editor;
+ (instancetype)factoryWithEditor:(PXCodeEditor *)editor;

@property (nonatomic, strong) PXCodeEditor *editor;
@property (nonatomic, readonly) NSDictionary *views;

@end