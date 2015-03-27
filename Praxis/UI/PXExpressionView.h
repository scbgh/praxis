@import Foundation;
@import UIKit;
#import "PXExpression.h"

@class PXCodeEditor;
@class PXHoleView;

@interface PXExpressionView : UIView

- (instancetype)initWithExpression:(PXExpression *)expression;
+ (instancetype)viewWithExpression:(PXExpression *)expression;

- (void)refresh;
- (void)invalidateViews;

@property(nonatomic, weak) PXCodeEditor *editor;
@property(nonatomic, readonly, strong) PXExpression *expression;

@end