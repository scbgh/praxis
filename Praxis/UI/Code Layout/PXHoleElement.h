@import Foundation;
@class PXHole;

@interface PXHoleElement : NSObject

- (instancetype)initWithHole:(PXHole *)hole key:(NSString *)key;
+ (instancetype)elementWithHole:(PXHole *)hole key:(NSString *)key;

@property (readonly, nonatomic, strong) PXHole *hole;
@property (readonly, nonatomic, strong) NSString *key;



@end