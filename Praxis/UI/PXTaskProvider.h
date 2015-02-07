@import Foundation;

@class PXTaskGroup;
@class PXHole;

@interface PXTaskProvider : NSObject

- (PXTaskGroup *)taskGroupForHole:(PXHole *)hole;

@end