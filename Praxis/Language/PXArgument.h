@import Foundation;

#import "PXExpressionType.h"

@interface PXArgument : NSObject

- (instancetype)initWithName:(NSString *)name type:(PXExpressionType)type;
+ (instancetype)argumentWithName:(NSString *)name type:(PXExpressionType)type;

@property (nonatomic, strong) NSString *name;
@property (nonatomic) PXExpressionType type;

@end