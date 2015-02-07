@class PXBuiltin;
#ifdef _DEFAULT_BUILTINS_IMPL_
#define EXTERN
#else
#define EXTERN extern
#endif

EXTERN PXBuiltin *builtin_add;
EXTERN PXBuiltin *builtin_sub;
EXTERN PXBuiltin *builtin_mul;
EXTERN PXBuiltin *builtin_div;

EXTERN PXBuiltin *builtin_eq;
EXTERN PXBuiltin *builtin_lt;
EXTERN PXBuiltin *builtin_lte;
EXTERN PXBuiltin *builtin_gt;
EXTERN PXBuiltin *builtin_gte;