import '../../../resultex.dart';

/// Represents a type with only one singular value.
///
/// Used in functional programming architectures as a clean, type-safe substitute
/// for [void] or [null] returned from side-effect operations.
final class Unit {
  const Unit._();
}

/// The single, immutable concrete instance of the [Unit] type.
const Unit unit = Unit._();

/// A highly expressive type alias representing an operation that completes
/// with zero return data but can still implicitly fail.
typedef VoidResult = Result<Unit>;

/// Extension helper to quickly generate successful void outcomes.
extension VoidResultX on Result<Unit> {
  /// Syntactic sugar to return a successful [VoidResult] instantly.
  VoidResult success() => Result.success(unit);
}
