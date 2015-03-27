#import "PXCodeLayoutFactory.h"
#import "PXIndentElement.h"
#import "PXKeywordElement.h"
#import "UIColor+PXColor.h"
#import "PXHoleElement.h"
#import "PXHoleView.h"
#import "PXCodeEditor.h"
#import "PXVisuals.h"
#import "PXIdentifierElement.h"
#import "PXSymbolElement.h"
#import "PXExpressionView.h"
#import "PXLabel.h"
#import "PXButtonElement.h"
#import "PXBlockButton.h"

@implementation PXCodeLayoutFactory {
  NSMutableArray *_lines;
  NSMutableDictionary *_views;
}

- (instancetype)initWithEditor:(PXCodeEditor *)editor {
  self = [super init];
  if (self) {
    _lines = [NSMutableArray array];
    _views = [NSMutableDictionary dictionary];
    self.editor = editor;
  }

  return self;
}

+ (instancetype)factoryWithEditor:(PXCodeEditor *)editor {
  return [[self alloc] initWithEditor:editor];
}

- (NSDictionary *)views {
  return _views;
}

- (void)addLineWithElements:(NSArray *)elements {
  [_lines addObject:elements];
}

- (void)createLayoutInView:(UIView *)view {
  int ctr = 0;
  NSMutableArray *lineIds = [NSMutableArray array];
  NSMutableArray *lineConstraints = [NSMutableArray array];
  NSMutableDictionary *lineMapping = [NSMutableDictionary dictionary];

  for (NSArray *line in _lines) {
    UIView *lineView = [[UIView alloc] init];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;

    NSString *lineId = [NSString stringWithFormat:@"line%d", ctr++];
    [lineConstraints addObject:[NSString stringWithFormat:@">=%@", lineId]];
    [lineIds addObject:[NSString stringWithFormat:@"[%@]", lineId]];
    lineMapping[lineId] = lineView;

    [view addSubview:lineView];

    NSMutableArray *lineElements = [NSMutableArray array];
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    for (NSObject *elem in line) {
      if ([elem isKindOfClass:[PXIndentElement class]]) {
        UIView *indent = [[UIView alloc] init];
        NSString *indentId = [NSString stringWithFormat:@"indent%d", ctr++];
        indent.translatesAutoresizingMaskIntoConstraints = NO;
        [lineView addSubview:indent];
        [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[indent(==indentSize)]" options:0 metrics:@{@"indentSize" : @(kEditorIndent)} views:NSDictionaryOfVariableBindings(indent)]];
        [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[indent]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(indent)]];
        mapping[indentId] = indent;
        [lineElements addObject:[NSString stringWithFormat:@"[%@]", indentId]];
      } else if ([elem isKindOfClass:[PXIdentifierElement class]]) {
        PXIdentifierElement *idElem = (PXIdentifierElement *) elem;
        PXLabel *label = [[PXLabel alloc] init];
        NSString *labelId = [NSString stringWithFormat:@"label%d", ctr++];
        label.textColor = [UIColor colorWithExpressionType:((PXIdentifierElement *) elem).type];
        label.text = idElem.identifier;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.associatedView = view;
        label.userInteractionEnabled = YES;
        _views[idElem.key] = label;
        [lineView addSubview:label];
        [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [lineElements addObject:[NSString stringWithFormat:@"[%@]", labelId]];
        mapping[labelId] = label;
      } else if ([elem isKindOfClass:[PXSymbolElement class]]) {
        PXLabel *label = [[PXLabel alloc] init];
        PXSymbolElement *symElem = (PXSymbolElement *) elem;
        NSString *labelId = [NSString stringWithFormat:@"label%d", ctr++];
        label.text = symElem.symbol;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.associatedView = view;
        label.userInteractionEnabled = YES;
        [lineView addSubview:label];
        [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [lineElements addObject:[NSString stringWithFormat:@"[%@]", labelId]];
        mapping[labelId] = label;
      } else if ([elem isKindOfClass:[PXKeywordElement class]]) {
        PXLabel *label = [[PXLabel alloc] init];
        PXKeywordElement *kwElem = (PXKeywordElement *) elem;
        NSString *labelId = [NSString stringWithFormat:@"label%d", ctr++];
        label.textColor = [UIColor keywordColor];
        label.text = kwElem.keyword;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.associatedView = view;
        label.userInteractionEnabled = YES;
        _views[kwElem.key] = label;
        [lineView addSubview:label];
        [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [lineElements addObject:[NSString stringWithFormat:@"[%@]", labelId]];
        mapping[labelId] = label;
      } else if ([elem isKindOfClass:[PXHoleElement class]]) {
        PXHoleElement *holeElem = (PXHoleElement *) elem;
        PXHoleView *holeView = [PXHoleView viewWithHole:holeElem.hole editor:self.editor];
        NSString *holeId = [NSString stringWithFormat:@"hole%d", ctr++];
        holeView.translatesAutoresizingMaskIntoConstraints = NO;
        _views[holeElem.key] = holeView;
        [lineView addSubview:holeView];
        [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[holeView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(holeView)]];
        [lineElements addObject:[NSString stringWithFormat:@"[%@]", holeId]];
        mapping[holeId] = holeView;
      } else if ([elem isKindOfClass:[PXButtonElement class]]) {
        PXBlockButton *button = [[PXBlockButton alloc] initWithBlock:^{
          ((PXButtonElement *) elem).action();
        }];
        PXButtonElement *butElem = (PXButtonElement *) elem;
        [button setTitle:butElem.text forState:UIControlStateNormal];
        [button setTitleColor:butElem.color forState:UIControlStateNormal];
        NSString *buttonId = [NSString stringWithFormat:@"button%d", ctr++];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [lineView addSubview:button];
        [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        [lineElements addObject:[NSString stringWithFormat:@"[%@]", buttonId]];
        mapping[buttonId] = button;
      }
    }
    NSString *horizontalConstraint = [lineElements componentsJoinedByString:@"-tokenSpace-"];
    [lineView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|%@|", horizontalConstraint] options:0 metrics:@{@"indent" : @(kEditorIndent), @"tokenSpace" : @(kEditorTokenSpacing)} views:mapping]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView)]];
  }

  NSString *verticalConstraint = [lineIds componentsJoinedByString:@"-lineSpace-"];
  NSMutableArray *horizontalConstraintParts = [NSMutableArray arrayWithArray:lineConstraints];
  [horizontalConstraintParts addObject:@"==0@low"];
  NSString *horizontalConstraintSizes = [horizontalConstraintParts componentsJoinedByString:@","];
  lineMapping[@"self"] = view;
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[self(%@)]", horizontalConstraintSizes] options:0 metrics:@{@"tokenSpace" : @(kEditorTokenSpacing), @"low" : @(UILayoutPriorityDefaultLow)} views:lineMapping]];
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalConstraint] options:0 metrics:@{@"lineSpace" : @(kEditorLineSpacing)} views:lineMapping]];
}

- (void)buttonPushed:(UIButton *)buttonPushed {

}

@end