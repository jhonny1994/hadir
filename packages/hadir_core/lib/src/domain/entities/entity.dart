import 'package:meta/meta.dart';

@immutable
abstract class Entity {
  const Entity();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Entity;
  }

  @override
  int get hashCode => 0;
}
