@import UIKit;
#import "PXConstantExpression.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXValue.h"
#import "PXHole.h"
#import "PXHole+PXHoleView.h"
#import "PXInsertIntegerTask.h"
#import "PXCodeEditor.h"

@implementation PXInsertIntegerTask

- (void)execute {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Integer Constant"
                                                      message:@"Please enter an integer."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    UITextField *text = [alertView textFieldAtIndex:0];
    PXConstantExpression *expression = [PXExpression constantWithValue:[PXValue valueWithInt:[text.text intValue]]];
    self.hole.expression = expression;
    [self.editor refresh];
    self.editor.selectedHoleView = self.hole.holeView;
    [self.editor updateOverlays];
  };
}

@end