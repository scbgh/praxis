@import Foundation;
@class PXExpression;

#import "PXFailureType.h"

@interface PXFailureInfo : NSObject

- (instancetype)initWithExpression:(PXExpression *)failedExpression type:(PXFailureType)failureType;
+ (instancetype)infoWithExpression:(PXExpression *)failedExpression type:(PXFailureType)failureType;

@property(nonatomic, strong) PXExpression *failedExpression;
@property(nonatomic) PXFailureType failureType;

@end