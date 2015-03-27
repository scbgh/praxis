#import <objc/runtime.h>
#import "PXHoleView.h"
#import "PXHole+PXHoleView.h"
#import "PXVisuals.h"
#import "PXExpressionView.h"
#import "PXExpression.h"
#import "PXCodeEditor.h"

@implementation PXHoleView {
  PXExpressionView *_expressionView;
}

- (CGSize)intrinsicContentSize {
  if (self.hole.expression == nil) {
    return CGSizeMake(kEditorHoleWidth, kEditorLineHeight);
  }
  return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

- (void)dealloc {
  if (_hole != nil) {
    [_hole removeObserver:self forKeyPath:@"expression"];
  }
}

- (void)setHole:(PXHole *)hole {
  if (_hole != nil) {
    [_hole removeObserver:self forKeyPath:@"expression"];
    _hole.holeView = nil;
  }
  _hole = hole;
  hole.holeView = self;
  [_hole addObserver:self forKeyPath:@"expression" options:NSKeyValueObservingOptionNew context:nil];
  [self invalidateViews];
}

- (instancetype)initWithHole:(PXHole *)hole editor:(PXCodeEditor *)editor {
  self = [super init];
  if (self) {
    self.editor = editor;
    self.hole = hole;
    hole.holeView = self;
  }

  return self;
}

+ (instancetype)viewWithHole:(PXHole *)hole editor:(PXCodeEditor *)editor {
  return [[self alloc] initWithHole:hole editor:editor];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"expression"]) {
    [self.editor refresh];
  }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView *subview = [_expressionView hitTest:point withEvent:event];
  if (subview && subview == _expressionView) {
    return self;
  }
  return [super hitTest:point withEvent:event];
}

- (void)refresh {
  if (self.hole.expression != self.expressionView.expression) {
    [self invalidateViews];
  } else {
    [self.expressionView refresh];
  }
}

- (void)invalidateViews {
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  if (self.hole == nil) {
    return;
  }

  [self removeConstraints:self.constraints];
  _expressionView = nil;
  if ([self.hole.expression respondsToSelector:@selector(createView)]) {
    _expressionView = [self.hole.expression performSelector:@selector(createView)];
    _expressionView.editor = self.editor;
    _expressionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.layer.borderWidth = 0;
    [self addSubview:_expressionView];
    [_expressionView invalidateViews];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_expressionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_expressionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_expressionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_expressionView)]];
  } else if (!self.hole.expression) {
    UILabel *typeLabel = [[UILabel alloc] init];
    self.layer.borderColor = [UIColor colorWithWhite:.5f alpha:1.f].CGColor;
    self.layer.borderWidth = 1;
    typeLabel.textColor = [UIColor colorWithWhite:.7f alpha:1.f];
    typeLabel.text = PXExpressionTypeString(self.hole.expressionType);
    typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:typeLabel];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[typeLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(typeLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[typeLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(typeLabel)]];
  }

  [self setNeedsUpdateConstraints];
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (PXExpressionView *)expressionView {
  return _expressionView;
}


@end