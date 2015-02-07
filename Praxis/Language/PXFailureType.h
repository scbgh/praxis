
typedef enum PXFailureType {
  PXNotAFailure,
  PXTypeMismatchFailure,
  PXUnboundIdentifierFailure,
  PXUnspecifiedIdentifierFailure,
  PXExpressionTypeUnimplementedFailure,
  PXUnknownExpressionStateFailure,
  PXUnspecifiedValueFailure,
  PXInternalExecutionFailure,
  PXExpressionMissingFailure,
  PXArgumentCountMismatchFailure,
  PXUnknownFailure
} PXFailureType;