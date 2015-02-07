@import Foundation;

#import "PXExpression.h"

@class PXFunction;

@interface PXValue : NSObject <NSCopying>

- (instancetype)initWithStringValue:(NSString *)stringValue;
- (instancetype)initWithNumberValue:(NSNumber *)numberValue ofType:(PXExpressionType)type;
- (instancetype)initWithFunction:(PXFunction *)functionValue;

- (int)intValue;
- (double)doubleValue;
- (BOOL)boolValue;
- (NSNumber *)numberValue;
- (NSString *)stringValue;
- (PXFunction *)functionValue;

+ (instancetype)valueWithNumber:(NSNumber *)numberValue ofType:(PXExpressionType)type;
+ (instancetype)valueWithInt:(int)value;
+ (instancetype)valueWithDouble:(double)value;
+ (instancetype)valueWithBool:(BOOL)value;
+ (instancetype)unitValue;
+ (instancetype)valueWithString:(NSString *)stringValue;
+ (instancetype)valueWithFunction:(PXFunction *)functionValue;

@property(readonly, nonatomic) PXExpressionType type;

@end
