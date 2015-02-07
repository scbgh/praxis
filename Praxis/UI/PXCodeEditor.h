@import Foundation;
@import UIKit;

@class PXExpression;
@class PXTaskProvider;

@interface PXCodeEditor : UIView

- (void)invalidateViews;

@property (nonatomic, strong) PXExpression *expression;

@end