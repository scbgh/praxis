#import "PXKeywordElement.h"
#import "UIColor+PXColor.h"

@implementation PXKeywordElement

- (instancetype)initWithKeyword:(NSString *)keyword key:(NSString *)key {
  self = [super init];
  if (self) {
    _keyword = keyword;
    _key = key;
  }
  return self;
}

+ (instancetype)elementWithKeyword:(NSString *)keyword key:(NSString *)key {
  return [[self alloc] initWithKeyword:keyword key:key];
}


@end