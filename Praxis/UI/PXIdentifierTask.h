@import Foundation;

#import "PXTask.h"
#import "PXExpressionType.h"

@interface PXIdentifierTask : PXTask

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) PXExpressionType type;

@end