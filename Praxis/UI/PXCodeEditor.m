#import "PXCodeEditor.h"
#import "PXExpression.h"
#import "PXExpressionView.h"
#import "PXVisuals.h"
#import "PXTaskGroup.h"
#import "PXInsertTaskGroup.h"
#import "PXHoleView.h"
#import "PXHole.h"
#import "UIColor+PXColor.h"
#import "PXScopeAnalyzer.h"
#import "PXIdentifierTaskGroup.h"

@implementation PXCodeEditor {
  PXHoleView *_rootHoleView;
  PXInsertTaskGroup *_insertTaskGroup;
  PXIdentifierTaskGroup *_identifierTaskGroup;
  CALayer *_selectionLayer;
  CALayer *_highlightLayer;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }

  return self;
}

- (void)initialize {
  _insertTaskGroup = [PXInsertTaskGroup groupWithTitle:@"Insert Code"];
  _insertTaskGroup.editor = self;
  _identifierTaskGroup = [PXIdentifierTaskGroup groupWithTitle:@"Identifiers"];
  _identifierTaskGroup.editor = self;

  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  [self addGestureRecognizer:recognizer];

  _rootHoleView = [PXHoleView viewWithHole:[PXHole holeWithExpressionType:PXVoidType parentExpression:nil] editor:self];
  _rootHoleView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_rootHoleView];

  NSString *horizontalConstraint = [NSString stringWithFormat:@"H:|-%d-[_rootHoleView]", kEditorPadding];
  NSString *verticalConstraint = [NSString stringWithFormat:@"V:|-%d-[_rootHoleView]", kEditorPadding];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraint options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rootHoleView)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraint options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rootHoleView)]];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
  CGPoint pt = [tap locationInView:self];
  UIView *view = [self hitTest:pt withEvent:nil];

  if ([view isKindOfClass:[PXHoleView class]]) {
    PXHoleView *holeView = (PXHoleView *)view;
    self.selectedHoleView = holeView;
    [self updateOverlays];
  }
}

- (PXHoleView *)rootHoleView {
  return _rootHoleView;
}

- (PXTaskGroup *)identifierTaskGroup {
  return _identifierTaskGroup;
}

- (void)updateOverlays {
  if (_selectionLayer) {
    [_selectionLayer removeFromSuperlayer];
    _selectionLayer = nil;
  }

  if ([self selectedHoleView]) {
    _selectionLayer = [CALayer layer];
    CGRect selectRect = [self convertRect:self.selectedHoleView.frame fromView:self.selectedHoleView.superview];
    _selectionLayer.frame = CGRectInset(selectRect, -2, -2);
    _selectionLayer.borderColor = [UIColor redColor].CGColor;
    _selectionLayer.borderWidth = 1;
    _selectionLayer.backgroundColor = [UIColor selectionColor].CGColor;
    [self.layer addSublayer:_selectionLayer];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self updateOverlays];
}

- (void)setSelectedHoleView:(PXHoleView *)selectedHoleView {
  _selectedHoleView = selectedHoleView;
  _insertTaskGroup.hole = selectedHoleView.hole;
  _identifierTaskGroup.hole = selectedHoleView.hole;
  [self updateOverlays];
  [self.delegate selectedHoleViewChanged];
  NSLog(@"Hole selected: %@", selectedHoleView.hole.expression);
}

- (void)invalidateViews {
  [_rootHoleView invalidateViews];
}

- (void)refresh {
  [_rootHoleView refresh];
}

- (PXTaskGroup *)insertTaskGroup {
  return _insertTaskGroup;
}


@end