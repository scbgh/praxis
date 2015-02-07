@import Foundation;

#import "PXExpression.h"
#import "PXValue.h"

@class PXContinuation;

@interface PXExecutionContext : NSObject

- (PXValue *)lookupVariableNamed:(NSString *)name;
- (void)assignVariableNamed:(NSString *)name withValue:(PXValue *)value;
- (PXExecutionContext *)createChildContext;

@property(readonly, nonatomic) int id;
@property(readonly, nonatomic, strong) PXExecutionContext *parentContext;
@property(nonatomic, strong) PXExecutionContext *globalContext;
@property(nonatomic, strong) PXContinuation *currentContinuation;
@property(nonatomic, strong) PXDebugContext *dbg;

@end