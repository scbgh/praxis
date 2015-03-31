#import "PXEditCodeViewController.h"
#import "PXTaskPane.h"
#import "PXCodeEditor.h"
#import "PXTestTaskGroup.h"
#import "PXConstantExpression.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXValue.h"
#import "PXIdentifierExpression.h"
#import "PXHoleView.h"
#import "PXHole.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"

@interface PXEditCodeViewController ()

- (void)step;
- (void)run;
@end

@implementation PXEditCodeViewController {
  UIToolbar *_toolbar;
  PXTaskPane *_taskPane;
  PXCodeEditor *_codeEditor;
  UITextView *_outputTextView;
  UIBarButtonItem *_runButton;
  UIBarButtonItem *_stepButton;

  PXExecutionContext *_context;
  PXContinuation *_continuation;
  BOOL _running;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Edit Source Code";

  // Toolbar
  _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
  _runButton = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStylePlain target:self action:@selector(run)];
  _stepButton = [[UIBarButtonItem alloc] initWithTitle:@"Step" style:UIBarButtonItemStylePlain target:self action:@selector(step)];
  _toolbar.items = @[
      _runButton, _stepButton
  ];
  [self.view addSubview:_toolbar];

  // Editor
  _codeEditor = [[PXCodeEditor alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _codeEditor.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_codeEditor];


  // Task pane
  _taskPane = [[PXTaskPane alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _taskPane.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_taskPane];

  // Output pane
  _outputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _outputTextView.translatesAutoresizingMaskIntoConstraints = NO;
  _outputTextView.font = [UIFont systemFontOfSize:12.f];
  _outputTextView.editable = NO;
  _outputTextView.layer.borderWidth = 1;
  _outputTextView.layer.borderColor = [UIColor grayColor].CGColor;
  [self.view addSubview:_outputTextView];

  // Constraints
  id topGuide = self.topLayoutGuide;
  id bottomGuide = self.bottomLayoutGuide;
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_taskPane]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_taskPane)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_codeEditor]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_codeEditor)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_outputTextView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_outputTextView)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide][_toolbar(44)][_taskPane][_codeEditor][_outputTextView(200)][bottomGuide]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar, _taskPane, _codeEditor, _outputTextView, topGuide, bottomGuide)]];

  NSError *error;
  //PXExpression *expr = [PXExpression expressionWithString:@"{ x := int(0); while (true) { y := 7 ; z := \"Hello world\" } }" error:&error];
  PXExpression *expr = [PXExpression expressionWithString:@"" error:&error];
  _codeEditor.rootHoleView.hole.expression = expr;

  _taskPane.taskGroups = @[_codeEditor.insertTaskGroup, _codeEditor.identifierTaskGroup];
}

- (void)initializeContext {
  _context = [[PXExecutionContext alloc] init];
}

- (void)run {
  [self initializeContext];
  PXExecutionResult *result = [_codeEditor.rootHoleView.hole.expression executeFullyInContext:_context];
  if (result.isFailure) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Execution failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
  } else {
    _outputTextView.text = _context.output;
  }
}

- (void)step {

};

- (void)selectedHoleViewChanged {
  [_taskPane refresh];
};

@end
