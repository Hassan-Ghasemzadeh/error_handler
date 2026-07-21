/// A centralized error handling, state management, and operation execution library.
///
/// This library provides a unified interface for monadic result wrappers,
/// operational boundary executors, and reactive UI components, abstracting
/// the internal project file structure from external consumer packages.
library;

// ==========================================
// CORE BOOTSTRAP & CONFIGURATION
// ==========================================

/// Exports the base bootstrapping components, including the [Resultex] facade
/// for initializing dependency injection and global error handlers.
export 'src/resultex_base.dart';

// ==========================================
// MODELS & STATE WRAPPERS
// ==========================================

/// Exports the monadic [Result] wrapper model alongside its terminal variants:
/// [SuccessResult] and [FailureResult].
export 'src/model/result.dart';

/// Exports the base [Failure] domain model for standardized error representation.
export 'src/model/failure.dart';

/// Exports the base [Success] domain model for standardized successful payload representation.
export 'src/model/success.dart';

// ==========================================
// EXECUTION ENGINE
// ==========================================

/// Exports the [ResultExecutor], the operation runner engine that wraps runtime
/// execution flows in protected try-catch boundaries.
export 'src/result_executor/result_executor.dart';

// ==========================================
// REACTIVE UI COMPONENTS
// ==========================================

/// Exports the [ResultNotifier], a specialized value listener designed to hold
/// and emit reactive [Result] states.
export 'src/ui/notifier/result_notifier.dart';

/// Exports the [ResultBuilder] widget, which reactively listens to state changes
/// in a [ResultNotifier] to seamlessly rebuild the UI subtree.
export 'src/ui/widget/result_builder.dart';

/// Exports the [ResultSwitch] widget, a presentation-focused component used to map
/// static [Result] states directly to their visual counterparts.
export 'src/ui/widget/result_switch.dart';

/// Exports the [ResultListener] widget, designed for handling non-rebuilding
/// side-effects (such as navigation, dialogs, or snackbars) on state changes.
export 'src/ui/widget/result_listener.dart';

/// Exports the [ResultConsumer] widget, combining [ResultListener] and [ResultBuilder]
/// for unified side-effect execution and UI rebuilding.
export 'src/ui/widget/result_consumer.dart';

/// Exports the [MultiResultBuilder] widget, observing a dynamic list of
/// [ResultNotifier] instances for combined UI rendering.
export 'src/ui/widget/multi_result_builder.dart';

// ==========================================
// UTILITIES & EXTENSIONS
// ==========================================

/// Exports generic functional helper utilities and extension methods (such as map,
/// then, and combine) to streamline [Result] manipulation.
export 'core/utils/result_utils.dart';

/// Exports utilities for managing asynchronous operations that can be cancelled
/// mid-flight, returning a graceful cancellation state.
export 'core/utils/cancellable_result.dart';

/// Exports collection helpers to safely process, filter, and manage lists or
/// groups of independent [Result] objects.
export 'core/utils/result_collection.dart';

/// Exports performance optimization utilities to cache and recall the outcomes
/// of expensive or repetitive [Result]-yielding operations.
export 'core/utils/result_memoizer.dart';

/// Exports rate-limiting functional extensions (debounce & throttle) for [ResultNotifier].
export 'core/extensions/result_notifier_fpx.dart';

/// Exports auto-retry with exponential backoff mechanism for async result functions and notifiers.
export 'core/extensions/future_retry_extensions.dart';
