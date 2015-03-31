@import Foundation;

#import "PXExpression.h"

@interface PXPrintExpression : PXExpression

- (PXHole *)valueHole;

@property(nonatomic) BOOL newline;

@end