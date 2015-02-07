#import "PXHoleView.h"
#import "PXHole.h"
#import "PXVisuals.h"
#import "PXExpressionView.h"
#import "PXExpression.h"

@implementation PXHoleView {
  PXHole *_hole;
}

@synthesize hole = _hole;

- (CGSize)intrinsicContentSize {
  if (self.hole.expression == nil) {
    return CGSizeMake(kEditorHoleWidth, kEditorLineHeight);
  }
  return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

- (void)setHole:(PXHole *)hole {
  if (_hole != nil) {
    [_hole removeObserver:self forKeyPath:@"expression"];
  }
  _hole = hole;
  [_hole addObserver:self forKeyPath:@"expression" options:NSKeyValueObservingOptionNew context:nil];
  [self invalidateViews];
}

- (instancetype)initWithHole:(PXHole *)hole {
  self = [super init];
  if (self) {
    self.hole = hole;
  }

  return self;
}

+ (instancetype)viewWithHole:(PXHole *)hole {
  return [[self alloc] initWithHole:hole];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"expression"]) {
    [self invalidateViews];
  }
}

- (void)invalidateViews {
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  if (self.hole == nil || self.hole.expression == nil) {
    return;
  }

  if ([self.hole.expression respondsToSelector:@selector(createView)]) {
    PXExpressionView *expressionView = [self.hole.expression performSelector:@selector(createView)];
    expressionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:expressionView];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[expressionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(expressionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[expressionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(expressionView)]];

    [self setNeedsDisplay];
  }
}


@end