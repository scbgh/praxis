@import Foundation;
@import UIKit;
@class PXExpression;

@interface PXExpressionView : UIView

- (instancetype)initWithExpression:(PXExpression *)expression;
+ (instancetype)viewWithExpression:(PXExpression *)expression;

- (void)invalidateViews;

@property (nonatomic, strong) PXExpression *expression;

@end