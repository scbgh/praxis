#import "PXIdentifierTask.h"
#import "PXExpression.h"
#import "PXIdentifierExpression.h"
#import "PXHole.h"
#import "PXCodeEditor.h"
#import "PXHoleView.h"

@implementation PXIdentifierTask

- (void)execute {
  PXIdentifierExpression *expression = [PXIdentifierExpression expressionWithType:self.type];
  expression.identifier = self.identifier;
  self.hole.expression = expression;
  [self.editor.selectedHoleView layoutIfNeeded];
}

@end