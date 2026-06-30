/// A centralized error handling and operation execution library.
/// 
/// This library provides a unified interface for monadic result wrappers, 
/// operational boundary executors, and error monitoring handlers, abstracting 
/// the internal project file structure from external consumer packages.
library;

// Export the core bootstrapping error handler coordinator.
export 'src/error_handler_base.dart';

// Export the monadic Result wrapper model (Success and Failure structures).
export 'src/model/result.dart';

// Export the operation runner engine that wraps runtime execution flows.
export 'src/result/result_executor.dart';