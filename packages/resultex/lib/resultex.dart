/// A centralized error handling and operation execution library.
///
/// This library provides a unified interface for monadic result wrappers,
/// operational boundary executors, and error monitoring handlers, abstracting
/// the internal project file structure from external consumer packages.
library;

/// Exports the base bootstrapping components and core configurations
/// for the Resultex library.
export 'src/resultex_base.dart';

/// Exports the monadic [Result] wrapper model alongside its terminal variants:
/// (SuccessResult) and (FailureResult).
export 'src/model/result.dart';

/// Exports the operation runner engine that wraps runtime execution flows
/// in protected try-catch boundaries.
export 'src/result_executor/result_executor.dart';

/// Exports the reactive (ResultBuilder) widget, which listens to state changes
/// in a (ResultNotifier) to rebuild the UI subtree.
export 'src/ui/widget/result_builder.dart';

/// Exports the presentation-focused (ResultSwitch) widget, used to map
/// static [Result] states directly to their visual counterparts.
export 'src/ui/widget/result_switch.dart';

/// Exports the (ResultNotifier), a specialized value listener designed to hold
/// and emit reactive [Result] states.
export 'src/ui/notifier/result_notifier.dart';

/// Exports utilities for managing asynchronous operations that can be cancelled
/// mid-flight, returning a graceful cancellation state.
export 'core/utils/cancellable_result.dart';

/// Exports collection helpers to safely process, filter, and manage lists or
/// groups of independent [Result] objects.
export 'core/utils/result_collection.dart';

/// Exports performance optimization utilities to cache and recall the outcomes
/// of expensive or repetitive [Result]-yielding operations.
export 'core/utils/result_memoizer.dart';

/// Exports generic functional helper utilities and extension methods (such as map,
/// then, and combine) to streamline [Result] manipulation.
export 'core/utils/result_utils.dart';
