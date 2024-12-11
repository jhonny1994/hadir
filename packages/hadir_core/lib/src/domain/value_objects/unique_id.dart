import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/value_objects/value_object.dart';
import 'package:uuid/uuid.dart';

class UniqueIdFailure extends ValueFailure<String> {
  @override
  String get message => 'Invalid UUID format';
}

class UniqueId extends ValueObject<String> {
  factory UniqueId() {
    return UniqueId._(
      right(const Uuid().v4()),
    );
  }

  factory UniqueId.fromString(String input) {
    return UniqueId._(
      _validateUuid(input),
    );
  }

  const UniqueId._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;

  static Either<ValueFailure<String>, String> _validateUuid(String input) {
    try {
      if (input.isEmpty) return left(UniqueIdFailure());
      return right(input);
    } catch (_) {
      return left(UniqueIdFailure());
    }
  }
}
