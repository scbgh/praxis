@import Foundation;

@interface PXKeywordElement : NSObject

- (instancetype)initWithKeyword:(NSString *)keyword key:(NSString *)key;
+ (instancetype)elementWithKeyword:(NSString *)keyword key:(NSString *)key;

@property (nonatomic, strong, readonly) NSString *keyword;
@property (nonatomic, strong) NSString *key;

@end