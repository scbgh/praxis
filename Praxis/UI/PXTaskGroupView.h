@import Foundation;
@import UIKit;

#import "PXTaskGroup.h"

@class PXTaskGroup;

@interface PXTaskGroupView : UIView <PXTaskGroupDelegate>

- (instancetype)initWithTaskGroup:(PXTaskGroup *)taskGroup;
+ (instancetype)viewWithTaskGroup:(PXTaskGroup *)taskGroup;


@end