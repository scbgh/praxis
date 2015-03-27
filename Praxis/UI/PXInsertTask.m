#import "PXInsertTask.h"
#import "PXHole.h"
#import "PXCodeEditor.h"
#import "PXHoleView.h"
#import "PXHole+PXHoleView.h"
#import "PXExpression.h"

@implementation PXInsertTask

- (void)execute {
  PXExpression *expression;
  expression = self.generator();
  self.hole.expression = expression;
  [self.editor refresh];

  self.editor.selectedHoleView = self.hole.holeView;
  [self.editor updateOverlays];
}


@end