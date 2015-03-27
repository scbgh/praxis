@import Foundation;

#import "PXExpressionType.h"
#import "PXTask.h"

@class PXExpression;
@class PXExpression;
@class PXCodeEditor;

@protocol UIAlertViewDelegate;
typedef PXExpression *(^PXExpressionGenerator)();

@interface PXInsertTask : PXTask <UIAlertViewDelegate>

@property (nonatomic, copy) PXExpressionGenerator generator;

@end