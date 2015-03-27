@import UIKit;
#import "PXInsertStringTask.h"
#import "PXConstantExpression.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXValue.h"
#import "PXHole.h"
#import "PXHole+PXHoleView.h"
#import "PXCodeEditor.h"

@implementation PXInsertStringTask

- (void)execute {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"String Constant"
                                                      message:@"Please enter a string."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    UITextField *text = [alertView textFieldAtIndex:0];
      PXConstantExpression *expression = [PXExpression constantWithValue:[PXValue valueWithString:text.text]];
      self.hole.expression = expression;
  };

  [self.editor refresh];
  self.editor.selectedHoleView = self.hole.holeView;
  [self.editor updateOverlays];
}

@end