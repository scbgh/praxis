@import Foundation;
@class PXExpression;
@class PXContinuation;
@class PXExecutionResult;

@interface PXFunction : NSObject

- (instancetype)initWithArguments:(NSArray *)arguments body:(PXExpression *)bodyExpression;
+ (instancetype)functionWithArguments:(NSArray *)arguments body:(PXExpression *)bodyExpression;

@property(nonatomic, strong) NSArray *arguments;
@property(nonatomic, strong) PXExpression *bodyExpression;

@end