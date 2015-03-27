@import UIKit;

#import "PXInsertAssignmentTask.h"
#import "PXHole.h"
#import "PXHole+PXHoleView.h"
#import "PXCodeEditor.h"
#import "PXAssignmentExpression.h"

@implementation PXInsertAssignmentTask

- (void)execute {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Assign"
                                                      message:@"Please enter a variable name."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    UITextField *text = [alertView textFieldAtIndex:0];
    if (text.text.length > 0) {
      PXAssignmentExpression *expression = [[PXAssignmentExpression alloc] init];
      expression.identifier = text.text;
      self.hole.expression = expression;
      [self.editor refresh];
      self.editor.selectedHoleView = self.hole.holeView;
      [self.editor updateOverlays];
    }
  };
}

@end