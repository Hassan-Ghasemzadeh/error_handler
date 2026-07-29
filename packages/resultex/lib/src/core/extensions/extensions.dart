/// A centralized barrel file for all [Result] extensions in the `resultex` package.
///
/// This file categorizes and exports various utility extensions to enhance 
/// the functionality, readability, and integration capabilities of the [Result] 
/// type across different domains.

// ==========================================
// ASYNC & CONCURRENCY EXTENSIONS
// ==========================================
/// Extensions for handling asynchronous operations, Futures, Streams, and concurrency.
export 'async/advance_async_result_extension.dart';
export 'async/future_result_extension.dart';
export 'async/future_retry_extensions.dart';
export 'async/result_concurrency_extension.dart';
export 'async/result_stream_extension.dart';

// ==========================================
// COLLECTION EXTENSIONS
// ==========================================
/// Extensions for processing Iterables, list accumulations, and collections of Results.
export 'collections/result_iterable_extension.dart';
export 'collections/result_accumulator_extension.dart';

// ==========================================
// INTEGRATION EXTENSIONS
// ==========================================
/// Ecosystem bridges for seamless integration with Flutter UI, BLoC, and ValueNotifiers.
export 'integrations/result_bloc_extension.dart';
export 'integrations/result_flutterx_extension.dart';
export 'integrations/result_notifier_extension.dart';

// ==========================================
// TRANSFORMATION & RECOVERY EXTENSIONS
// ==========================================
/// Core functional operations for mapping, filtering, unwrapping, and error recovery.
export 'transform/result_failure_mapping_extension.dart';
export 'transform/result_filter_extension.dart';
export 'transform/result_recovery_extension.dart';
export 'transform/result_transformation.dart';
export 'transform/result_unwrap_extension.dart';
export 'transform/unit_extension.dart';
export 'transform/result_zip_record_extension.dart';