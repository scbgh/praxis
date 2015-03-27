@import Foundation;
@import UIKit;

#import "PXExpressionType.h"

@interface PXIdentifierElement : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier type:(PXExpressionType)type key:(NSString *)key;
+ (instancetype)elementWithIdentifier:(NSString *)identifier type:(PXExpressionType)type key:(NSString *)key;

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic) PXExpressionType type;
@property (nonatomic, strong, readonly) NSString *key;

@end