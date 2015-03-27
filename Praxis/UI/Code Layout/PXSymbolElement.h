@import Foundation;

@interface PXSymbolElement : NSObject

- (instancetype)initWithSymbol:(NSString *)symbol;
+ (instancetype)elementWithSymbol:(NSString *)symbol;

@property (nonatomic, strong) NSString *symbol;

@end