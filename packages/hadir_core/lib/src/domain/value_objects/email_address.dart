import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/value_objects/value_object.dart';

class EmailAddressFailure extends ValueFailure<String> {
  @override
  String get message => 'Invalid email address format';
}

class EmailAddress extends ValueObject<String> {
  factory EmailAddress(String input) {
    return EmailAddress._(
      _validateEmailAddress(input),
    );
  }

  const EmailAddress._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;

  static Either<ValueFailure<String>, String> _validateEmailAddress(
    String input,
  ) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
    if (RegExp(emailRegex).hasMatch(input)) {
      return right(input);
    } else {
      return left(EmailAddressFailure());
    }
  }
}
