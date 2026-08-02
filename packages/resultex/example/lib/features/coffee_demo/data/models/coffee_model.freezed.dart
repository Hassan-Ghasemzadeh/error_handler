// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coffee_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoffeeModel {
  int get id;
  String get title;
  String get description;
  String get image;
  @JsonKey(fromJson: _parseIngredients)
  List<String> get ingredients;

  /// Create a copy of CoffeeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CoffeeModelCopyWith<CoffeeModel> get copyWith =>
      _$CoffeeModelCopyWithImpl<CoffeeModel>(this as CoffeeModel, _$identity);

  /// Serializes this CoffeeModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CoffeeModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality()
                .equals(other.ingredients, ingredients));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, image,
      const DeepCollectionEquality().hash(ingredients));

  @override
  String toString() {
    return 'CoffeeModel(id: $id, title: $title, description: $description, image: $image, ingredients: $ingredients)';
  }
}

/// @nodoc
abstract mixin class $CoffeeModelCopyWith<$Res> {
  factory $CoffeeModelCopyWith(
          CoffeeModel value, $Res Function(CoffeeModel) _then) =
      _$CoffeeModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String image,
      @JsonKey(fromJson: _parseIngredients) List<String> ingredients});
}

/// @nodoc
class _$CoffeeModelCopyWithImpl<$Res> implements $CoffeeModelCopyWith<$Res> {
  _$CoffeeModelCopyWithImpl(this._self, this._then);

  final CoffeeModel _self;
  final $Res Function(CoffeeModel) _then;

  /// Create a copy of CoffeeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? image = null,
    Object? ingredients = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _self.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CoffeeModel].
extension CoffeeModelPatterns on CoffeeModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CoffeeModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoffeeModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CoffeeModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoffeeModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CoffeeModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoffeeModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String title, String description, String image,
            @JsonKey(fromJson: _parseIngredients) List<String> ingredients)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoffeeModel() when $default != null:
        return $default(_that.id, _that.title, _that.description, _that.image,
            _that.ingredients);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String title, String description, String image,
            @JsonKey(fromJson: _parseIngredients) List<String> ingredients)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoffeeModel():
        return $default(_that.id, _that.title, _that.description, _that.image,
            _that.ingredients);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String title, String description, String image,
            @JsonKey(fromJson: _parseIngredients) List<String> ingredients)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoffeeModel() when $default != null:
        return $default(_that.id, _that.title, _that.description, _that.image,
            _that.ingredients);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CoffeeModel implements CoffeeModel {
  const _CoffeeModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      @JsonKey(fromJson: _parseIngredients)
      required final List<String> ingredients})
      : _ingredients = ingredients;
  factory _CoffeeModel.fromJson(Map<String, dynamic> json) =>
      _$CoffeeModelFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String image;
  final List<String> _ingredients;
  @override
  @JsonKey(fromJson: _parseIngredients)
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  /// Create a copy of CoffeeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CoffeeModelCopyWith<_CoffeeModel> get copyWith =>
      __$CoffeeModelCopyWithImpl<_CoffeeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CoffeeModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CoffeeModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, image,
      const DeepCollectionEquality().hash(_ingredients));

  @override
  String toString() {
    return 'CoffeeModel(id: $id, title: $title, description: $description, image: $image, ingredients: $ingredients)';
  }
}

/// @nodoc
abstract mixin class _$CoffeeModelCopyWith<$Res>
    implements $CoffeeModelCopyWith<$Res> {
  factory _$CoffeeModelCopyWith(
          _CoffeeModel value, $Res Function(_CoffeeModel) _then) =
      __$CoffeeModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String image,
      @JsonKey(fromJson: _parseIngredients) List<String> ingredients});
}

/// @nodoc
class __$CoffeeModelCopyWithImpl<$Res> implements _$CoffeeModelCopyWith<$Res> {
  __$CoffeeModelCopyWithImpl(this._self, this._then);

  final _CoffeeModel _self;
  final $Res Function(_CoffeeModel) _then;

  /// Create a copy of CoffeeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? image = null,
    Object? ingredients = null,
  }) {
    return _then(_CoffeeModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _self._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
