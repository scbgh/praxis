@import Foundation;

@class PXExecutionContext;

@interface PXDebugContext : NSObject

- (void)log:(NSString *)message;
- (void)logWithFormat:(NSString *)format, ...;
- (instancetype)initWithContext:(PXExecutionContext *)context;
+ (instancetype)debugContextWithContext:(PXExecutionContext *)context;

@property (nonatomic, strong) PXExecutionContext *context;

@end